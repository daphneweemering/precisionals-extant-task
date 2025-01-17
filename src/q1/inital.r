library(lubridate)
library(tidyverse)

source("src/ext/common.r")

ext_main <- ext_load(
  "P-ALS_Ext_Main_Data_File.xlsx",
  col_types = c(
    "text", # ID
    "text", # Site
    "text", # Sex
    "date", # Date of Birth
    "text", # Year/Year and Month of Birth
    "numeric", # Age
    "text", # First Symptom
    "text", # Site of Onset
    "text", # Site of Onset 2
    "text", # Site of Onset 3
    "text", # Site of Onset 4
    "text", # Side of Onset
    "date", # Date of Onset
    "date", # Month of Onset
    "numeric", # Age at Onset
    "numeric", # Calculated Age at Onset
    "text", # Diagnosis
    "text", # Diagnosis 2
    "text", # Diagnosis 3
    "text", # Other Diagnosis
    "text", # Motor Neuron Predominance
    "date", # Date of Diagnosis
    "date", # Month of Diagnosis
    "numeric", # Age at Diagnosis
    "numeric", # Calculated Age at Diagnosis
    "text", # Vital Status
    "date", # Date of Death
    "numeric", # Age at Death
    "numeric", # Calculated Age at Death
    "text", # Tracheostomy
    "date", # Date of Tracheostomy
    "numeric", # Age at Tracheostomy
    "text", # >23h NIV
    "date", # Date of 23h NIV
    "numeric", # Age at >23 h NIV
    "date", # Date of Last Follow Up
    "numeric", # Age at Last Follow-up (if alive)
    "date", # Date of Transfer
    "numeric", # Age at Transfer (if alive)
    "text", # Non-invasive Ventilation
    "date", # Date of Non-invasive Ventialtion
    "numeric", # Age at Non-invasive Ventilation
    "text", # Gastrostomy
    "date", # Date of Gastrostomy
    "numeric", # Age at Gastrostomy
    "text", # C9orf72 Tested
    "text", # C9orf72 Status
    "text", # Commercial Result
    "text", # SOD1 Tested
    "text", # SOD1 Status
    "text", # FUS Tested
    "text", # FUS Status
    "text", # TARDBP Tested
    "text", # TARDBP Status
    "text", # Riluzole Use
    "date", # Riluzole Start Date
    "numeric", # Riluzole Start Age
    "text", # Rilzole Stopped
    "date", # Riluzole Stop Date
    "text", # Edaravone Use
    "text", # Edaravone Stopped
    "date", # Edaravone Stop Date
    "text" # Current Working Status
  )
)
ext_main <- ext_normalize_names(ext_main)
ext_main$site_of_onset <- as.factor(ext_main$site_of_onset)
unique(ext_main$site_of_onset)

ext_main <- ext_main %>%
  mutate(
    cervical_onset = site_of_onset %in% c(
      "Cervical", "Neck"
    ),
    bulbar_onset = site_of_onset %in% c(
      "Bulbar", "Bulbaire", "Bulbar and Spinal",
      "Bulbar and Spinal",
      "Bulbar and Cognitive/Behavioural",
      "Bulbar and Thoracic/Respiratory",
      "Cognitive/Behavioural and Bulbar",
      "PBP"
    ),
    spinal_onset = site_of_onset %in% c(
      "Arms", "Spinal", "Bulbar and Spinal",
      "Spinal and Cognitive/Behavioural",
      "Cognitive/Behavioural and Spinal",
      "Thoracic/Respiratory and Spinal",
      "Membre supérieur distal Bilat",
      "Membre inférieur distal D",
      "Membre supérieur distal G",
      "Membre inférieur proximal D",
      "Membre inférieur proximal Bilat",
      "Membre inférieur distal Bilat",
      "Membre inférieur distal G",
      "Membre supérieur distal D",
      "Membre inférieur proximal G",
      "Membre supérieur proximal G",
      "Membre supérieur proximal Bilat",
      "Membre supérieur proximal D",
      "Upper limb", "Lower limb",
      "Flail-Leg", "Flail-Arm",
      "Hemiplegic"
    ),
    respiratory_onset = site_of_onset %in% c(
      "Bulbar and Thoracic/Respiratory",
      "Respiratory",
      "Respiratoire",
      "Thoracic/respiratory",
      "Thoracic/Respiratory",
      "Thoracic/Respiratory and Spinal"
    ),
    cognitive_onset = site_of_onset %in% c(
      "Cognitive",
      "Cognitive/Behavioural",
      "Cognitive/Behavioural and Bulbar",
      "Cognitive/Behavioural and Spinal",
      "Cognitive impairment",
      "FTD"
    ),
    proximal_onset = site_of_onset %in% c(
      "Flail-Arm", "Flail-Leg",
      "Membre supérieur proximal D",
      "Membre supérieur proximal G",
      "Membre supérieur proximal Bilat",
      "Membre inférieur proximal D",
      "Membre inférieur proximal G",
      "Membre inférieur proximal Bilat",
      "Neck", "Trunk", "trunk"
    ),
    distal_onset = site_of_onset %in% c(
      "Membre supérieur distal D",
      "Membre supérieur distal G",
      "Membre supérieur distal Bilat",
      "Membre inférieur distal D",
      "Membre inférieur distal G",
      "Membre inférieur distal Bilat"
    ),
    side_of_onset = case_when(
      side_of_onset == "Right" ~ "R",
      side_of_onset == "Left" ~ "L",
      side_of_onset == "Both sides" ~ "B",
      str_ends(site_of_onset, " D") ~ "R",
      str_ends(site_of_onset, " G") ~ "L",
      str_ends(site_of_onset, " Bilat") ~ "B"
    ), # I decided to parse the booleans myself
    sod1_test_BOOL = sod1_tested %in% c(
      "Yes"
    ),
    sod1_stat_BOOL = sod1_status %in% c(
      "Positive"
    ),
    c9orf72_test_BOOL = c9orf72_tested %in% c(
      "Yes", "yes"
    ),
    c9orf72_stat_BOOL = c9orf72_status %in% c(
      "Positive", "Intermediate" # I decided to include intermediate expansions, open to discussion
    ),
    fus_tested_BOOL = fus_tested %in% c(
      "Yes"
    ),
    fus_status_BOOL = fus_status %in% c(
      "Positive"
    ),
    fus_tested_BOOL = fus_tested %in% c(
      "Yes"
    ),
    tardbp_tested_BOOL = tardbp_tested %in% c(
      "Yes"
    ),
    tardbp_status_BOOL = tardbp_status %in% c(
      "Positive"
    ),
    trach_BOOL = tracheostomy %in% c(
      "Yes"
    ),
    niv_BOOL = non_invasive_ventilation %in% c(
      "Yes"
    ),
    gastrostomy_BOOL = gastrostomy %in% c(
      "Yes"
    ),
    rilu_use_BOOL = riluzole_use %in% c(
      "Yes", "yes"
    ),
    edara_BOOL = edaravone_use %in% c(
      "Yes"
    )
  )
