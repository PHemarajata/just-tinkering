version 1.0

task tbprofiler {
  input {
    File read1
    File? read2
    String samplename
    String docker = "us-docker.pkg.dev/general-theiagen/staphb/tbprofiler:6.2.0"
    Int disk_size = 100
    Int memory = 16
    String mapper = "bwa"
    String variant_caller = "freebayes"
    String? variant_calling_params
    Int min_depth = 10
    Float min_af = 0.1
    Float min_af_pred = 0.1
    Int cov_frac_threshold = 1
    Int cpu = 8 
    Boolean ont_data = false
    String? tbprofiler_custom_db
    Boolean tbprofiler_run_custom_db = false
    Boolean tbprofiler_run_cdph_db = false
  }
  command <<<
    # Print and save date
    date | tee DATE

    # Print and save version
    tb-profiler version > VERSION && sed -i -e 's/TBProfiler version //' VERSION && sed -n -i '$p' VERSION
    
    # check if file is non existant or non empty
    if [ -z "~{read2}" ] || [ ! -s "~{read2}" ]; then
      INPUT_READS="-1 ~{read1}"
    else
      INPUT_READS="-1 ~{read1} -2 ~{read2}"
    fi
    
    if ~{ont_data}; then
      mode="--platform nanopore"
      export ont_data="true"
    else
      export ont_data="false"
    fi

    # check if new database file is provided and not empty
    if ~{tbprofiler_run_custom_db}; then
      tb-profiler load_library ~{tbprofiler_custom_db}

      TBDB="--db ~{tbprofiler_custom_db}"
    elif ~{tbprofiler_run_cdph_db}; then
      tb-profiler update_tbdb --branch CaliforniaDPH
      TBDB="--db CaliforniaDPH"
    else
      TBDB="" 6tt6
    fi

    # Run tb-profiler on the input reads with samplename prefix
    tb-profiler profile \
      ${mode} \
      ${INPUT_READS} \
      --prefix ~{samplename} \
      --mapper ~{mapper} \
      --caller ~{variant_caller} \
      --calling_params "~{variant_calling_params}" \
      --depth ~{min_depth} \
      --af ~{min_af} \
      --csv --txt \
      ${TBDB}

    # Collate results
    tb-profiler collate --prefix ~{samplename}

    # touch optional output files because wdl
    touch GENE_NAME LOCUS_TAG VARIANT_SUBSTITUTIONS OUTPUT_SEQ_METHOD_TYPE

    # merge all vcf files if multiple are present
    bcftools index ./vcf/*bcf
    bcftools index ./vcf/*gz
    bcftools merge --force-samples ./vcf/*bcf ./vcf/*gz > ./vcf/~{samplename}.targets.csq.merged.vcf

    python3 <<CODE
    import csv
    import json
    import os

    with open("./~{samplename}.txt",'r') as tsv_file:
      tsv_reader=csv.reader(tsv_file, delimiter="\t")
      tsv_data=list(tsv_reader)
      tsv_dict=dict(zip(tsv_data[0], tsv_data[1]))
      with open ("MAIN_LINEAGE", 'wt') as main_lineage:
        main_lineage.write(tsv_dict['main_lineage'])
      with open ("SUB_LINEAGE", 'wt') as sublineage:
        sublineage.write(tsv_dict['sub_lineage'])
      with open ("DR_TYPE", 'wt') as dr_type:
        dr_type.write(tsv_dict['drtype'])
      with open ("NUM_DR_VARIANTS", 'wt') as num_dr_variants:
        num_dr_variants.write(tsv_dict['num_dr_variants'])
      with open ("NUM_OTHER_VARIANTS", 'wt') as num_other_variants:
        num_other_variants.write(tsv_dict['num_other_variants'])
      with open ("RESISTANCE_GENES", 'wt') as resistance_genes:
        res_genes_list=['rifampicin', 'isoniazid', 'ethambutol', 'pyrazinamide', 'moxifloxacin', 'levofloxacin', 'bedaquiline', 'delamanid', 'pretomanid', 'linezolid', 'streptomycin', 'amikacin', 'kanamycin', 'capreomycin', 'clofazimine', 'ethionamide', 'para-aminosalicylic_acid', 'cycloserine']
        res_genes=[]
        for i in res_genes_list:
          if tsv_dict[i] != '-':
            res_genes.append(tsv_dict[i])
        res_genes_string=';'.join(res_genes)
        resistance_genes.write(res_genes_string)
      with open ("MEDIAN_DEPTH", 'wt') as median_depth:
        median_depth.write(tsv_dict['target_median_depth'])
      with open ("PCT_READS_MAPPED", 'wt') as pct_reads_mapped:
        pct_reads_mapped.write(tsv_dict['pct_reads_mapped'])
    CODE
  >>>
  output {
    File tbprofiler_output_csv = "./results/~{samplename}.results.csv"
    File tbprofiler_output_tsv = "./results/~{samplename}.results.txt"
    File tbprofiler_output_json = "./results/~{samplename}.results.json"
    File tbprofiler_output_bam = "./bam/~{samplename}.bam"
    File tbprofiler_output_bai = "./bam/~{samplename}.bam.bai"
    File tbprofiler_output_vcf = "./vcf/~{samplename}.targets.csq.merged.vcf"
    String version = read_string("VERSION")
    String tbprofiler_main_lineage = read_string("MAIN_LINEAGE")
    String tbprofiler_sub_lineage = read_string("SUB_LINEAGE")
    String tbprofiler_dr_type = read_string("DR_TYPE")
    String tbprofiler_num_dr_variants = read_string("NUM_DR_VARIANTS")
    String tbprofiler_num_other_variants = read_string("NUM_OTHER_VARIANTS")
    String tbprofiler_resistance_genes = read_string("RESISTANCE_GENES")
    Int tbprofiler_median_depth = read_int("MEDIAN_DEPTH")
    Float tbprofiler_pct_reads_mapped = read_float("PCT_READS_MAPPED")
  }
  runtime {
    docker: "~{docker}"
    memory: memory + " GB"
    cpu: cpu
    disks: "local-disk " + disk_size + " SSD"
    disk: disk_size + " GB"
    maxRetries: 3
    preemptible: 1
  }
}