#This code cleans the A3 data collected in southern Laos using the codebook

#Clear working environment
rm(list=ls())

#Set working directory
setwd("/Users/francoisrerolle/Desktop/UCSF/Dissertation/Paper-1-Geospatial-Analysis-Forest-Incidence/Data/Raw/Malaria Incidence")

#Load packages
library(tidyverse)
library(reshape2)

#Load the data
A3_South_Raw <- read_csv("Malaria South  23.5.2017.csv")

#Load the codebook
Codebook_A3_south <- read_csv("Malaria South Codebook sheet 2.csv")

# Source functions for data cleaning
source("/Users/francoisrerolle/Desktop/UCSF/Dissertation/Paper-1-Geospatial-Analysis-Forest-Incidence/Code/Data_Cleaning_Functions.R")


####################
# Data Preparation #
####################
# The A3 data is a record of every suspected malaria case tested by PDT or microscopy passively detected
# at the health facility. The A3 data is entered in books and periodically shared to the higher 
# administratively level

A3_South_Labelled <- (A3_South_Raw
                      %>% rename(Date_of_input = DATE_OF_INPUT, # Date of A3 record
                                 Province_of_input = PROVINCE, # Province of A3 record
                                 District_of_input = DISTRICT, # District of A3 record
                                 Village_of_input = VILLAGE, # Village of A3 record
                                 Health_center_of_input = Health_center, # HC of A3 record
                                 Area_of_input = Area, # ?
                                 Start_report_date = START_REPORT_DATE, # Starting date of the A3 report record
                                 Start_report_month = START_REPORT_MONTH, # Starting month of the A3 report record
                                 Start_report_year = START_REPORT_YEAR, # Starting year of the A3 report record
                                 End_report_date = END_REPORT_DATE, # Ending date of the A3 report record
                                 End_report_month = END_REPORT_MONTH, # Ending month of the A3 report record
                                 End_report_year = END_REPORT_YEAR, # Ending year of the A3 report record
                                 Date = Q1, # Date of the A3 entry
                                 Patient_number = Q2, # Q2: what is number of patient?
                                 Age_1 = Q3, # Q3: What is patient age?
                                 Male = Q4, # Q4: Male?
                                 Female = Q5, # Q5: Female?
                                 Pregnant = Q6, # Q6: Pregnant women
                                 Occupation = Q7, # Q7: Occupation?
                                 Village = Q8, # Q8: What is the village name?
                                 District = Q9, # Q9: What is the district name?
                                 New_patient = Q10, # Q10: new patient?
                                 Old_patient = Q11, # Q11: old patient?
                                 Symptoms_type = Q12, # Q12: How patient's symptom?
                                 Suspected_but_no_blood_test = Q13, # Q13: suspected patient have malaria but don't have blood testing?
                                 Pf_positive_RDT = Q14_1, # Q14-1: P.f positive by RDT
                                 Pv_positive_RDT = Q14_2, # Q14-2: P.v positive by RDT
                                 Mix_positive_RDT = Q14_3, # Q14-3: Mix positive by RDT
                                 Negative_RDT = Q14_4, # Q14-4: Nagative result by RDT
                                 Q14_5 = Q14_5, # Unknown variable present only in F2_1 forms (suspects it means positive RDT where differentiation by species is not asked)
                                 Negative_microscopy = Q15_1, # Q15-1: Nagative result by Microscopy Detection
                                 Positive_microscopy = Q15_2, # Q15-2: Positive result by Microscopy Detection
                                 Pf_positive_microscopy = Q15_3, # Q15-3: P.f Positive result by Microscopy Detection
                                 Pv_positive_microscopy = Q15_4, # Q15-4: P.v Positive result by Microscopy Detection
                                 Mix_positive_microscopy = Q15_5, # Q15-5: Mix Positive Result by Microscopy Detection
                                 Pm_positive_microscopy = Q15_6, # Q15-6: P.m Positive Result by Microscopy Detection
                                 Po_positive_microscopy = Q15_7, # Q15-7: P.o Positive Result by Microscopy Detection
                                 Negative_RDT_and_microscopy = Q16_1, # Q16-1: Negative Result by Microscopy Detection and RDT
                                 Positive_RDT_and_microscopy = Q16_2, # Q16-2: Positive Result by Microscopy Detection and RDT
                                 Pf_positive_RDT_and_microscopy = Q16_3, # Q16-3: P.f Positive Result by Microscopy Detection and RDT
                                 Pv_positive_RDT_and_microscopy = Q16_4, # Q16-4: P.v Positive Result by Microscopy Detection and RDT
                                 Mix_positive_RDT_and_microscopy = Q16_5, # Q16-5: Mix fPositive Result by Microscopy Detection and RDT
                                 Pm_positive_RDT_and_microscopy = Q16_6, # Q16-6: P.m Positive Result by Microscopy Detection and RDT
                                 Po_positive_RDT_and_microscopy = Q16_7, # Q16-7: P.o Positive Result by Microscopy Detection and RDT
                                 G6PD_normal = Q17_1, # Q17-1: Normal Level Result by G6PD
                                 G6PD_medium = Q17_2, # Q17-2: Medium Level Result by G6PD
                                 G6PD_serious = Q17_3, # Q17-3: Serious Level Result by G6PD
                                 Confirmed_not_serious_case_treated_Coartem_for_Pf = Q18_1, # Q18-1: Not serious case_Confirmed and have malaria treatment_Coartem for P.f. Present only in F2 and F3
                                 Confirmed_not_serious_case_treated_Coartem_for_Pv = Q18_2, # Q18-2: Not serious case_Confirmed and have malaria treatment_Coartem for P.v. Present only in F2 and F3
                                 Confirmed_not_serious_case_treated_Coartem_for_Mix = Q18_3, # Q18-3: Not serious case_Confirmed and have malaria treatment_Coartem for Mix. Present only in F2 and F3
                                 Confirmed_not_serious_case_treated_Primaquine = Q18_4, # Q18-4: Not serious case_Confirmed and have malaria treatment_Primaquine. Present only in F2 and F3
                                 Confirmed_not_serious_case_treated_Other_medicine = Q18_5, # Q18-5: Not serious case_Confirmed and have malaria treatment_Other medisine. Present only in F2, F2_1 and F3
                                 Q18_6 = Q18_6,
                                 Q18_7 = Q18_7,
                                 Suspected_not_serious_case_treated_Coartem = Q19_1, # Q19-1: Not serious case_Suspected patient have malaria but don't have blood testing_Coartem treatment. Present in all A3 forms.
                                 Suspected_not_serious_case_treated_Other_medicine = Q19_2, # Q19-2: Not serious case_Suspected patient have malaria but don't have blood testing_Provide other medicine. Present in all A3 forms.
                                 Confirmed_serious_case_treated_Artesunate = Q20_1, # Q20-1: Serious case_Confirmed and have malaria treatmentNot serious case_Artesunate for Injection. Present only in F2, F2_1 and F3
                                 Confirmed_serious_case_treated_Coartem = Q20_2, # Q20-2: Serious case_Confirmed and have malaria treatmentNot serious case_Continue Treatment by Coartem. Present only in F2 and F3
                                 Confirmed_serious_case_treated_Quinine = Q20_3, # Q20-3: Serious case_Confirmed and have malaria treatmentNot serious case_Quinine (saline). Present only in F2, F2_1 and F3
                                 Q20_4 = Q20_4,
                                 Suspected_serious_case_treated_Artesunate = Q21_1, # Q21-1:  Serious case_Suspected patient have malaria but don't have blood testing_Artesunate for Injection. Present only in F2_1 and F3
                                 Suspected_serious_case_treated_Quinine = Q21_2, # Q21-2:  Serious case_Suspected patient have malaria but don't have blood testing_Quinine (saline). Present only in F2_1 and F3
                                 Q21_3 = Q21_3,
                                 Let_patient_stay = Q22, # Q22: Let patient stay (HC/Hospital)
                                 Received_patient_from_other_place = Q23, # Q23: Received patient from other place
                                 Send_patient_to_other_place = Q24, # Q24: Sendpatient to other that have more treatment potential
                                 Death_because_of_malaria = Q25, # Q25: Death because of Malaria
                                 Note = Q26, # Q26: Note
                                 Malaria_treatment_Coartem_6.1 = Q28_1, # Q28_1: Malaria treatment_Coartem Trestment - 6x1 ( 6 pills/panel). Present in F1 only
                                 Malaria_treatment_Coartem_6.2 = Q28_2, # Q28_2: Malaria treatment_Coartem Trestment - 6x2 ( 12 pills/panel). Present in F1 only
                                 Malaria_treatment_Coartem_6.3 = Q28_3, # Q28_3: Malaria treatment_Coartem Trestment - 6x3 ( 18 pills/panel). Present in F1 only
                                 Malaria_treatment_Coartem_6.4 = Q28_4, # Q28_4: Malaria treatment_Coartem Trestment - 6x4 ( 24 pills/panel). Present in F1 only
                                 Malaria_treatment_Other_medicine = Q28_5, # Q28_5: Malaria treatment_Give other medicine
                                 Where_patient_from_in_province = Q33_1, # Q33-1: Where  patient come from?_  patient in the province
                                 Where_patient_from_other_province = Q33_2, # Q33-2: Where patient come from?_  patient from other province
                                 Where_patient_from_foreigner = Q33_3, # Q33-3: Where patient come from?_ Foreigner patient
                                 Ethnicity = Q35, # Q35: Ethnicity/ Nationalilty?
                                 Age_2 = Q36, # Q36: Age for missing Age_1
                                 Treatment_by_DOT = Q37, # Q37: Trestment by DOT
                                 Activity_in_last_14_days_Forest = Q37_1, # Q37-1: What is your activity in last 14 days? _Stayed in the forest
                                 Activity_in_last_14_days_Farm = Q37_2, # Q37-2: What is your activity in last 14 days? _Stayed in the farm
                                 Activity_in_last_14_days_Travel_other = Q37_3, # Q37-3: What is your activity in last 14 days? _Travel to other areas
                                 Activity_in_last_14_days_Home = Q37_4, # Q37-4:  What is your activity in last 14 days? _Stayed home
                                 Treatment_Other_medicine = Q38, # Q38: Trestment by other Malaria's medicine
                                 Treatment_result_1st_day_morning = Q39_1_1, # Q39-1-1: Treatment result _1st day - Morning
                                 Treatment_result_1st_day_afternoon = Q39_1_2, # Q39-1-2: Treatment result _1st day - Afternoon
                                 Treatment_result_2nd_day_morning = Q39_2_1, # Q39-2-1: Treatment result _2nd day - Morning
                                 Treatment_result_2nd_day_afternoon = Q39_2_2, # Q39-2-2:Treatment result _ 2nd day - Afternoon
                                 Treatment_result_3rd_day_morning = Q39_3_1, # Q39-3-1:Treatment result _ 3rd day - Morning
                                 Treatment_result_3rd_day_afternoon = Q39_3_2, # Q39-3-2:Treatment result _3rd day - Afternoon
                                 Treatment_result_4th_day_morning = Q39_4_1, # Q39-4-1:Treatment result _4th day - Morning
                                 Do_not_drink_enough_medicine = Q39_5, # Q39-5: Do not drink enough medicine
                                 Symptoms_not_serious = Q40, # Q40: Not Serious symptom?
                                 Symptoms_serious = Q41 # Q41: Serious symptom?
                                 )
                      )

