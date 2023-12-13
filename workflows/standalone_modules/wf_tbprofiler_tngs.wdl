version 1.0

import "../../tasks/species_typing/task_clockwork.wdl" as clockwork_task
import "../../tasks/species_typing/task_tbprofiler.wdl" as tbprofiler_task
import "../../tasks/species_typing/task_tbp_parser.wdl" as tbp_parser_task
import "../../tasks/task_versioning.wdl" as versioning

workflow tbprofiler_tngs {
  meta {
    description: "Runs QC, clockwork, tbprofiler, and tbp-parser on tNGS TB data"
  }
  input {
    File read1
    File read2
    String samplename
  }
  call versioning.version_capture {
    input:
  }
  # call clockwork_task.clockwork_decon_reads {
  #   input: 
  #     read1 = read1,
  #     read2 = read2,
  #     samplename = samplename
  # } 
  call tbprofiler_task.tbprofiler {
    input:
      # read1 = clockwork_decon_reads.clockwork_cleaned_read1,
      # read2 = clockwork_decon_reads.clockwork_cleaned_read2,
      read1 = read1,
      read2 = read2,
      samplename = samplename
  }
  call tbp_parser_task.tbp_parser {
    input:
      tbprofiler_json = tbprofiler.tbprofiler_output_json,
      tbprofiler_bam = tbprofiler.tbprofiler_output_bam,
      tbprofiler_bai = tbprofiler.tbprofiler_output_bai,
      samplename = samplename
  }
  output {
    # clockwork outputs
    # File clockwork_cleaned_read1 = clockwork_decon_reads.clockwork_cleaned_read1
    # File clockwork_cleaned_read2 = clockwork_decon_reads.clockwork_cleaned_read2
    # String clockwork_version = clockwork_decon_reads.clockwork_version
    # tbprofiler outputs
    File tbprofiler_report_csv = tbprofiler.tbprofiler_output_csv
    File tbprofiler_report_tsv = tbprofiler.tbprofiler_output_tsv
    File tbprofiler_report_json = tbprofiler.tbprofiler_output_json
    File tbprofiler_output_alignment_bam = tbprofiler.tbprofiler_output_bam
    File tbprofiler_output_alignment_bai = tbprofiler.tbprofiler_output_bai
    String tbprofiler_version = tbprofiler.version
    String tbprofiler_main_lineage = tbprofiler.tbprofiler_main_lineage
    String tbprofiler_sub_lineage = tbprofiler.tbprofiler_sub_lineage
    String tbprofiler_dr_type = tbprofiler.tbprofiler_dr_type
    String tbprofiler_num_dr_variants = tbprofiler.tbprofiler_num_dr_variants
    String tbprofiler_num_other_variants = tbprofiler.tbprofiler_num_other_variants
    String tbprofiler_resistance_genes = tbprofiler.tbprofiler_resistance_genes
    Int tbprofiler_median_coverage = tbprofiler.tbprofiler_median_coverage
    Float tbprofiler_pct_reads_mapped = tbprofiler.tbprofiler_pct_reads_mapped
    # tbp_parser outputs
    File tbp_parser_looker_report_csv = tbp_parser.tbp_parser_looker_report_csv
    File tbp_parser_laboratorian_report_csv = tbp_parser.tbp_parser_laboratorian_report_csv
    File tbp_parser_lims_report_csv = tbp_parser.tbp_parser_lims_report_csv
    File tbp_parser_coverage_report = tbp_parser.tbp_parser_coverage_report
    Float tbp_parser_genome_percent_coverage = tbp_parser.tbp_parser_genome_percent_coverage
    Float tbp_parser_average_genome_depth = tbp_parser.tbp_parser_average_genome_depth
    String tbp_parser_version = tbp_parser.tbp_parser_version
    String tbp_parser_docker = tbp_parser.tbp_parser_docker
    # version capture outputs
    String tbprofiler_tngs_wf_analysis_date = version_capture.date
    String tbprofiler_tngs_wf_version = version_capture.phb_version
  }
}