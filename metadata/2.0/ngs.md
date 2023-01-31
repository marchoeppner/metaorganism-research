# CRC1182 NGS Metadata standard v2

Established: January 2023

## Sample sheet

CRC1182 NGS sample sheet v2 [XLSX](CRC1182_NGS_data_v2.xlsx)

## Defined keys

| Key | Description | Unit | Category
| --- | ----------- | ---- | --------
| adapters_R1 | Sequencing adapter R1 | String | Sequencing
| adapters_R2 | Sequencing adapter R2 | String | Sequencing
| amount_or_size_of_sample_collected | Amount or size of sample (volume, mass, area) that was collected | String | Sample
| broad_scale_environmental_context | broad-scale environmental context | String | Sample
| collection_date | Date sample was collected | Date | Sample
| comment | A comment about the data | String | Generic
| common_name | Common species name | String | Sample
| contact_email | Email of primary contact | String | User
| contact_name | Name of primary contact | String | User
| crc_project | Name of CRC sub project | String | User
| enviornment_location_land_or_sea | Officially recognized country or sea where sample was taken | String | Sample
| environmental_medium | environmental medium | String | Sample
| environment_biome | Biome sample was collected from (EBI) | String | Sample
| environment_feature | Environmental feature related to sample | String | Sample
| environment_material | Environmental material sample was taken from | String | Sample
| environment_temperature | Temperate at which sampling was conducted | °C | Sample
| experimental_factor | Experimental factor | String | Generic
| file_format | Format used to store data | String | Generic
| flowcell_id | ID of flow cell | String | Sequencing
| flowcell_lane | Lane on flow cell | Integer | Sequencing
| geographic_location_altitude | Altitude of sample collection site in m | m | Sample
| geographic_location_country | Country sample was collected in | String | Sample
| geographic_location_depth | Depth of sampling site in m | m | Sample
| geographic_location_latitude | Latitude of sample collection site | Coordinates | Sample
| geographic_location_longitude | Longitude of sample collection site | Coordinates | Sample
| host_age | Age of host individual | Integer | Microbiome
| host_body_habitat | Habitat in/on host individual | String | Microbiome
| host_body_product | Substance produced by host (e.g. stool, mucus, etc) from which sample was taken | String | Microbiome
| host_body_site | Host body site sample was taken from | String | Microbiome
| host_common_name | Common name of host organism | String | Microbiome
| host_diet | Dietary regime host was kept on | String | Microbiome
| host_disease_status | Disease status of host organism | String | Microbiome
| host_dry_mass | Measured dry mass of host | Integer | Microbiome
| host_growth_condition | Conditions under which host individual was grown | String | Microbiome
| host_height | Height of host individual | cm | Microbiome
| host_length | Length of host individual | cm | Microbiome
| host_life_stage | life stage of host individual at time of sampling | String | Microbiome
| host_phenotype | Phenotype of host individual | String | Microbiome
| host_sex | Sex of host individual | String | Microbiome
| host_subject_id | Host subject ID | String | Microbiome
| host_substrate | Substrate host was grown on | String | Microbiome
| host_taxid | NCBI taxonomy ID of host organism | Integer | Microbiome
| host_total_mass | Total mass of host individual | g | Microbiome
| investigation_type | Type of investigation performed | String | Generic
| known_pathogenicity | To what is the entity pathogenic, for instance plant, fungi, bacteria | String | Sample
| library_construction_method | Method or kit used for library construction | String | Sequencing
| library_id | Unique identifier of a sequencing library | String | Sequencing
| library_read_group_id | Read group ID of library | String | Sequencing
| library_read_length | Length of sequence reads | String | Sequencing
| library_reads_sequenced | Number of reads sequenced | Integer | Sequencing
| library_sample_type | Sample type library was constructed from | String | Sequencing
| library_screening_strategy | Strategy used to screen library | String | Sequencing
| library_size | Size of library in bp | Integer | Sequencing
| library_vector | Vector used for library construction, if any | String | Sequencing
| local_environmental_context | local environmental context | String | Sample
| multiplex_identifier_fwd | Forward barcode for multiplexing | String | Sequencing
| multiplex_identifier_rev | Reverse barcode for multiplexing | String | Sequencing
| nucleic_acid_amplification | Amplification protocol used, if any | String | Sequencing
| nucleic_acid_extraction | Protocol used to extract DNA/RNA | String | Sequencing
| organism_count | total count of any organism per gram or volume of sample, should include name of organism followed by count; can include multiple organism counts | String | Microbiome
| owner_email | Email of data owner | String | User
| owner_name | Name of data owner | String | User
| oxygenation_status_of_sample | Oxygenation status of sample | String | Sample
| pcr_conditions | Conditions during PCR amplification | String | Sequencing
| pcr_primers_fwd | Forward PCR primers used for target amplification | String | Sequencing
| pcr_primers_rev | Reverse PCR primers used for target amplification | String | Sequencing
| pertubation | type of perturbation, e.g. chemical administration, physical disturbance, etc., coupled with time that perturbation occurred; can include multiple perturbation types | String | Sample
| ploidy | Ploidy of sample material | Integer | Sample
| project_name | Name of a project | String | Generic
| propagation | Method of propagation (phages: lytic or lysogenic, etc) | String | Microbiome
| relationship_to_oxygen | Is this organism an aerobe, anaerobe? Please note that aerobic and anaerobic are valid descriptors for microbial environments | String | Sample
| relevant_standard_operating_procedures | Standard operating procedures used for data production | String | Generic
| sample_barcode | NGS Barcode of sample | String | Sequencing
| sample_collecting_device_or_method | How a sample was collected | String | Sample
| sample_description | Description of a sample | String | Sample
| sample_material_processing | Processing that was performed on sample | String | Sample
| sample_name | Name or identifier of sample | String | Sample
| sample_salinity | salinity of sample, i.e. measure of total salt concentration | Integer | Sample
| sample_storage_duration | How long a sample was stored for in days | Integer | Sample
| sample_storage_location | Location a sample was stored at | String | Sample
| sample_storage_temperature | Temperature the sample was stored at | °C | Sample
| sample_volume_or_weight_for_dna_extraction | Total sample volume (ml) or weight (g) processed for DNA extraction | String | Sample
| scientific_name | Scientific species name | String | Sample
| sequencing_centre | Centre were sequencing was performed | String | Sequencing
| sequencing_date | Date sequencing was performed | Date | Sequencing
| sequencing_method | Sequencing technology | String | Sequencing
| sequencing_platform | Sequencing instrument | String | Sequencing
| source_material_identifier | Identifies a sample source material | String | Sample
| target_gene | Gene used as target, if any | String | Sequencing
| target_subfragment | Subfragment of target, if any | String | Sequencing