#################
# Data Cleaning #
#################
# Create a list for factor level from codebook
Level_key_Occupation <- Level_key_function(Codebook_A3_south, slice.start = 12, slice.end = 54) # Q7: occupation
Level_key_Village <- Level_key_function(Codebook_A3_south, slice.start = 55, slice.end = 585) # Q8: Village
Level_key_District <- Level_key_function(Codebook_A3_south, slice.start = 586, slice.end = 599) # Q8: Village

# Explore patterns of data to inform subsequent data cleaning
Table_Infection_results <- (A3_South_Labelled
                            %>% mutate(Q14_5 = as.integer(Q14_5))
                            %>% select(
                              Pf_positive_RDT,
                                       Pv_positive_RDT,
                                       Mix_positive_RDT,
                                       Negative_RDT,
                                       # Negative_microscopy,
                                       # Positive_microscopy,
                                       # Pf_positive_microscopy,
                                       # Pv_positive_microscopy,
                                       # Mix_positive_microscopy,
                                       # Pm_positive_microscopy,
                                       # Po_positive_microscopy,
                                       Positive_RDT_and_microscopy,
                                       Negative_RDT_and_microscopy,
                                       Pf_positive_RDT_and_microscopy,
                                       Pv_positive_RDT_and_microscopy,
                                       Mix_positive_RDT_and_microscopy,
                                       Pm_positive_RDT_and_microscopy,
                                       Po_positive_RDT_and_microscopy
                                       )
                            %>% group_by(
                              Pf_positive_RDT,
                                         Pv_positive_RDT,
                                         Mix_positive_RDT,
                                         Negative_RDT,
                                         # Negative_microscopy,
                                         # Positive_microscopy,
                                         # Pf_positive_microscopy,
                                         # Pv_positive_microscopy,
                                         # Mix_positive_microscopy,
                                         # Pm_positive_microscopy,
                                         # Po_positive_microscopy,
                                         Positive_RDT_and_microscopy,
                                         Negative_RDT_and_microscopy,
                                         Pf_positive_RDT_and_microscopy,
                                         Pv_positive_RDT_and_microscopy,
                                         Mix_positive_RDT_and_microscopy,
                                         Pm_positive_RDT_and_microscopy,
                                         Po_positive_RDT_and_microscopy
                                         )
                            %>% count() #counts the number of obervations defined by group_by
                            %>% arrange(desc(n))
                            %>% rename(Frequency = n)
)

