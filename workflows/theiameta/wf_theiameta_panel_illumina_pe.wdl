version 1.0

import "../../tasks/alignment/task_minimap2.wdl" as minimap2_task
import "../../tasks/assembly/task_metaspades.wdl" as metaspades_task
import "../../tasks/quality_control/basic_statistics/task_fastq_scan.wdl" as fastq_scan
import "../../tasks/quality_control/basic_statistics/task_quast.wdl" as quast_task
import "../../tasks/quality_control/read_filtering/task_pilon.wdl" as pilon_task
import "../../tasks/task_versioning.wdl" as versioning
import "../../tasks/taxon_id/contamination/task_kraken2.wdl" as kraken_task
import "../../tasks/taxon_id/task_krakentools.wdl" as krakentools_task
import "../../tasks/utilities/data_handling/task_gather_scatter.wdl" as gather_scatter_task
import "../../tasks/utilities/data_handling/task_parse_mapping.wdl" as parse_mapping_task
import "../utilities/wf_morgana_magic.wdl" as morgana_magic_workflow
import "../utilities/wf_read_QC_trim_pe.wdl" as read_qc_trim_pe

workflow theiameta_panel_illumina_pe {
  input {
    String samplename
    File read1
    File read2
    Array[Int] taxon_ids # suggest using a workspace element if user wants to modify?

    Int minimum_read_number = 1000
    File kraken2_db = "gs://theiagen-large-public-files-rp/terra/databases/kraken2/k2_viral_20240112.tar.gz"
  }
  call versioning.version_capture {
    input:
  }
  call read_qc_trim_pe.read_QC_trim_pe as read_QC_trim {
      input:
        samplename = samplename,
        read1 = read1,
        read2 = read2,
        workflow_series = "theiameta"
  }
  # kraken does not run as part of the theiameta track in read_QC_trim -- we may want to change that
  call kraken_task.kraken2_standalone as kraken2 {
    input:
      samplename = samplename,
      read1 = read_QC_trim.read1_clean,
      read2 = read_QC_trim.read2_clean,
      kraken2_db = kraken2_db
  }
  scatter (taxon_id in taxon_ids) {
    call krakentools_task.extract_kraken_reads as krakentools {
      input:
        # we should consider changing the classified_report name so 
        #  it won't be confused with the actual kraken2 report
        kraken2_output = kraken2.kraken2_classified_report,
        kraken2_report = kraken2.kraken2_report,
        read1 = read_QC_trim.read1_clean,
        read2 = read_QC_trim.read2_clean,
        taxon_id = taxon_id
    }
    if (krakentools.success) {
      call fastq_scan.fastq_scan_pe as fastq_scan_binned {
        input:
          read1 = krakentools.extracted_read1,
          read2 = krakentools.extracted_read2
      }
      #### ADJUST IN THE FUTURE; SETTING TO 100 FOR TESTING ####
      if (fastq_scan_binned.read1_seq > minimum_read_number) {
        String did_attempt_assembly = "Assembly attempted"
        call metaspades_task.metaspades_pe {
          input:
            read1_cleaned = krakentools.extracted_read1,
            read2_cleaned = krakentools.extracted_read2,
            samplename = "~{samplename}_~{taxon_id}"
        }
        call minimap2_task.minimap2 as minimap2_assembly_correction {
          input:
            query1 = krakentools.extracted_read1,
            query2 = krakentools.extracted_read2,
            reference = metaspades_pe.assembly_fasta,
            samplename = "~{samplename}_~{taxon_id}",
            mode = "sr",
            output_sam = true
        }
        call parse_mapping_task.sam_to_sorted_bam as sort_bam_assembly_correction {
          input:
            sam = minimap2_assembly_correction.minimap2_out,
            samplename = "~{samplename}_~{taxon_id}"
        }
        call pilon_task.pilon {
          input:
            assembly = metaspades_pe.assembly_fasta,
            bam = sort_bam_assembly_correction.bam,
            bai = sort_bam_assembly_correction.bai,
            samplename = "~{samplename}_~{taxon_id}"
        }    
        call quast_task.quast {
          input:
            assembly = pilon.assembly_fasta,
            samplename = "~{samplename}_~{taxon_id}",
            min_contig_length = 1
        }
        call morgana_magic_workflow.morgana_magic {
          input:
            samplename = "~{samplename}_~{taxon_id}",
            assembly_fasta = pilon.assembly_fasta,
            read1 = krakentools.extracted_read1,
            read2 = krakentools.extracted_read2,
            taxon_id = "~{taxon_id}",
            seq_method = "ILLUMINA"
        }
      }
    }
  }  
  call gather_scatter_task.gather_scatter {
    input:
      samplename = samplename,
      taxon_ids = write_json(taxon_ids),
      organism = write_json(krakentools.organism_name),
      extracted_read1 = write_json(krakentools.extracted_read1),
      extracted_read2 = write_json(krakentools.extracted_read2),
      krakentools_docker = write_json(krakentools.krakentools_docker),
      fastq_scan_num_reads_binned1 = write_json(fastq_scan_binned.read1_seq),
      fastq_scan_num_reads_binned2 = write_json(fastq_scan_binned.read2_seq),
      fastq_scan_num_reads_binned_pairs = write_json(fastq_scan_binned.read_pairs),
      fastq_scan_docker = write_json(fastq_scan_binned.fastq_scan_docker),
      fastq_scan_version = write_json(fastq_scan_binned.version),
      pilon_assembly_fasta = write_json(pilon.assembly_fasta), # maybe??
      quast_genome_length = write_json(quast.genome_length),
      quast_number_contigs = write_json(quast.number_contigs),
      quast_n50 = write_json(quast.n50_value),
      quast_gc_percent = write_json(quast.gc_percent),
      number_N = write_json(morgana_magic.number_N),
      number_ATCG = write_json(morgana_magic.number_ATCG),
      number_Degenerate = write_json(morgana_magic.number_Degenerate),
      number_Total = write_json(morgana_magic.number_Total),
      percent_reference_coverage = write_json(morgana_magic.percent_reference_coverage),
      pango_lineage = write_json(morgana_magic.pango_lineage),
      pango_lineage_expanded = write_json(morgana_magic.pango_lineage_expanded),
      pangolin_conflicts = write_json(morgana_magic.pangolin_conflicts),
      pangolin_notes = write_json(morgana_magic.pangolin_notes),
      pangolin_assignment_version = write_json(morgana_magic.pangolin_assignment_version),
      pangolin_versions = write_json(morgana_magic.pangolin_versions),
      pangolin_docker = write_json(morgana_magic.pangolin_docker),
      nextclade_version = write_json(morgana_magic.nextclade_version),
      nextclade_docker = write_json(morgana_magic.nextclade_docker),
      nextclade_ds_tag = write_json(morgana_magic.nextclade_ds_tag),
      nextclade_aa_subs = write_json(morgana_magic.nextclade_aa_subs),
      nextclade_aa_dels = write_json(morgana_magic.nextclade_aa_dels),
      nextclade_clade = write_json(morgana_magic.nextclade_clade),
      nextclade_lineage = write_json(morgana_magic.nextclade_lineage),
      nextclade_qc = write_json(morgana_magic.nextclade_qc),
      nextclade_ds_tag_flu_ha = write_json(morgana_magic.nextclade_ds_tag_flu_ha),
      nextclade_aa_subs_flu_ha = write_json(morgana_magic.nextclade_aa_subs_flu_ha),
      nextclade_aa_dels_flu_ha = write_json(morgana_magic.nextclade_aa_dels_flu_ha),
      nextclade_clade_flu_ha = write_json(morgana_magic.nextclade_clade_flu_ha),
      nextclade_qc_flu_ha = write_json(morgana_magic.nextclade_qc_flu_ha),
      nextclade_ds_tag_flu_na = write_json(morgana_magic.nextclade_ds_tag_flu_na),
      nextclade_aa_subs_flu_na = write_json(morgana_magic.nextclade_aa_subs_flu_na),
      nextclade_aa_dels_flu_na = write_json(morgana_magic.nextclade_aa_dels_flu_na),
      nextclade_clade_flu_na = write_json(morgana_magic.nextclade_clade_flu_na),
      nextclade_qc_flu_na = write_json(morgana_magic.nextclade_qc_flu_na)
  } 
  output {
    # versioning outputs
    String theiameta_panel_illumina_pe_version = version_capture.phb_version
    String theiameta_panel_illumina_pe_analysis_date = version_capture.date
    # kraken2 outputs
    String kraken2_version = kraken2.kraken2_version
    String kraken2_database = kraken2.kraken2_database
    String kraken2_docker = kraken2.kraken2_docker
    File kraken2_report = kraken2.kraken2_report
    File kraken2_classified_report = kraken2.kraken2_classified_report
    # krakentools outputs
    Array[String] identified_organisms = gather_scatter.organism_names
    File results_by_taxon_tsv = gather_scatter.gathered_results
  }
}