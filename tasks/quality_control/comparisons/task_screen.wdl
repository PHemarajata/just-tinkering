version 1.0

task check_reads {
  input {
    File read1
    File read2
    Int min_reads
    Int min_basepairs
    Int min_genome_length
    Int max_genome_length
    Int min_coverage
    Int min_proportion
    Boolean skip_screen
    String workflow_series = "theiaprok" # default to theiaprok so we don't have to change those workflows
    String? organism
    Int? expected_genome_length # user-provided
    Int disk_size = 100
    String docker = "us-docker.pkg.dev/general-theiagen/bactopia/gather_samples:2.0.2"
    Int memory = 2
    Int cpu = 1
  }
  command <<<
    # just in case anything fails, throw an error
    set -euo pipefail
    
    flag="PASS"

    # initalize estimated genome length
    estimated_genome_length=0
    if [[ "~{skip_screen}" == "false" ]] ; then
      
      # set cat command based on compression
      if [[ "~{read1}" == *".gz" ]] ; then
        cat_reads="zcat"
      else
        cat_reads="cat"
      fi

      # check one: number of reads
      read1_num=$($cat_reads ~{read1} | fastq-scan | grep 'read_total' | sed 's/[^0-9]*\([0-9]\+\).*/\1/')
      read2_num=$($cat_reads ~{read2} | fastq-scan | grep 'read_total' | sed 's/[^0-9]*\([0-9]\+\).*/\1/')
      echo "DEBUG: Number of reads in R1: ${read1_num}"
      echo "DEBUG: Number of reads in R2: ${read2_num}"

      reads_total=$(expr $read1_num + $read2_num)
      echo "DEBUG: Number of reads total in R1 and R2: ${reads_total}"

      if [ "${reads_total}" -le "~{min_reads}" ]; then
        flag="FAIL; the total number of reads is below the minimum of ~{min_reads}"
      else
        flag="PASS"
      fi

      # checks two and three: number of basepairs and proportion of sequence
      if [ "${flag}" == "PASS" ]; then
        # count number of basepairs
        # using fastq-scan to count the number of basepairs in each fastq
        read1_bp=$(eval "${cat_reads} ~{read1}" | fastq-scan | grep 'total_bp' | sed 's/[^0-9]*\([0-9]\+\).*/\1/')
        read2_bp=$(eval "${cat_reads} ~{read2}" | fastq-scan | grep 'total_bp' | sed 's/[^0-9]*\([0-9]\+\).*/\1/')
        echo "DEBUG: Number of basepairs in R1: $read1_bp"
        echo "DEBUG: Number of basepairs in R2: $read2_bp"

        # set proportion variables for easy comparison
        # removing the , 2) to make these integers instead of floats
        percent_read1=$(python3 -c "print(round(($read1_bp / ($read1_bp + $read2_bp))*100))")
        percent_read2=$(python3 -c "print(round(($read2_bp / ($read1_bp + $read2_bp))*100))")

        if [ "$percent_read1" -lt "~{min_proportion}" ] ; then
          flag="FAIL; more than ~{min_proportion} percent of the total sequence is found in R2 (BP: $read2_bp; PERCENT: $percent_read2) compared to R1 (BP: $read1_bp; PERCENT: $percent_read1)"
        elif [ "$percent_read2" -lt "~{min_proportion}" ] ; then
          flag="FAIL; more than ~{min_proportion} percent of the total sequence is found in R1 (BP: $read1_bp; PERCENT: $percent_read1) compared to R2 (BP: $read2_bp; PERCENT: $percent_read2)"
        else
          flag="PASS"
        fi

        # check total number of basepairs 
        if [ "$flag" == "PASS" ] ; then
          bp_total=$(expr $read1_bp + $read2_bp)

          if [ "${bp_total}" -le "~{min_basepairs}" ]; then
            flag="FAIL; the total number of basepairs is below the minimum of ~{min_basepairs}"
          else
            flag="PASS"
          fi
        fi    
      fi

      #checks four and five: estimated genome length and coverage
      if [ "${flag}" == "PASS" ]; then
        # estimate genome length if theiaprok AND expected_genome_length was not provided
        if [ "~{workflow_series}" == "theiaprok" ] && [[ -z "~{expected_genome_length}" ]]; then
          # First Pass; assuming average depth
          mash sketch -o test -k 31 -m 3 -r ~{read1} ~{read2} > mash-output.txt 2>&1
          grep "Estimated genome size:" mash-output.txt | \
            awk '{if($4){printf("%5.0f\n", $4)}} END {if (!NR) print "0"}' > genome_length_output
          grep "Estimated coverage:" mash-output.txt | \
            awk '{if($3){printf("%d", $3)}} END {if (!NR) print "0"}' > coverage_output
          rm -rf test.msh
          rm -rf mash-output.txt
          estimated_genome_length=`head -n1 genome_length_output`
          estimated_coverage=`head -n1 coverage_output`

          # Check if second pass is needed
          if [ ${estimated_genome_length} -gt "~{max_genome_length}" ] || [ ${estimated_genome_length} -lt "~{min_genome_length}" ] ; then
            # Probably high coverage, try increasing number of kmer copies to 10
            M="-m 10"
            if [ ${estimated_genome_length} -lt "~{min_genome_length}" ]; then
              # Probably low coverage, try decreasing the number of kmer copies to 1
              M="-m 1"
            fi
            mash sketch -o test -k 31 ${M} -r ~{read1} ~{read2} > mash-output.txt 2>&1
            grep "Estimated genome size:" mash-output.txt | \
              awk '{if($4){printf("%5.0f\n", $4)}} END {if (!NR) print "0"}' > genome_length_output
            grep "Estimated coverage:" mash-output.txt | \
              awk '{if($3){printf("%d", $3)}} END {if (!NR) print "0"}' > coverage_output
            rm -rf test.msh
            rm -rf mash-output.txt
          fi
          
          estimated_genome_length=`head -n1 genome_length_output`
          estimated_coverage=`head -n1 coverage_output`
        
        # estimate coverage if theiacov OR expected_genome_length was provided
        elif [ "~{workflow_series}" == "theiacov" ] || [ "~{expected_genome_length}" ]; then
          if [ "~{expected_genome_length}" ]; then
            estimated_genome_length=~{expected_genome_length} # use user-provided expected_genome_length
          fi

          # coverage is calculated here by N/G where N is number of bases, and G is genome length
          # this will nearly always be an overestimation
          if [ $estimated_genome_length -ne 0 ]; then # prevent divided by zero errors
            estimated_coverage=$(python3 -c "print(round(($read1_bp+$read2_bp)/$estimated_genome_length))")
          else # they provided 0 for estimated_genome_length, nice
            estimated_coverage=0
          fi
        else # workflow series was not provided or no est genome length was provided; default to fail
          estimated_genome_length=0
          estimated_coverage=0
        fi

        if [ "${estimated_genome_length}" -ge "~{max_genome_length}" ] && [ "~{workflow_series}" == "theiaprok" ] ; then
          flag="FAIL; the estimated genome length (${estimated_genome_length}) is larger than the maximum of ~{max_genome_length} bps"
        elif [ "${estimated_genome_length}" -le "~{min_genome_length}" ] && [ "~{workflow_series}" == "theiaprok" ] ; then
          flag="FAIL; the estimated genome length (${estimated_genome_length}) is smaller than the minimum of ~{min_genome_length} bps"
        else
          flag="PASS"   
          if [ "${estimated_coverage}" -lt "~{min_coverage}" ] ; then
            flag="FAIL; the estimated coverage (${estimated_coverage}) is less than the minimum of ~{min_coverage}x"
          else
            flag="PASS"
            echo ${estimated_genome_length} | tee EST_GENOME_LENGTH
            echo "DEBUG: estimated_genome_length: ${estimated_genome_length}"
          fi 
        fi
      fi 
    fi 
    
    echo $flag | tee FLAG
    echo $estimated_genome_length | tee EST_GENOME_LENGTH
  >>>
  output {
    String read_screen = read_string("FLAG")
    Int est_genome_length = read_int("EST_GENOME_LENGTH")
  }
  runtime {
    docker: docker
    memory: memory + " GB"
    cpu: cpu
    disks: "local-disk " + disk_size + " SSD"
    disk: disk_size + " GB"
    preemptible: 1
    maxRetries: 3
  }
}