#View(Table_Infection_results)

Table_Treatment_results <- (A3_South_Labelled
                            %>% select(
                              Confirmed_not_serious_case_treated_Coartem_for_Pf,
                              Confirmed_not_serious_case_treated_Coartem_for_Pv,
                              Confirmed_not_serious_case_treated_Coartem_for_Mix,
                              Confirmed_not_serious_case_treated_Primaquine,
                              Confirmed_not_serious_case_treated_Other_medicine
                              ,
                              Suspected_not_serious_case_treated_Coartem,
                              Suspected_not_serious_case_treated_Other_medicine
                              ,
                              Confirmed_serious_case_treated_Artesunate,
                              Confirmed_serious_case_treated_Coartem,
                              Confirmed_serious_case_treated_Quinine,
                              Suspected_serious_case_treated_Artesunate,
                              Suspected_serious_case_treated_Quinine
                              ,
                              Malaria_treatment_Coartem_6.1,
                              Malaria_treatment_Coartem_6.2,
                              Malaria_treatment_Coartem_6.3,
                              Malaria_treatment_Coartem_6.4,
                              Malaria_treatment_Other_medicine
                              )
                            %>% group_by(
                              Confirmed_not_serious_case_treated_Coartem_for_Pf,
                              Confirmed_not_serious_case_treated_Coartem_for_Pv,
                              Confirmed_not_serious_case_treated_Coartem_for_Mix,
                              Confirmed_not_serious_case_treated_Primaquine,
                              Confirmed_not_serious_case_treated_Other_medicine
                              ,
                              Suspected_not_serious_case_treated_Coartem,
                              Suspected_not_serious_case_treated_Other_medicine
                              ,
                              Confirmed_serious_case_treated_Artesunate,
                              Confirmed_serious_case_treated_Coartem,
                              Confirmed_serious_case_treated_Quinine,
                              Suspected_serious_case_treated_Artesunate,
                              Suspected_serious_case_treated_Quinine
                              ,
                              Malaria_treatment_Coartem_6.1,
                              Malaria_treatment_Coartem_6.2,
                              Malaria_treatment_Coartem_6.3,
                              Malaria_treatment_Coartem_6.4,
                              Malaria_treatment_Other_medicine
                            )
                            %>% count() #counts the number of obervations defined by group_by
                            %>% arrange(desc(n))
                            %>% rename(Frequency = n)
)

