version 1.0

task bandage_plot {
    input {
      File assembly_graph_gfa
      String samplename
      Int cpu = 2
      Int memory = 4
      Int disk_size = 10
      String docker = "us-docker.pkg.dev/general-theiagen/staphb/bandage:0.8.1"
    }
    command <<< 
      bandage --version | tee VERSION
      Bandage image ~{assembly_graph_gfa} ~{samplename}_bandage_plot.png
    >>>
    output {
      File plot = "~{output_prefix}.png"
      String version = read_string("VERSION")
    }
    runtime {
      docker: "~{docker}"
      cpu: cpu
      memory: "~{memory} GB"
      disks: "local-disk " + disk_size + " HDD"
      disk: disk_size + " GB"
      maxRetries: 3
      preemptible: 0
  }
}