task check_reads_se {
  input {
    File read1
    Int min_reads
    Int min_basepairs
    Int min_genome_length
    Int max_genome_length
    Int min_coverage
    Boolean skip_screen 
    Boolean skip_mash
    String workflow_series = "theiaprok" # default to theiaprok so we don't have to change those workflows
    String? organism
    Int? expected_genome_length
    Int disk_size = 100 
    String docker = "us-docker.pkg.dev/general-theiagen/bactopia/gather_samples:2.0.2"
    Int memory = 2
    Int cpu = 1
  }
  command <<<
    # just in case anything fails, throw an error
    set -euo pipefail

    flag="PASS"

    # initalize estimated genome length
    estimated_genome_length=0

    if [[ "~{skip_screen}" == "false" ]] ; then
      # set cat command based on compression
      if [[ "~{read1}" == *".gz" ]] ; then
        cat_reads="zcat"
      else
        cat_reads="cat"
      fi

      # check one: number of reads via fastq-scan
      read1_num=$($cat_reads ~{read1} | fastq-scan | grep 'read_total' | sed 's/[^0-9]*\([0-9]\+\).*/\1/')
      echo "DEBUG: Number of reads in R1: ${read1_num}"

      if [ "${read1_num}" -le "~{min_reads}" ] ; then
        flag="FAIL; the number of reads (${read1_num}) is below the minimum of ~{min_reads}"
      else
        flag="PASS"
      fi

      # checks two and three: number of basepairs and proportion of sequence
      if [ "${flag}" == "PASS" ]; then
        # count number of basepairs
        # using fastq-scan to count the number of basepairs in each fastq
        read1_bp=$(eval "${cat_reads} ~{read1}" | fastq-scan | grep 'total_bp' | sed 's/[^0-9]*\([0-9]\+\).*/\1/')
        echo "DEBUG: Number of basepairs in R1: $read1_bp"

        if [ "$flag" == "PASS" ] ; then
          if [ "${read1_bp}" -le "~{min_basepairs}" ] ; then
            flag="FAIL; the number of basepairs (${read1_bp}) is below the minimum of ~{min_basepairs}"
          else
            flag="PASS"
          fi
        fi    
      fi

      #checks four and five: estimated genome length and coverage
      if [ "${flag}" == "PASS" ] && [ "~{skip_mash}" == "false" ]; then
        # estimate genome length if theiaprok AND expected_genome_length was not provided
        if [ "~{workflow_series}" == "theiaprok" ] && [[ -z "~{expected_genome_length}" ]]; then
          # First Pass; assuming average depth
          mash sketch -o test -k 31 -m 3 -r ~{read1} > mash-output.txt 2>&1
          grep "Estimated genome size:" mash-output.txt | \
            awk '{if($4){printf("%d", $4)}} END {if (!NR) print "0"}' > genome_length_output
          grep "Estimated coverage:" mash-output.txt | \
            awk '{if($3){printf("%d", $3)}} END {if (!NR) print "0"}' > coverage_output
          
          # remove mash outputs
          rm -rf test.msh
          rm -rf mash-output.txt
          
          estimated_genome_length=`head -n1 genome_length_output`
          estimated_coverage=`head -n1 coverage_output`

          # Check if second pass is needed
          if [ ${estimated_genome_length} -gt "~{max_genome_length}" ] || [ ${estimated_genome_length} -lt "~{min_genome_length}" ] ; then
            # Probably high coverage, try increasing number of kmer copies to 10
            M="-m 10"
            if [ ${estimated_genome_length} -lt "~{min_genome_length}" ]; then
              # Probably low coverage, try decreasing the number of kmer copies to 1
              M="-m 1"
            fi

            mash sketch -o test -k 31 ${M} -r ~{read1} > mash-output.txt 2>&1
            grep "Estimated genome size:" mash-output.txt | \
              awk '{if($4){printf("%d", $4)}} END {if (!NR) print "0"}' > genome_length_output
            grep "Estimated coverage:" mash-output.txt | \
              awk '{if($3){printf("%d", $3)}} END {if (!NR) print "0"}' > coverage_output
            
            # remove mash outputs
            rm -rf test.msh
            rm -rf mash-output.txt
          fi
          
          estimated_genome_length=`head -n1 genome_length_output`
          estimated_coverage=`head -n1 coverage_output`

        # estimate coverage if theiacov OR expected_genome_length was provided
        elif [ "~{workflow_series}" == "theiacov" ] || [ "~{expected_genome_length}" ]; then
          if [ "~{expected_genome_length}" ]; then
            estimated_genome_length=~{expected_genome_length} # use user-provided expected_genome_length
          fi

          # coverage is calculated here by N/G where N is number of bases, and G is genome length
          # this will nearly always be an overestimation
          if [ $estimated_genome_length -ne 0 ]; then # prevent divided by zero errors
            estimated_coverage=$(python3 -c "print(round(($read1_bp)/$estimated_genome_length))")
          else # they provided 0 for estimated_genome_length, nice
            estimated_coverage=0
          fi
        else # workflow series was not provided; default to fail
          estimated_genome_length=0
          estimated_coverage=0
        fi
        if [ "${estimated_genome_length}" -ge "~{max_genome_length}" ] ; then
          flag="FAIL; the estimated genome length (${estimated_genome_length}) is larger than the maximum of ~{max_genome_length} bps"
        elif [ "${estimated_genome_length}" -le "~{min_genome_length}" ] ; then
          flag="FAIL; the estimated genome length (${estimated_genome_length}) is smaller than the minimum of ~{min_genome_length} bps"
        else
          flag="PASS"   
          if [ "${estimated_coverage}" -lt "~{min_coverage}" ] ; then
            flag="FAIL; the estimated coverage (${estimated_coverage}) is less than the minimum of ~{min_coverage}x"
          else
            flag="PASS"
            echo $estimated_genome_length | tee EST_GENOME_LENGTH
          fi 
        fi
      fi 
    fi 
    
    echo $flag | tee FLAG
    echo ${estimated_genome_length} | tee EST_GENOME_LENGTH
    echo "DEBUG: estimated_genome_length: ${estimated_genome_length}"
  >>>
  output {
    String read_screen = read_string("FLAG")
    Int est_genome_length = read_int("EST_GENOME_LENGTH")
  }
  runtime {
    docker: docker
    memory: memory + " GB"
    cpu: cpu
    disks: "local-disk " + disk_size + " SSD"
    disk: disk_size + " GB"
    preemptible: 1
    maxRetries: 3
  }
}