#View(Table_Treatment_results)


# Clean
# Logic for data cleaning malaria infection is to produce a RDT_result with the result of the RDT (Pf, Pv, Pf and Pv, Negative). 
# Same for microscopy (Combination of Pf, Pv, Pm, Po, Negative). Priority is given to RDT and microscopy over RDT_and_microscopy.
# Note that we will drop mix and RDT_and_microscopy once we used the info provided

# For malaria infection and Treatment we create dummy variable for every level possible and clean so that only 1 of them is a 1 (=resolve conflict).
# Then we will reshape (see melt later) and observations for which we don't have a dummy = 1 (i.e a series of 0 and NAs), it means we actually don't know level. 
# When merged back in the data later (see A3_south_merged), this will correctly input an NA.


A3_South_Cleaned <- (A3_South_Labelled
                     %>% mutate(District_of_input = recode(District_of_input, "Phathoumphone district" = "Pathoomphone", "Pathoumphone" = "Pathoomphone", "Soukhouma" = "Sukhuma", "Sanasomboun" = "Sanasomboon"),
                                Date = as.Date(Date, format = "%d/%m/%Y"), # Change format to date
                                Age_1 = replace(Age_1, Age_1 == 999, NA), # Set Age_1 999 as NA
                                Age_2 = as.integer(replace(Age_2, Age_2 == 99, NA)), # Set Age_1 999 as NA
                                Male = replace(Male, Male == 99, NA), #Set Male = 99 as NA
                                Female = replace(Female, Female == 99, NA), #Set Female = 99 as NA
                                Occupation = replace(Occupation, Occupation == 99 | Occupation == 238, NA), #Set Occupation to NA if 99 ("blank") or 238 ("Cannot read/ Don't know meaning")
                                Occupation = as.factor(recode(Occupation, !!!Level_key_Occupation)), # Set Occupation as factor and recode factor levels
                                Village = replace(Village, Village == 999 | Village == 238, NA), #Set Village to NA if 999 ("blank") or 238 ("Cannot read/ Don't know meaning")
                                Village = recode(Village, !!!Level_key_Village), # Set Village as factor and recode factor levels # Caution: village number that do not appear in codebook are coded as NA
                                Village = gsub(pattern="Ban ", replacement ="", x = Village), # Format village name so that we can match with Village name with GPS
                                Village = paste("B.", Village, sep=" "), # Format village name so that we can match with Village name with GPS
                                Village = replace(Village, Village == "B. NA", NA), #Set Village to B.NA to NA
                                District = replace(District, District == 99 | District == 238, NA), #Set District to NA if 999 ("blank") or 238 ("Cannot read/ Don't know meaning")
                                District = as.factor(recode(District, !!!Level_key_District)), # Set Village as factor and recode factor levels # Caution: village number that do not appear in codebook are coded as NA
                                ### Malaria Infection
                                # Spread info from mix infection to Pf and Pv
                                Pf_positive_RDT = replace(Pf_positive_RDT, Mix_positive_RDT == 1, 1), # If mix, set Pf to 1 
                                Pv_positive_RDT = replace(Pv_positive_RDT, Mix_positive_RDT == 1, 1), # If mix, set Pv to 1
                                Pf_positive_microscopy = replace(Pf_positive_microscopy, Mix_positive_microscopy == 1, 1), # If mix, set Pf to 1 
                                Pv_positive_microscopy = replace(Pv_positive_microscopy, Mix_positive_microscopy == 1, 1), # If mix, set Pv to 1
                                Pf_positive_RDT_and_microscopy = replace(Pf_positive_RDT_and_microscopy, Mix_positive_RDT_and_microscopy == 1, 1), # If mix, set Pf to 1 
                                Pv_positive_RDT_and_microscopy = replace(Pv_positive_RDT_and_microscopy, Mix_positive_RDT_and_microscopy == 1, 1), # If mix, set Pv to 1
                                # Create Positive_RDT and update correctly for microscopy and RDT_and_microscopy. Will be used to resolve conflict later
                                Positive_RDT = Pf_positive_RDT,
                                Positive_RDT = replace(Positive_RDT, Pv_positive_RDT == 1, 1), # Creates a binary variable indicating whether there is a positive RDT. 
                                Positive_microscopy = replace(Positive_microscopy, Pf_positive_microscopy == 1 | Pv_positive_microscopy == 1 | Pm_positive_microscopy == 1 | Po_positive_microscopy == 1, 1), # Set to positive any microscopy that found a malaria species
                                Positive_RDT_and_microscopy = replace(Positive_RDT_and_microscopy, Pf_positive_RDT_and_microscopy == 1 | Pv_positive_RDT_and_microscopy == 1 | Pm_positive_RDT_and_microscopy == 1 | Po_positive_RDT_and_microscopy == 1, 1), # Set to positive any RDT and microscopy that found a malaria species
                                # Resolve Conflict within RDT_and_microscopy
                                Pf_positive_RDT_and_microscopy = replace(Pf_positive_RDT_and_microscopy, Pf_positive_RDT_and_microscopy == 1 & Negative_RDT_and_microscopy == 1, NA), # If Pf and Negative in RDT_and_microscopy, incloncusive test, set Pf to NA. Negative is set to NA later.
                                Pv_positive_RDT_and_microscopy = replace(Pv_positive_RDT_and_microscopy, Pv_positive_RDT_and_microscopy == 1 & Negative_RDT_and_microscopy == 1, NA), # If Pv and Negative in RDT_and_microscopy, incloncusive test, set Pf to NA. Negative is set to NA later.
                                Pm_positive_RDT_and_microscopy = replace(Pm_positive_RDT_and_microscopy, Pm_positive_RDT_and_microscopy == 1 & Negative_RDT_and_microscopy == 1, NA), # If Pm and Negative in RDT_and_microscopy, incloncusive test, set Pf to NA. Negative is set to NA later.
                                Po_positive_RDT_and_microscopy = replace(Po_positive_RDT_and_microscopy, Po_positive_RDT_and_microscopy == 1 & Negative_RDT_and_microscopy == 1, NA), # If Po and Negative in RDT_and_microscopy, incloncusive test, set Pf to NA. Negative is set to NA later.
                                Negative_RDT_and_microscopy = replace(Negative_RDT_and_microscopy, Positive_RDT_and_microscopy == 1 & Negative_RDT_and_microscopy == 1, NA), # If Positive and Negative in RDT_and_microscopy, incloncusive test, Negative is set to NA.
                                # Resolve Conflict within RDT
                                Pf_positive_RDT = replace(Pf_positive_RDT, Pf_positive_RDT == 1 & Negative_RDT == 1, NA), # If Pf and Negative in RDT, incloncusive test, set Pf to NA. Negative is set to NA later.
                                Pv_positive_RDT = replace(Pv_positive_RDT, Pv_positive_RDT == 1 & Negative_RDT == 1, NA), # If Pv and Negative in RDT, incloncusive test, set Pf to NA. Negative is set to NA later.
                                Negative_RDT = replace(Negative_RDT, Positive_RDT == 1 & Negative_RDT == 1, NA), # If Positive and Negative in RDT, incloncusive test, Negative is set to NA.
                                # Resolve Conflict within microscopy
                                Pf_positive_microscopy = replace(Pf_positive_microscopy, Pf_positive_microscopy == 1 & Negative_microscopy == 1, NA), # If Pf and Negative in microscopy, incloncusive test, set Pf to NA. Negative is set to NA later.
                                Pv_positive_microscopy = replace(Pv_positive_microscopy, Pv_positive_microscopy == 1 & Negative_microscopy == 1, NA), # If Pv and Negative in microscopy, incloncusive test, set Pf to NA. Negative is set to NA later.
                                Pm_positive_microscopy = replace(Pm_positive_microscopy, Pm_positive_microscopy == 1 & Negative_microscopy == 1, NA), # If Pm and Negative in microscopy, incloncusive test, set Pf to NA. Negative is set to NA later.
                                Po_positive_microscopy = replace(Po_positive_microscopy, Po_positive_microscopy == 1 & Negative_microscopy == 1, NA), # If Po and Negative in microscopy, incloncusive test, set Pf to NA. Negative is set to NA later.
                                Negative_microscopy = replace(Negative_microscopy, Positive_microscopy == 1 & Negative_microscopy == 1, NA), # If Positive and Negative in microscopy, incloncusive test, Negative is set to NA.
                                # Borrow information from cleaned RDT_and_microscopy for inconclusive RDT and microscopy test. Note use of %in% instead of == because of how NAs are handled in booleans
                                Negative_RDT = replace(Negative_RDT, ( !(Positive_RDT %in% 1) & !(Negative_RDT %in% 1) ) & ( !(Positive_RDT_and_microscopy %in% 1) & Negative_RDT_and_microscopy == 1), 1), # If no info on RDT use conclusive info on RDT & microscopy
                                Negative_microscopy = replace(Negative_microscopy, ( !(Positive_microscopy %in% 1) & !(Negative_microscopy %in% 1) ) & ( !(Positive_RDT_and_microscopy %in% 1) & Negative_RDT_and_microscopy == 1), 1), # If no info on RDT use conclusive info on RDT & microscopy
                                Pf_positive_RDT = replace(Pf_positive_RDT, ( !(Positive_RDT %in% 1) & !(Negative_RDT %in% 1) ) & (Pf_positive_RDT_and_microscopy == 1 & !(Negative_RDT_and_microscopy %in% 1) ), 1), # If no info on RDT use conclusive info on RDT & microscopy
                                Pv_positive_RDT = replace(Pv_positive_RDT, ( !(Positive_RDT %in% 1) & !(Negative_RDT %in% 1) ) & (Pv_positive_RDT_and_microscopy == 1 & !(Negative_RDT_and_microscopy %in% 1) ), 1), # If no info on RDT use conclusive info on RDT & microscopy
                                Pf_positive_microscopy = replace(Pf_positive_microscopy, ( !(Positive_microscopy %in% 1) & !(Negative_microscopy %in% 1) ) & (Pf_positive_RDT_and_microscopy == 1 & !(Negative_RDT_and_microscopy %in% 1) ), 1), # If no info on RDT use conclusive info on RDT & microscopy
                                Pv_positive_microscopy = replace(Pv_positive_microscopy, ( !(Positive_microscopy %in% 1) & !(Negative_microscopy %in% 1) ) & (Pv_positive_RDT_and_microscopy == 1 & !(Negative_RDT_and_microscopy %in% 1) ), 1), # If no info on RDT use conclusive info on RDT & microscopy
                                Pm_positive_microscopy = replace(Pm_positive_microscopy, ( !(Positive_microscopy %in% 1) & !(Negative_microscopy %in% 1) ) & (Pm_positive_RDT_and_microscopy == 1 & !(Negative_RDT_and_microscopy %in% 1) ), 1), # If no info on RDT use conclusive info on RDT & microscopy
                                Po_positive_microscopy = replace(Po_positive_microscopy, ( !(Positive_microscopy %in% 1) & !(Negative_microscopy %in% 1) ) & (Po_positive_RDT_and_microscopy == 1 & !(Negative_RDT_and_microscopy %in% 1) ), 1), # If no info on RDT use conclusive info on RDT & microscopy
                                ### Treatment
                                Malaria_treatment_Coartem_6.1 = as.integer(Malaria_treatment_Coartem_6.1),
                                Malaria_treatment_Coartem_6.2 = as.integer(Malaria_treatment_Coartem_6.2),
                                Malaria_treatment_Coartem_6.3 = as.integer(Malaria_treatment_Coartem_6.3),
                                Malaria_treatment_Coartem_6.4 = as.integer(Malaria_treatment_Coartem_6.4),
                                Received_Coartem_Treatment = Confirmed_not_serious_case_treated_Coartem_for_Pf,
                                Received_Coartem_Treatment = replace(Received_Coartem_Treatment, Confirmed_not_serious_case_treated_Coartem_for_Pv == 1 | Confirmed_not_serious_case_treated_Coartem_for_Mix == 1 | Suspected_not_serious_case_treated_Coartem == 1 | Confirmed_serious_case_treated_Coartem == 1 | Malaria_treatment_Coartem_6.1 == 1 | Malaria_treatment_Coartem_6.2 == 1 | Malaria_treatment_Coartem_6.3 == 1 | Malaria_treatment_Coartem_6.4 == 1, 1), # If any variable indicates Coartem treatment was received, code it in new Received_Coartem_Treatment variable. Note that (NA | TRUE) = TRUE, so we are good.
                                Received_Primaquine_Treatment = Confirmed_not_serious_case_treated_Primaquine,
                                Received_Artesunate_Treatment = Confirmed_serious_case_treated_Artesunate,
                                Received_Artesunate_Treatment = replace(Received_Artesunate_Treatment, Suspected_serious_case_treated_Artesunate == 1, 1), # If any variable indicates Artesunate treatment was received, code it in new Received_Artesunate_Treatment variable. Note that (NA | TRUE) = TRUE, so we are good.
                                Received_Quinine_Treatment = Confirmed_serious_case_treated_Quinine,
                                Received_Quinine_Treatment = replace(Received_Quinine_Treatment, Suspected_serious_case_treated_Quinine == 1, 1), # If any variable indicates Quinine treatment was received, code it in new Received_Quinine_Treatment variable. Note that (NA | TRUE) = TRUE, so we are good.
                                Received_Other_Treatment = Confirmed_not_serious_case_treated_Other_medicine,
                                Received_Other_Treatment = replace(Received_Other_Treatment, Suspected_not_serious_case_treated_Other_medicine == 1 | Treatment_by_DOT == 1, 1), # If any variable indicates Other treatment was received, code it in new Received_Other_Treatment variable. Note that (NA | TRUE) = TRUE, so we are good.
                                Received_No_Treatment = NA, # Creates Received_No_Treatment dummy and fill with 1 when certain did not received any treatment of interest, i.e answer is 0 to all questions asked about treatment. mice::md.pattern was used to understand patterns of treatment questions asked by type of A3 data (F1, F2, F3)
                                Received_No_Treatment = replace(Received_No_Treatment,(!is.na(F1_ID) & Malaria_treatment_Coartem_6.1 == 0 & Malaria_treatment_Coartem_6.2 == 0 & Malaria_treatment_Coartem_6.3 == 0 & Malaria_treatment_Coartem_6.4 == 0), 1), # In the F1 data, one block defining whether treatment was received is {Malaria_treatment_Coartem_6.1, Malaria_treatment_Coartem_6.2, Malaria_treatment_Coartem_6.3, Malaria_treatment_Coartem_6.4}
                                Received_No_Treatment = replace(Received_No_Treatment,(!is.na(F1_ID) & Suspected_not_serious_case_treated_Coartem == 0 & Suspected_not_serious_case_treated_Other_medicine == 0), 1), # In the F1 data, one block defining whether treatment was received is {Suspected_not_serious_case_treated_Coartem, Suspected_not_serious_case_treated_Other_medicine}
                                Received_No_Treatment = replace(Received_No_Treatment,(!is.na(F1_2_ID) & Suspected_not_serious_case_treated_Coartem == 0 & Suspected_not_serious_case_treated_Other_medicine == 0), 1), # In the F1_2 data, only block defining whether treatment was received is {Muspected_not_serious_case_treated_Coartem, Suspected_not_serious_case_treated_Other_medicine}
                                Received_No_Treatment = replace(Received_No_Treatment,(!is.na(F2_ID) & Suspected_not_serious_case_treated_Coartem == 0 & Suspected_not_serious_case_treated_Other_medicine == 0 & Confirmed_not_serious_case_treated_Other_medicine == 0 & Confirmed_serious_case_treated_Artesunate == 0 & Confirmed_serious_case_treated_Quinine == 0 & Confirmed_not_serious_case_treated_Coartem_for_Pf == 0 & Confirmed_not_serious_case_treated_Coartem_for_Pv == 0 & Confirmed_not_serious_case_treated_Coartem_for_Mix == 0 & Confirmed_not_serious_case_treated_Primaquine == 0 & Confirmed_serious_case_treated_Coartem == 0), 1), # In the F2 data, only block defining whether treatment was received is {Suspected_not_serious_case_treated_Coartem, Suspected_not_serious_case_treated_Other_medicine, Confirmed_not_serious_case_treated_Other_medicine, Confirmed_serious_case_treated_Artesunate, Confirmed_serious_case_treated_Quinine, Confirmed_not_serious_case_treated_Coartem_for_Pf, Confirmed_not_serious_case_treated_Coartem_for_Pv, Confirmed_not_serious_case_treated_Coartem_for_Mix, Confirmed_not_serious_case_treated_Primaquine, Confirmed_serious_case_treated_Coartem}
                                Received_No_Treatment = replace(Received_No_Treatment,(!is.na(F2_1_ID) & Suspected_not_serious_case_treated_Coartem == 0 & Suspected_not_serious_case_treated_Other_medicine == 0 & Confirmed_not_serious_case_treated_Other_medicine == 0 & Confirmed_serious_case_treated_Artesunate == 0 & Confirmed_serious_case_treated_Quinine == 0 & Suspected_serious_case_treated_Artesunate == 0 & Suspected_serious_case_treated_Quinine == 0), 1), # In the F2_1 data, only block defining whether treatment was received is {Suspected_not_serious_case_treated_Coartem, Suspected_not_serious_case_treated_Other_medicine, Confirmed_not_serious_case_treated_Other_medicine, Confirmed_serious_case_treated_Artesunate, Confirmed_serious_case_treated_Quinine, Suspected_serious_case_treated_Artesunate, Suspected_serious_case_treated_Quinine}
                                Received_No_Treatment = replace(Received_No_Treatment,(!is.na(F3_ID) & Suspected_not_serious_case_treated_Coartem == 0 & Suspected_not_serious_case_treated_Other_medicine == 0 & Confirmed_not_serious_case_treated_Other_medicine == 0 & Confirmed_serious_case_treated_Artesunate == 0 & Confirmed_serious_case_treated_Quinine == 0 & Confirmed_not_serious_case_treated_Coartem_for_Pf == 0 & Confirmed_not_serious_case_treated_Coartem_for_Pv == 0 & Confirmed_not_serious_case_treated_Coartem_for_Mix == 0 & Confirmed_not_serious_case_treated_Primaquine == 0 & Confirmed_serious_case_treated_Coartem == 0), 1), # In the F3 data, only block defining whether treatment was received is {Suspected_not_serious_case_treated_Coartem, Suspected_not_serious_case_treated_Other_medicine, Confirmed_not_serious_case_treated_Other_medicine, Confirmed_serious_case_treated_Artesunate, Confirmed_serious_case_treated_Quinine, Confirmed_not_serious_case_treated_Coartem_for_Pf, Confirmed_not_serious_case_treated_Coartem_for_Pv, Confirmed_not_serious_case_treated_Coartem_for_Mix, Confirmed_not_serious_case_treated_Primaquine, Confirmed_serious_case_treated_Coartem}
                                Received_No_Treatment = replace(Received_No_Treatment,(!is.na(DOT_ID) & Treatment_by_DOT == 0), 1) # In the DOT data, only block defining whether treatment was received is {Treatment_by_DOT}
                                )
                     )

