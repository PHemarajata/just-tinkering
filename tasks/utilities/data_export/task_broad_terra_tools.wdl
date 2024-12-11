version 1.0

task export_taxon_tables {
  input {
    String? terra_project
    String? terra_workspace
    String? sample_taxon
    File? taxon_tables
    String? samplename
    Int disk_size = 100
    Int memory = 8
    Int cpu = 1
    String docker = "us-docker.pkg.dev/general-theiagen/theiagen/terra-tools:2023-03-16"
    # TheiaProk Outputs
    File? read1
    File? read2
    File? read1_clean
    File? read2_clean
    String? run_id
    String? collection_date
    String? originating_lab
    String? city
    String? county
    String? zip
    String? theiaprok_illumina_pe_version
    String? theiaprok_illumina_pe_analysis_date
    String? theiaprok_illumina_se_version
    String? theiaprok_illumina_se_analysis_date
    String? theiaprok_ont_version
    String? theiaprok_ont_analysis_date
    String? theiaprok_fasta_version
    String? theiaprok_fasta_analysis_date
    String? seq_platform
    Int? num_reads_raw1
    Int? num_reads_raw2
    String? num_reads_raw_pairs
    String? fastq_scan_version
    Int? num_reads_clean1
    Int? num_reads_clean2
    String? num_reads_clean_pairs
    String? trimmomatic_version
    String? fastp_version
    String? bbduk_docker
    Float? r1_mean_q_raw
    Float? r2_mean_q_raw
    Float? combined_mean_q_raw
    Float? r1_mean_readlength_raw 
    Float? r2_mean_readlength_raw
    Float? combined_mean_readlength_raw
    Float? r1_mean_q_clean
    Float? r2_mean_q_clean
    Float? combined_mean_q_clean
    Float? r1_mean_readlength_clean
    Float? r2_mean_readlength_clean
    Float? combined_mean_readlength_clean
    String? nanoq_version
    String? nanoplot_version
    String? nanoplot_docker
    File? nanoplot_html_raw
    File? nanoplot_tsv_raw
    Int? nanoplot_num_reads_raw1
    Float? nanoplot_r1_median_readlength_raw
    Float? nanoplot_r1_mean_readlength_raw
    Float? nanoplot_r1_stdev_readlength_raw
    Float? nanoplot_r1_n50_raw
    Float? nanoplot_r1_mean_q_raw
    Float? nanoplot_r1_median_q_raw
    Float? nanoplot_r1_est_coverage_raw
    File? nanoplot_html_clean
    File? nanoplot_tsv_clean
    Int? nanoplot_num_reads_clean1
    Float? nanoplot_r1_median_readlength_clean
    Float? nanoplot_r1_mean_readlength_clean
    Float? nanoplot_r1_stdev_readlength_clean
    Float? nanoplot_r1_n50_clean
    Float? nanoplot_r1_mean_q_clean
    Float? nanoplot_r1_median_q_clean
    Float? nanoplot_r1_est_coverage_clean
    String? rasusa_version
    File? tiptoft_plasmid_replicon_fastq
    String? tiptoft_plasmid_replicon_genes
    String? tiptoft_version
    File? assembly_fasta
    File? contigs_gfa
    String? shovill_pe_version
    String? shovill_se_version
    File? quast_report
    String? quast_version
    Float? quast_gc_percent
    Int? assembly_length
    Int? number_contigs
    Int? n50_value
    File? cg_pipeline_report_raw
    File? cg_pipeline_report_clean
    String? cg_pipeline_docker
    Float? est_coverage_raw
    Float? est_coverage_clean
    File? gambit_report
    String? gambit_predicted_taxon
    String? gambit_predicted_taxon_rank
    File? gambit_closest_genomes
    String? gambit_version
    String? gambit_db_version
    String? gambit_docker
    String? busco_version
    String? busco_database
    String? busco_results
    File? busco_report
    Float? ani_highest_percent
    Float? ani_highest_percent_bases_aligned 
    File? ani_output_tsv
    String? ani_top_species_match 
    String? ani_mummer_version
    String? ani_docker
    String? kmerfinder_docker
    File? kmerfinder_results_tsv
    String? kmerfinder_top_hit
    String? kmerfinder_query_coverage
    String? kmerfinder_template_coverage
    String? kmerfinder_database
    File? amrfinderplus_all_report
    File? amrfinderplus_amr_report
    File? amrfinderplus_stress_report
    File? amrfinderplus_virulence_report
    String? amrfinderplus_amr_core_genes
    String? amrfinderplus_amr_plus_genes
    String? amrfinderplus_stress_genes
    String? amrfinderplus_virulence_genes
    String? amrfinderplus_amr_classes
    String? amrfinderplus_amr_subclasses
    String? amrfinderplus_version
    String? amrfinderplus_db_version
    File? resfinder_pheno_table 
    File? resfinder_pheno_table_species
    File? resfinder_seqs 
    File? resfinder_results 
    File? resfinder_pointfinder_pheno_table 
    File? resfinder_pointfinder_results 
    String? resfinder_predicted_pheno_resistance
    String? resfinder_predicted_xdr_shigella
    String? resfinder_predicted_resistance_Amp
    String? resfinder_predicted_resistance_Azm
    String? resfinder_predicted_resistance_Axo
    String? resfinder_predicted_resistance_Cip
    String? resfinder_predicted_resistance_Smx
    String? resfinder_predicted_resistance_Tmp
    String? resfinder_db_version 
    String? resfinder_docker 
    File? ts_mlst_results
    String? ts_mlst_predicted_st
    String? ts_mlst_pubmlst_scheme
    String? ts_mlst_allelic_profile
    File? ts_mlst_novel_alleles
    String? ts_mlst_version
    String? ts_mlst_docker
    File? serotypefinder_report
    String? serotypefinder_docker
    String? serotypefinder_serotype
    File? ectyper_results
    String? ectyper_version
    String? ectyper_predicted_serotype
    String? shigatyper_predicted_serotype
    String? shigatyper_ipaB_presence_absence
    String? shigatyper_notes
    File? shigatyper_hits_tsv
    File? shigatyper_summary_tsv
    String? shigatyper_version
    String? shigatyper_docker
    File? shigeifinder_report
    String? shigeifinder_docker
    String? shigeifinder_version
    String? shigeifinder_ipaH_presence_absence
    String? shigeifinder_num_virulence_plasmid_genes
    String? shigeifinder_cluster
    String? shigeifinder_serotype
    String? shigeifinder_O_antigen
    String? shigeifinder_H_antigen
    String? shigeifinder_notes
    File? shigeifinder_report_reads
    String? shigeifinder_docker_reads
    String? shigeifinder_version_reads
    String? shigeifinder_ipaH_presence_absence_reads
    String? shigeifinder_num_virulence_plasmid_genes_reads
    String? shigeifinder_cluster_reads
    String? shigeifinder_serotype_reads
    String? shigeifinder_O_antigen_reads
    String? shigeifinder_H_antigen_reads
    String? shigeifinder_notes_reads
    File? virulencefinder_report_tsv
    String? virulencefinder_docker
    String? virulencefinder_hits
    File? sonneityping_mykrobe_report_csv
    File? sonneityping_mykrobe_report_json
    File? sonneityping_final_report_tsv
    String? sonneityping_mykrobe_version
    String? sonneityping_mykrobe_docker
    String? sonneityping_species
    String? sonneityping_final_genotype
    String? sonneityping_genotype_confidence
    String? sonneityping_genotype_name
    File? lissero_results
    String? lissero_version
    String? lissero_serotype
    File? sistr_results
    File? sistr_allele_json
    File? sistr_allele_fasta
    File? sistr_cgmlst
    String? sistr_version
    String? sistr_predicted_serotype
    String? seqsero2_report
    String? seqsero2_version
    String? seqsero2_predicted_antigenic_profile
    String? seqsero2_predicted_serotype
    String? seqsero2_predicted_contamination
    File? genotyphi_report_tsv
    File? genotyphi_mykrobe_json
    String? genotyphi_version
    String? genotyphi_species
    Float? genotyphi_st_probes_percent_coverage
    String? genotyphi_final_genotype
    String? genotyphi_genotype_confidence
    File? kleborate_output_file
    String? kleborate_version
    String? kleborate_docker
    String? kleborate_key_resistance_genes
    String? kleborate_genomic_resistance_mutations
    String? kleborate_mlst_sequence_type
    String? kleborate_klocus
    String? kleborate_ktype
    String? kleborate_olocus
    String? kleborate_otype
    String? kleborate_klocus_confidence
    String? kleborate_olocus_confidence
    String? kleborate_virulence_score
    String? kleborate_resistance_score
    File? kaptive_output_file_k
    File? kaptive_output_file_oc
    String? kaptive_version
    String? kaptive_k_locus
    String? kaptive_k_type
    String? kaptive_kl_confidence
    String? kaptive_oc_locus
    String? kaptive_ocl_confidence
    File? ngmaster_tsv
    String? ngmaster_version
    String? ngmaster_ngmast_sequence_type
    String? ngmaster_ngmast_porB_allele
    String? ngmaster_ngmast_tbpB_allele
    String? ngmaster_ngstar_sequence_type
    String? ngmaster_ngstar_penA_allele
    String? ngmaster_ngstar_mtrR_allele
    String? ngmaster_ngstar_porB_allele
    String? ngmaster_ngstar_ponA_allele
    String? ngmaster_ngstar_gyrA_allele
    String? ngmaster_ngstar_parC_allele
    String? ngmaster_ngstar_23S_allele
    File? meningotype_tsv
    String? meningotype_version
    String? meningotype_serogroup
    String? meningotype_PorA
    String? meningotype_FetA
    String? meningotype_PorB
    String? meningotype_fHbp
    String? meningotype_NHBA
    String? meningotype_NadA
    String? meningotype_BAST
    File? abricate_results_tsv
    String? abricate_genes
    String? abricate_database
    String? abricate_version
    String? abricate_docker
    File? abricate_abaum_plasmid_tsv
    String? abricate_abaum_plasmid_type_genes
    String? abricate_abaum_database
    String? abricate_abaum_version
    String? abricate_abaum_docker
    File? tbprofiler_output_file
    File? tbprofiler_output_bam
    File? tbprofiler_output_bai
    String? tbprofiler_version
    String? tbprofiler_main_lineage
    String? tbprofiler_sub_lineage
    String? tbprofiler_dr_type
    String? tbprofiler_resistance_genes
    File? legsta_results
    String? legsta_predicted_sbt
    String? legsta_version
    File? prokka_gff
    File? prokka_gbk
    File? prokka_sqn
    String? plasmidfinder_plasmids
    File? plasmidfinder_results
    File? plasmidfinder_seqs
    String? plasmidfinder_docker
    String? plasmidfinder_db_version
    String? pbptyper_predicted_1A_2B_2X
    File? pbptyper_pbptype_predicted_tsv 
    String? pbptyper_version 
    String? pbptyper_docker
    String? poppunk_gps_cluster
    File? poppunk_gps_external_cluster_csv
    String? poppunk_GPS_db_version
    String? poppunk_version
    String? poppunk_docker
    String? seroba_version
    String? seroba_docker
    String? seroba_serotype
    String? seroba_ariba_serotype
    String? seroba_ariba_identity
    File? seroba_details
    String? emmtyper_emm_type
    File? emmtyper_results_tsv
    String? emmtyper_version
    String? emmtyper_docker
    String? emmtypingtool_emm_type
    File? emmtypingtool_results_xml
    String? emmtypingtool_version
    String? emmtypingtool_docker
    String? hicap_serotype
    String? hicap_genes
    File? hicap_results_tsv
    String? hicap_version
    String? hicap_docker
    String? midas_docker 
    File? midas_report 
    String? midas_primary_genus
    String? midas_secondary_genus
    Float? midas_secondary_genus_abundance
    Float? midas_secondary_genus_coverage
    String? kraken2_version
    String? kraken2_docker
    String? kraken2_report
    File? bakta_gbff
    File? bakta_gff3
    File? bakta_tsv
    File? bakta_summary
    String? bakta_version
    String? pasty_serogroup
    Float? pasty_serogroup_coverage
    Int? pasty_serogroup_fragments
    File? pasty_summary_tsv
    File? pasty_blast_hits
    File? pasty_all_serogroups
    String? pasty_version
    String? pasty_docker
    String? pasty_comment
    String? qc_check
    File? qc_standard
    File? spatyper_tsv
    String? spatyper_docker
    String? spatyper_repeats
    String? spatyper_type
    String? spatyper_version
    File? staphopiasccmec_results_tsv
    File? staphopiasccmec_hamming_distance_tsv
    String? staphopiasccmec_types_and_mecA_presence
    String? staphopiasccmec_version
    String? staphopiasccmec_docker
    File? agrvate_summary
    File? agrvate_results
    String? agrvate_agr_group
    String? agrvate_agr_match_score
    String? agrvate_agr_canonical
    String? agrvate_agr_multiple
    String? agrvate_agr_num_frameshifts
    String? agrvate_version
    String? agrvate_docker
    File? srst2_vibrio_detailed_tsv
    String? srst2_vibrio_docker
    String? srst2_vibrio_database
    String? srst2_vibrio_version
    String? srst2_vibrio_ctxA
    String? srst2_vibrio_ompW
    String? srst2_vibrio_toxR
    String? srst2_vibrio_serogroup
    String? srst2_vibrio_biotype
    File? abricate_vibrio_detailed_tsv
    String? abricate_vibrio_database
    String? abricate_vibrio_docker
    String? abricate_vibrio_version
    String? abricate_vibrio_ctxA
    String? abricate_vibrio_ompW
    String? abricate_vibrio_toxR
    String? abricate_vibrio_biotype
    String? abricate_vibrio_serogroup
  }
  meta {
    # added so that call caching is always turned off
    volatile: true
  }
  command <<<
  
    # capture taxon and corresponding table names from input taxon_tables
    taxon_array=($(cut -f1 ~{taxon_tables} | tail +2))
    echo "Taxon array: ${taxon_array[*]}"
    table_array=($(cut -f2 ~{taxon_tables} | tail +2))
    echo "Table array: ${table_array[*]}"
    # remove whitespace from sample_taxon
    sample_taxon=$(echo ~{sample_taxon} | tr ' ' '_')
    echo "Sample taxon: ${sample_taxon}"
    # set taxon and table vars
    echo "Checking if sample taxon should be exported to user-specified taxon table..."
    for index in ${!taxon_array[@]}; do
      taxon=${taxon_array[$index]}
      echo "Taxon: ${taxon}"
      table=${table_array[$index]}
      echo "Table: ${table}"
      if [[ "${sample_taxon}" == *"${taxon}"* ]]; then
        sample_table=${table}
        echo "Sample ~{samplename} identified as ~{sample_taxon}. As per user-defined taxon tables, ${taxon} samples will be exported to the ${table} terra data table"
        break
      else 
        echo "${sample_taxon} does not match ${taxon}."
      fi
    done
    if [ ! -z ${sample_table} ]; then
       # create single-entity sample data table

      python3 <<CODE
    import csv

    # create dictionary with all values      
    new_table = {
      "entity:${sample_table}_id": "~{samplename}",
      "read1": "~{read1}",
      "read2": "~{read2}",
      "read1_clean": "~{read1_clean}",
      "read2_clean": "~{read2_clean}",
      "run_id": "~{run_id}",
      "collection_date": "~{collection_date}",
      "originating_lab": "~{originating_lab}",
      "city": "~{city}",
      "county": "~{county}",
      "zip": "~{zip}",
      "theiaprok_illumina_pe_version": "~{theiaprok_illumina_pe_version}",
      "theiaprok_illumina_pe_analysis_date": "~{theiaprok_illumina_pe_analysis_date}",
      "theiaprok_illumina_se_version": "~{theiaprok_illumina_se_version}",
      "theiaprok_illumina_se_analysis_date": "~{theiaprok_illumina_se_analysis_date}",
      "theiaprok_fasta_version": "~{theiaprok_fasta_version}",
      "theiaprok_fasta_analysis_date": "~{theiaprok_fasta_analysis_date}",
      "theiaprok_ont_version": "~{theiaprok_ont_version}",
      "theiaprok_ont_analysis_date": "~{theiaprok_ont_analysis_date}",
      "seq_platform": "~{seq_platform}",
      "num_reads_raw1": "~{num_reads_raw1}",
      "num_reads_raw2": "~{num_reads_raw2}",
      "num_reads_raw_pairs": "~{num_reads_raw_pairs}",
      "fastq_scan_version": "~{fastq_scan_version}",
      "num_reads_clean1": "~{num_reads_clean1}",
      "num_reads_clean2": "~{num_reads_clean2}",
      "num_reads_clean_pairs": "~{num_reads_clean_pairs}",
      "trimmomatic_version": "~{trimmomatic_version}",
      "fastp_version": "~{fastp_version}",
      "bbduk_docker": "~{bbduk_docker}",
      "r1_mean_q_raw": "~{r1_mean_q_raw}",
      "r2_mean_q_raw": "~{r2_mean_q_raw}",
      "combined_mean_q_raw": "~{combined_mean_q_raw}",
      "r1_mean_readlength_raw": "~{r1_mean_readlength_raw}",
      "r2_mean_readlength_raw": "~{r2_mean_readlength_raw}",
      "combined_mean_readlength_raw": "~{combined_mean_readlength_raw}",
      "r1_mean_q_clean": "~{r1_mean_q_clean}",
      "r2_mean_q_clean": "~{r2_mean_q_clean}",
      "combined_mean_q_clean": "~{combined_mean_q_clean}",
      "r1_mean_readlength_clean": "~{r1_mean_readlength_clean}",
      "r2_mean_readlength_clean": "~{r2_mean_readlength_clean}",
      "combined_mean_readlength_clean": "~{combined_mean_readlength_clean}",
      "nanoq_version": "~{nanoq_version}",
      "nanoplot_docker": "~{nanoplot_docker}",
      "nanoplot_version": "~{nanoplot_version}",
      "nanoplot_html_raw": "~{nanoplot_html_raw}",	
      "nanoplot_tsv_raw": "~{nanoplot_tsv_raw}",
      "nanoplot_num_reads_raw1": "~{nanoplot_num_reads_raw1}",
      "nanoplot_r1_median_readlength_raw": "~{nanoplot_r1_median_readlength_raw}",
      "nanoplot_r1_mean_readlength_raw": "~{nanoplot_r1_mean_readlength_raw}",
      "nanoplot_r1_stdev_readlength_raw": "~{nanoplot_r1_stdev_readlength_raw}",
      "nanoplot_r1_n50_raw": "~{nanoplot_r1_n50_raw}",
      "nanoplot_r1_mean_q_raw": "~{nanoplot_r1_mean_q_raw}",
      "nanoplot_r1_median_q_raw": "~{nanoplot_r1_median_q_raw}",
      "nanoplot_r1_est_coverage_raw": "~{nanoplot_r1_est_coverage_raw}",
      "nanoplot_html_clean": "~{nanoplot_html_clean}",
      "nanoplot_tsv_clean": "~{nanoplot_tsv_clean}",
      "nanoplot_num_reads_clean1": "~{nanoplot_num_reads_clean1}",
      "nanoplot_r1_median_readlength_clean": "~{nanoplot_r1_median_readlength_clean}",
      "nanoplot_r1_mean_readlength_clean": "~{nanoplot_r1_mean_readlength_clean}",
      "nanoplot_r1_stdev_readlength_clean": "~{nanoplot_r1_stdev_readlength_clean}",
      "nanoplot_r1_n50_clean": "~{nanoplot_r1_n50_clean}",
      "nanoplot_r1_mean_q_clean": "~{nanoplot_r1_mean_q_clean}",
      "nanoplot_r1_median_q_clean": "~{nanoplot_r1_median_q_clean}",
      "nanoplot_r1_est_coverage_clean": "~{nanoplot_r1_est_coverage_clean}",
      "rasusa_version": "~{rasusa_version}",
      "tiptoft_plasmid_replicon_fastq": "~{tiptoft_plasmid_replicon_fastq}",
      "tiptoft_plasmid_replicon_genes": "~{tiptoft_plasmid_replicon_genes}",
      "tiptoft_version": "~{tiptoft_version}",
      "assembly_fasta": "~{assembly_fasta}",
      "contigs_gfa": "~{contigs_gfa}",
      "shovill_pe_version": "~{shovill_pe_version}",
      "shovill_se_version": "~{shovill_se_version}",
      "quast_report": "~{quast_report}",
      "quast_version": "~{quast_version}",
      "quast_gc_percent": "~{quast_gc_percent}",
      "assembly_length": "~{assembly_length}",
      "number_contigs": "~{number_contigs}",
      "n50_value": "~{n50_value}",
      "cg_pipeline_report_raw": "~{cg_pipeline_report_raw}",
      "cg_pipeline_report_clean": "~{cg_pipeline_report_clean}",
      "cg_pipeline_docker": "~{cg_pipeline_docker}",
      "est_coverage_raw": "~{est_coverage_raw}",
      "est_coverage_clean": "~{est_coverage_clean}",
      "gambit_report": "~{gambit_report}",
      "gambit_predicted_taxon": "~{gambit_predicted_taxon}",
      "gambit_predicted_taxon_rank": "~{gambit_predicted_taxon_rank}",
      "gambit_closest_genomes": "~{gambit_closest_genomes}",
      "gambit_version": "~{gambit_version}",
      "gambit_db_version": "~{gambit_db_version}",
      "gambit_docker": "~{gambit_docker}",
      "busco_version": "~{busco_version}",
      "busco_database": "~{busco_database}",
      "busco_results": "~{busco_results}",
      "busco_report": "~{busco_report}",
      "ts_mlst_results": "~{ts_mlst_results}",
      "ts_mlst_predicted_st": "~{ts_mlst_predicted_st}",
      "ts_mlst_pubmlst_scheme": "~{ts_mlst_pubmlst_scheme}",
      "ts_mlst_allelic_profile": "~{ts_mlst_allelic_profile}",
      "ts_mlst_novel_alleles": "~{ts_mlst_novel_alleles}",
      "ts_mlst_version": "~{ts_mlst_version}",
      "ts_mlst_docker": "~{ts_mlst_docker}",	
      "serotypefinder_report": "~{serotypefinder_report}",
      "serotypefinder_docker": "~{serotypefinder_docker}",
      "serotypefinder_serotype": "~{serotypefinder_serotype}",
      "ectyper_results": "~{ectyper_results}",
      "ectyper_version": "~{ectyper_version}",
      "ectyper_predicted_serotype": "~{ectyper_predicted_serotype}",
      "shigatyper_predicted_serotype": "~{shigatyper_predicted_serotype}",
      "shigatyper_ipaB_presence_absence": "~{shigatyper_ipaB_presence_absence}",
      "shigatyper_notes": "~{shigatyper_notes}",
      "shigatyper_hits_tsv": "~{shigatyper_hits_tsv}",
      "shigatyper_summary_tsv": "~{shigatyper_summary_tsv}",
      "shigatyper_version": "~{shigatyper_version}",
      "shigatyper_docker": "~{shigatyper_docker}",
      "shigeifinder_report": "~{shigeifinder_report}",
      "shigeifinder_docker": "~{shigeifinder_docker}",
      "shigeifinder_version": "~{shigeifinder_version}",
      "shigeifinder_ipaH_presence_absence": "~{shigeifinder_ipaH_presence_absence}",
      "shigeifinder_num_virulence_plasmid_genes": "~{shigeifinder_num_virulence_plasmid_genes}",
      "shigeifinder_cluster": "~{shigeifinder_cluster}",
      "shigeifinder_serotype": "~{shigeifinder_serotype}",
      "shigeifinder_O_antigen": "~{shigeifinder_O_antigen}",
      "shigeifinder_H_antigen": "~{shigeifinder_H_antigen}",
      "shigeifinder_notes": "~{shigeifinder_notes}",
      "shigeifinder_report_reads": "~{shigeifinder_report_reads}",
      "shigeifinder_docker_reads": "~{shigeifinder_docker_reads}",
      "shigeifinder_version_reads": "~{shigeifinder_version_reads}",
      "shigeifinder_ipaH_presence_absence_reads": "~{shigeifinder_ipaH_presence_absence_reads}",
      "shigeifinder_num_virulence_plasmid_genes_reads": "~{shigeifinder_num_virulence_plasmid_genes_reads}",
      "shigeifinder_cluster_reads": "~{shigeifinder_cluster_reads}",
      "shigeifinder_serotype_reads": "~{shigeifinder_serotype_reads}",
      "shigeifinder_O_antigen_reads": "~{shigeifinder_O_antigen_reads}",
      "shigeifinder_H_antigen_reads": "~{shigeifinder_H_antigen_reads}",
      "shigeifinder_notes_reads": "~{shigeifinder_notes_reads}",
      "virulencefinder_report_tsv": "~{virulencefinder_report_tsv}",
      "virulencefinder_docker": "~{virulencefinder_docker}",
      "virulencefinder_hits": "~{virulencefinder_hits}",
      "sonneityping_mykrobe_report_csv": "~{sonneityping_mykrobe_report_csv}",
      "sonneityping_mykrobe_report_json": "~{sonneityping_mykrobe_report_json}",
      "sonneityping_final_report_tsv": "~{sonneityping_final_report_tsv}",
      "sonneityping_mykrobe_version": "~{sonneityping_mykrobe_version}",
      "sonneityping_mykrobe_docker": "~{sonneityping_mykrobe_docker}",
      "sonneityping_species": "~{sonneityping_species}",
      "sonneityping_final_genotype": "~{sonneityping_final_genotype}",
      "sonneityping_genotype_confidence": "~{sonneityping_genotype_confidence}",
      "sonneityping_genotype_name": "~{sonneityping_genotype_name}",
      "lissero_results": "~{lissero_results}",
      "lissero_version": "~{lissero_version}",
      "lissero_serotype": "~{lissero_serotype}",
      "sistr_results": "~{sistr_results}",
      "sistr_allele_json": "~{sistr_allele_json}",
      "sistr_allele_fasta": "~{sistr_allele_fasta}",
      "sistr_cgmlst": "~{sistr_cgmlst}",
      "sistr_version": "~{sistr_version}",
      "sistr_predicted_serotype": "~{sistr_predicted_serotype}",
      "seqsero2_report": "~{seqsero2_report}",
      "seqsero2_version": "~{seqsero2_version}",
      "seqsero2_predicted_antigenic_profile": "~{seqsero2_predicted_antigenic_profile}",
      "seqsero2_predicted_serotype": "~{seqsero2_predicted_serotype}",
      "seqsero2_predicted_contamination": "~{seqsero2_predicted_contamination}",
      "kleborate_output_file": "~{kleborate_output_file}",
      "kleborate_version": "~{kleborate_version}",
      "kleborate_docker": "~{kleborate_docker}",
      "kleborate_key_resistance_genes": "~{kleborate_key_resistance_genes}",
      "kleborate_genomic_resistance_mutations": "~{kleborate_genomic_resistance_mutations}",
      "kleborate_mlst_sequence_type": "~{kleborate_mlst_sequence_type}",
      "kleborate_klocus": "~{kleborate_klocus}",
      "kleborate_ktype": "~{kleborate_ktype}",
      "kleborate_olocus": "~{kleborate_olocus}",
      "kleborate_otype": "~{kleborate_otype}",
      "kleborate_klocus_confidence": "~{kleborate_klocus_confidence}",
      "kleborate_olocus_confidence": "~{kleborate_olocus_confidence}",
      "kleborate_virulence_score": "~{kleborate_virulence_score}",
      "kleborate_resistance_score": "~{kleborate_resistance_score}",
      "ngmaster_tsv": "~{ngmaster_tsv}",
      "ngmaster_version": "~{ngmaster_version}",
      "ngmaster_ngmast_sequence_type": "~{ngmaster_ngmast_sequence_type}",
      "ngmaster_ngmast_porB_allele": "~{ngmaster_ngmast_porB_allele}",
      "ngmaster_ngmast_tbpB_allele": "~{ngmaster_ngmast_tbpB_allele}",
      "ngmaster_ngstar_sequence_type": "~{ngmaster_ngstar_sequence_type}",
      "ngmaster_ngstar_penA_allele": "~{ngmaster_ngstar_penA_allele}",
      "ngmaster_ngstar_mtrR_allele": "~{ngmaster_ngstar_mtrR_allele}",
      "ngmaster_ngstar_porB_allele": "~{ngmaster_ngstar_porB_allele}",
      "ngmaster_ngstar_ponA_allele": "~{ngmaster_ngstar_ponA_allele}",
      "ngmaster_ngstar_gyrA_allele": "~{ngmaster_ngstar_gyrA_allele}",
      "ngmaster_ngstar_parC_allele": "~{ngmaster_ngstar_parC_allele}",
      "ngmaster_ngstar_23S_allele": "~{ngmaster_ngstar_23S_allele}",
      "meningotype_tsv": "~{meningotype_tsv}",
      "meningotype_version": "~{meningotype_version}",
      "meningotype_serogroup": "~{meningotype_serogroup}",
      "meningotype_PorA": "~{meningotype_PorA}",
      "meningotype_FetA": "~{meningotype_FetA}",
      "meningotype_PorB": "~{meningotype_PorB}",
      "meningotype_fHbp": "~{meningotype_fHbp}",
      "meningotype_NHBA": "~{meningotype_NHBA}",
      "meningotype_NadA": "~{meningotype_NadA}",
      "meningotype_BAST": "~{meningotype_BAST}",
      "kaptive_version": "~{kaptive_version}",
      "kaptive_output_file_k": "~{kaptive_output_file_k}",
      "kaptive_output_file_oc": "~{kaptive_output_file_oc}",
      "kaptive_k_locus": "~{kaptive_k_locus}",
      "kaptive_k_type": "~{kaptive_k_type}",
      "kaptive_kl_confidence": "~{kaptive_kl_confidence}",
      "kaptive_oc_locus": "~{kaptive_oc_locus}",
      "kaptive_ocl_confidence": "~{kaptive_ocl_confidence}",
      "abricate_results_tsv": "~{abricate_results_tsv}",
      "abricate_genes": "~{abricate_genes}",
      "abricate_database": "~{abricate_database}",
      "abricate_version": "~{abricate_version}",
      "abricate_docker": "~{abricate_docker}",
      "abricate_abaum_plasmid_tsv": "~{abricate_abaum_plasmid_tsv}",
      "abricate_abaum_plasmid_type_genes": "~{abricate_abaum_plasmid_type_genes}",
      "abricate_abaum_database": "~{abricate_abaum_database}",
      "abricate_abaum_version": "~{abricate_abaum_version}",
      "abricate_abaum_docker": "~{abricate_abaum_docker}",
      "legsta_results": "~{legsta_results}",
      "legsta_predicted_sbt": "~{legsta_predicted_sbt}",
      "legsta_version": "~{legsta_version}",
      "tbprofiler_output_file": "~{tbprofiler_output_file}",
      "tbprofiler_output_bam": "~{tbprofiler_output_bam}",
      "tbprofiler_output_bai": "~{tbprofiler_output_bai}",
      "tbprofiler_version": "~{tbprofiler_version}",
      "tbprofiler_main_lineage": "~{tbprofiler_main_lineage}",
      "tbprofiler_sub_lineage": "~{tbprofiler_sub_lineage}",
      "tbprofiler_dr_type": "~{tbprofiler_dr_type}",
      "tbprofiler_resistance_genes": "~{tbprofiler_resistance_genes}",
      "amrfinderplus_all_report": "~{amrfinderplus_all_report}",
      "amrfinderplus_amr_report": "~{amrfinderplus_amr_report}",
      "amrfinderplus_stress_report": "~{amrfinderplus_stress_report}",
      "amrfinderplus_virulence_report": "~{amrfinderplus_virulence_report}",
      "amrfinderplus_version": "~{amrfinderplus_version}",
      "amrfinderplus_db_version": "~{amrfinderplus_db_version}",
      "amrfinderplus_amr_core_genes": "~{amrfinderplus_amr_core_genes}",
      "amrfinderplus_amr_plus_genes": "~{amrfinderplus_amr_plus_genes}",
      "amrfinderplus_stress_genes": "~{amrfinderplus_stress_genes}",
      "amrfinderplus_virulence_genes": "~{amrfinderplus_virulence_genes}",
      "amrfinderplus_amr_classes": "~{amrfinderplus_amr_classes}",
      "amrfinderplus_amr_subclasses": "~{amrfinderplus_amr_subclasses}",
      "genotyphi_report_tsv": "~{genotyphi_report_tsv}",
      "genotyphi_mykrobe_json": "~{genotyphi_mykrobe_json}",
      "genotyphi_version": "~{genotyphi_version}",
      "genotyphi_species": "~{genotyphi_species}",
      "genotyphi_st_probes_percent_coverage": "~{genotyphi_st_probes_percent_coverage}",
      "genotyphi_final_genotype": "~{genotyphi_final_genotype}",
      "genotyphi_genotype_confidence": "~{genotyphi_genotype_confidence}",
      "ani_highest_percent": "~{ani_highest_percent}",
      "ani_highest_percent_bases_aligned": "~{ani_highest_percent_bases_aligned}",
      "ani_output_tsv": "~{ani_output_tsv}",
      "ani_top_species_match": "~{ani_top_species_match}",
      "ani_mummer_version": "~{ani_mummer_version}",
      "ani_docker": "~{ani_docker}",
      "kmerfinder_docker": "~{kmerfinder_docker}",
      "kmerfinder_results_tsv": "~{kmerfinder_results_tsv}",
      "kmerfinder_top_hit": "~{kmerfinder_top_hit}",
      "kmerfinder_query_coverage": "~{kmerfinder_query_coverage}",
      "kmerfinder_template_coverage": "~{kmerfinder_template_coverage}",
      "kmerfinder_database": "~{kmerfinder_database}",
      "resfinder_pheno_table": "~{resfinder_pheno_table}",
      "resfinder_pheno_table_species": "~{resfinder_pheno_table_species}",
      "resfinder_seqs": "~{resfinder_seqs}",
      "resfinder_results": "~{resfinder_results}",
      "resfinder_pointfinder_pheno_table": "~{resfinder_pointfinder_pheno_table}",
      "resfinder_pointfinder_results": "~{resfinder_pointfinder_results}",
      "resfinder_predicted_pheno_resistance": "~{resfinder_predicted_pheno_resistance}",
      "resfinder_predicted_xdr_shigella": "~{resfinder_predicted_xdr_shigella}",
      "resfinder_predicted_resistance_Amp": "~{resfinder_predicted_resistance_Amp}",
      "resfinder_predicted_resistance_Azm": "~{resfinder_predicted_resistance_Azm}",
      "resfinder_predicted_resistance_Axo": "~{resfinder_predicted_resistance_Axo}",
      "resfinder_predicted_resistance_Cip": "~{resfinder_predicted_resistance_Cip}",
      "resfinder_predicted_resistance_Smx": "~{resfinder_predicted_resistance_Smx}",
      "resfinder_predicted_resistance_Tmp": "~{resfinder_predicted_resistance_Tmp}",
      "resfinder_db_version": "~{resfinder_db_version}",
      "resfinder_docker": "~{resfinder_docker}",
      "prokka_gff": "~{prokka_gff}",
      "prokka_gbk": "~{prokka_gbk}",
      "prokka_sqn": "~{prokka_sqn}",
      "plasmidfinder_plasmids": "~{plasmidfinder_plasmids}",
      "plasmidfinder_results": "~{plasmidfinder_results}",
      "plasmidfinder_seqs": "~{plasmidfinder_seqs}",
      "plasmidfinder_docker": "~{plasmidfinder_docker}",
      "plasmidfinder_db_version": "~{plasmidfinder_db_version}",
      "pbptyper_predicted_1A_2B_2X": "~{pbptyper_predicted_1A_2B_2X}",
      "pbptyper_pbptype_predicted_tsv": "~{pbptyper_pbptype_predicted_tsv}",
      "pbptyper_version": "~{pbptyper_version}",
      "pbptyper_docker": "~{pbptyper_docker}",
      "poppunk_gps_cluster": "~{poppunk_gps_cluster}",
      "poppunk_gps_external_cluster_csv": "~{poppunk_gps_external_cluster_csv}",
      "poppunk_GPS_db_version": "~{poppunk_GPS_db_version}",
      "poppunk_version": "~{poppunk_version}",
      "poppunk_docker": "~{poppunk_docker}",
      "seroba_version": "~{seroba_version}",
      "seroba_docker": "~{seroba_docker}",
      "seroba_serotype": "~{seroba_serotype}",
      "seroba_ariba_serotype": "~{seroba_ariba_serotype}",
      "seroba_ariba_identity": "~{seroba_ariba_identity}",
      "seroba_details": "~{seroba_details}",
      "emmtyper_emm_type": "~{emmtyper_emm_type}",
      "emmtyper_results_tsv": "~{emmtyper_results_tsv}",
      "emmtyper_version": "~{emmtyper_version}",
      "emmtyper_docker": "~{emmtyper_docker}",
      "emmtypingtool_emm_type": "~{emmtypingtool_emm_type}",
      "emmtypingtool_reults_xml": "~{emmtypingtool_results_xml}",
      "emmtypingtool_version": "~{emmtypingtool_version}",
      "emmtypingtool_docker": "~{emmtypingtool_docker}",
      "hicap_serotype": "~{hicap_serotype}",
      "hicap_genes": "~{hicap_genes}",
      "hicap_results_tsv": "~{hicap_results_tsv}",
      "hicap_version": "~{hicap_version}",
      "hicap_docker": "~{hicap_docker}",
      "midas_docker": "~{midas_docker}",
      "midas_report": "~{midas_report}",
      "midas_primary_genus": "~{midas_primary_genus}",
      "midas_secondary_genus": "~{midas_secondary_genus}",
      "midas_secondary_genus_abundance": "~{midas_secondary_genus_abundance}",
      "midas_secondary_genus_coverage": "~{midas_secondary_genus_coverage}",
      "kraken2_version": "~{kraken2_version}",
      "kraken2_docker": "~{kraken2_docker}",
      "kraken2_report": "~{kraken2_report}",
      "bakta_gbff": "~{bakta_gbff}",
      "bakta_gff3": "~{bakta_gff3}",
      "bakta_tsv": "~{bakta_tsv}",
      "bakta_summary": "~{bakta_summary}",
      "bakta_version": "~{bakta_version}",
      "pasty_serogroup": "~{pasty_serogroup}",
      "pasty_serogroup_coverage": "~{pasty_serogroup_coverage}",
      "pasty_serogroup_fragments": "~{pasty_serogroup_fragments}",
      "pasty_summary_tsv": "~{pasty_summary_tsv}",
      "pasty_blast_hits": "~{pasty_blast_hits}",
      "pasty_all_serogroups": "~{pasty_all_serogroups}",
      "pasty_version": "~{pasty_version}",
      "pasty_docker": "~{pasty_docker}",
      "pasty_comment": "~{pasty_comment}",
      "qc_check": "~{qc_check}",
      "qc_standard": "~{qc_standard}",
      "spatyper_tsv": "~{spatyper_tsv}",
      "spatyper_docker": "~{spatyper_docker}",
      "spatyper_repeats": "~{spatyper_repeats}",
      "spatyper_type": "~{spatyper_type}",
      "spatyper_version": "~{spatyper_version}",
      "staphopiasccmec_results_tsv": "~{staphopiasccmec_results_tsv}",
      "staphopiasccmec_hamming_distance_tsv": "~{staphopiasccmec_hamming_distance_tsv}",
      "staphopiasccmec_types_and_mecA_presence": "~{staphopiasccmec_types_and_mecA_presence}",
      "staphopiasccmec_version": "~{staphopiasccmec_version}",
      "staphopiasccmec_docker ": "~{staphopiasccmec_docker}",
      "agrvate_summary": "~{agrvate_summary}",
      "agrvate_results": "~{agrvate_results}",
      "agrvate_agr_group": "~{agrvate_agr_group}",
      "agrvate_agr_match_score": "~{agrvate_agr_match_score}",
      "agrvate_agr_canonical": "~{agrvate_agr_canonical}",
      "agrvate_agr_multiple": "~{agrvate_agr_multiple}",
      "agrvate_agr_num_frameshifts": "~{agrvate_agr_num_frameshifts}",
      "agrvate_version": "~{agrvate_version}",
      "agrvate_docker": "~{agrvate_docker}",
      "srst2_vibrio_detailed_tsv": "~{srst2_vibrio_detailed_tsv}",
      "srst2_vibrio_version": "~{srst2_vibrio_version}",~
      "srst2_vibrio_docker": "~{srst2_vibrio_docker}",
      "srst2_vibrio_database": "~{srst2_vibrio_database}",
      "srst2_vibrio_ctxA": "~{srst2_vibrio_ctxA}",
      "srst2_vibrio_ompW": "~{srst2_vibrio_ompW}",
      "srst2_vibrio_toxR": "~{srst2_vibrio_toxR}",
      "srst2_vibrio_serogroup": "~{srst2_vibrio_serogroup}",
      "srst2_vibrio_biotype": "~{srst2_vibrio_biotype}",
      "abricate_vibrio_detailed_tsv": "~{abricate_vibrio_detailed_tsv}",
      "abricate_vibrio_database": "~{abricate_vibrio_database}",
      "abricate_vibrio_docker": "~{abricate_vibrio_docker}",
      "abricate_vibrio_version": "~{abricate_vibrio_version}",
      "abricate_vibrio_ctxA": "~{abricate_vibrio_ctxA}",
      "abricate_vibrio_ompW": "~{abricate_vibrio_ompW}",
      "abricate_vibrio_toxR": "~{abricate_vibrio_toxR}",
      "abricate_vibrio_biotype": "~{abricate_vibrio_biotype}",
      "abricate_vibrio_serogroup": "~{abricate_vibrio_serogroup}"
    }

    with open("~{samplename}_terra_table.tsv", "w") as outfile:
      writer = csv.DictWriter(outfile, new_table.keys(), delimiter='\t')
      writer.writeheader()
      writer.writerow(new_table)
    
    CODE
      
      # modify file paths to GCP URIs
      sed -i 's/\/cromwell_root\//gs:\/\//g' ~{samplename}_terra_table.tsv
      # export table 
      python3 /scripts/import_large_tsv/import_large_tsv.py --project "~{terra_project}" --workspace "~{terra_workspace}" --tsv ~{samplename}_terra_table.tsv

      echo "~{samplename} was added to the ${sample_table} table" > STATUS
    else
      echo "Table not defined for ~{sample_taxon}" > STATUS
    fi
  >>>
  runtime {
    docker: docker
    memory: memory + " GB"
    cpu: cpu
    disks: "local-disk " + disk_size + " SSD"
    disk: disk_size + " GB"
    dx_instance_type: "mem1_ssd1_v2_x2"
    maxRetries: 3
  }
  output {
    String status = read_string("STATUS")
    File? datatable1_tsv = "~{samplename}_terra_table.tsv"
  }
}