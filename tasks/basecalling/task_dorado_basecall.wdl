version 1.0

task basecall {
  input {
    File input_file                    # Single POD5 file for scatter processing
    String dorado_model = "sup"         # Default model to 'sup', can be overridden with full model name see docs
    String kit_name                    # Sequencing kit name
    Int disk_size = 100
    Int memory = 32
    Int cpu = 8
    String docker = "us-docker.pkg.dev/general-theiagen/staphb/dorado:0.8.0"
  }

  command <<< 
    set -euo pipefail

    # Capture Dorado version and log it
    dorado --version > DORADO_VERSION 2>&1
    echo "Captured Dorado version:" $(cat DORADO_VERSION)

    # Define the model to use, substituting "sup" with the full model name if given
    resolved_model="~{dorado_model}"
    if [ "$resolved_model" = "sup" ]; then
      resolved_model="dna_r10.4.1_e8.2_400bps_sup@v5.0.0"
    fi

    # Log the resolved model namet
    echo "Using Dorado model: $resolved_model"
    echo "$resolved_model" > "DORADO_MODEL"

    # Define a log file path to capture output
    log_file="dorado_basecall.log"

    # Create a unique output directory for each scatter job
    base_name=$(basename "~{input_file}" .pod5)
    sam_output="output/sam_${base_name}/"
    mkdir -p "$sam_output"

    echo "### Starting basecalling for ~{input_file} ###" | tee -a "$log_file"

    # Set SAM file path with unique naming based on POD5 basename
    sam_file="$sam_output/${base_name}.sam"

    echo "Processing ~{input_file}, expected output: $sam_file" | tee -a "$log_file"

    # Run Dorado basecaller and log output
    dorado basecaller \
      "~{dorado_model}" \
      "~{input_file}" \
      --kit-name ~{kit_name} \
      --emit-sam \
      --no-trim \
      --output-dir "$sam_output" \
      --verbose | tee -a "$log_file" || { echo "ERROR: Dorado basecaller failed for ~{input_file}"; exit 1; }

    # Rename the generated SAM file to the unique name based on input_file
    generated_sam=$(find "$sam_output" -name "*.sam" | head -n 1)
    mv "$generated_sam" "$sam_file"

    echo "Basecalling completed for ~{input_file}. SAM file renamed to: $sam_file" | tee -a "$log_file"
  >>>
  
  output {
    Array[File] sam_files = glob("output/sam_*/*.sam")
    String dorado_docker = docker
    String dorado_version = read_string("DORADO_VERSION")
    String dorado_model_used = read_string("DORADO_MODEL")
  }
  
  runtime {
    docker: docker
    cpu: cpu
    memory: "~{memory} GB"
    disks: "local-disk " + disk_size + " SSD"
    gpuCount: 1
    gpuType: "nvidia-tesla-t4"  
    preemptible: 0
    maxRetries: 1
  }
}