### Note: the distribution of all variables created that way was triple checked to make sure it's respecting the raw data, so we are good!

#####################
# Derived Variables #
#####################
# Create the RDT_result variable to be merged with data
RDT_result <- (A3_South_Cleaned
               %>% select(Pf_positive_RDT,
                          Pv_positive_RDT,
                          Negative_RDT)
               %>% rename(Pf = Pf_positive_RDT,
                          Pv = Pv_positive_RDT,
                          Negative = Negative_RDT)
               %>% mutate(Observation_number = row_number()) # Create ID variable for matching
               %>% melt(id.var = 'Observation_number', variable.name = 'RDT_result') # Reshape from wide to long: for every observation number, we have as many rows as there are variables in the table in addition to ID.var (3 here: Pf, Pv, Negative) and the column "value" contains the value of the variable
               %>% filter(value == 1) # Keep RDT results that are informative: If there is one 1, indicates we know (conflict resolved earlier in A3_South_cleaned). If only 0 or NA, indicates we don't know RDT result for that observation
               %>% select(Observation_number, RDT_result)
               %>% group_by(Observation_number)
               %>% mutate(RDT_result = paste0(RDT_result, collapse = ", ")) # Gather RDT result if several per observation. E.g: paste Pf and Pv into Pf, PV
               %>% distinct()
)

# Create the Microscopy_result variable to be merged with data
Microscopy_result <- (A3_South_Cleaned
                      %>% select(Pf_positive_microscopy,
                                 Pv_positive_microscopy,
                                 Pm_positive_microscopy,
                                 Po_positive_microscopy,
                                 Negative_microscopy)
                      %>% rename(Pf = Pf_positive_microscopy,
                                 Pv = Pv_positive_microscopy,
                                 Pm = Pm_positive_microscopy,
                                 Po = Po_positive_microscopy,
                                 Negative = Negative_microscopy)
                      %>% mutate(Observation_number = row_number())
                      %>% melt(id.var = 'Observation_number', variable.name = 'Microscopy_result')
                      %>% filter(value == 1)
                      %>% select(Observation_number, Microscopy_result)
                      %>% group_by(Observation_number)
                      %>% mutate(Microscopy_result = paste0(Microscopy_result, collapse = ", "))
                      %>% distinct()
)


# Create the Treatment_result variable to be merged with data
Treatment_result <- (A3_South_Cleaned
                     %>% select(Received_Coartem_Treatment,
                                Received_Artesunate_Treatment,
                                Received_Primaquine_Treatment,
                                Received_Quinine_Treatment,
                                Received_Other_Treatment,
                                Received_No_Treatment)
                     %>% rename(Coartem = Received_Coartem_Treatment,
                                Artesunate = Received_Artesunate_Treatment,
                                Primaquine = Received_Primaquine_Treatment,
                                Quinine = Received_Quinine_Treatment,
                                Other = Received_Other_Treatment,
                                None = Received_No_Treatment)
                     %>% mutate(Observation_number = row_number())
                     %>% melt(id.var = 'Observation_number', variable.name = 'Treatment')
                     %>% filter(value == 1)
                     %>% select(Observation_number, Treatment)
                     %>% group_by(Observation_number)
                     %>% mutate(Treatment = paste0(Treatment, collapse = ", "))
                     %>% distinct()
                     )

# Merged RDT and Microscopy result with data
A3_South_Merged <- (A3_South_Cleaned
                    %>% mutate(Observation_number = row_number()) # For matching
                    %>% left_join(RDT_result, by = "Observation_number") # Merge RDT results
                    %>% left_join(Microscopy_result, by = "Observation_number") # Merge Microscopy results
                    %>% left_join(Treatment_result, by = "Observation_number") # Merge Treatment results
                    )


A3_South_Full <- (A3_South_Merged
                  %>% mutate(Age = ifelse(is.na(Age_1), yes = Age_2,  no = Age_1), # Use Age_2 for age when Age_1 is missing (mice::md.pattern) shows that Age_2 is non missing only when Age_1 is missing
                             Is_Male = ifelse(Male == 1 & Female == 1, yes = NA, no = Male), # If male and female = 1, set to NA
                             Pregnant = replace(Pregnant, Pregnant == 1 & Is_Male == 1, NA), # Set pregant male to NA for pregancy
                             Is_Male = replace(Is_Male, is.na(Is_Male) & Pregnant == 1, 0), # Set gender to female is unknown gender but pregnant
                             Is_Male = as.factor(recode(Is_Male, '1' = "Yes", '0' = "No")) # Set Is_Male as factor and recode factor levels
                             )
                  )




########################################
# Restriction to interesting variables #
########################################
A3_South <- (A3_South_Full
             %>% select(Date,
                        Age,
                        Is_Male,
                        Occupation,
                        District_of_input, # Matching Key uses District_of_input instead of District because District is 80% missing
                        Village,
                        RDT_result,
                        Microscopy_result,
                        Treatment
                        )
             )


########
# Save # 
########
setwd("/Users/francoisrerolle/Desktop/UCSF/Dissertation/Paper-1-Geospatial-Analysis-Forest-Incidence/Data/Cleaned/Malaria Incidence")
write.csv(A3_South, file = "A3_South.csv", row.names = F) # Save an excel file for easy visualization
save(file="A3_South.RData", A3_South) # Save an Rdata file to conserve data cleaning/management features


