#This code merges the clean A3 data with the clean list of Village with GPS via the matching key

#Clear working environment
rm(list=ls())

#Set working directory
setwd("/Users/francoisrerolle/Desktop/UCSF/Dissertation/Paper-1-Geospatial-Analysis-Forest-Incidence/Data/Cleaned")

#Load packages
library(tidyverse)

### Load the data
# Malaria Incidence
load("Malaria Incidence/A3_South.RData")

# Matching Village Key between A3 and GPS datasets
Village_Key_A3_GPS <- read_csv("Village Key A3 - GPS/Village_Key_A3_GPS.csv", col_types = "cccc")

# List of Village name with GPS
Champasak_Villages_Coordinates <- read_csv("Village Coordinates/Champasak/Champasak_Villages_Coordinates.csv", col_types = "ccnn")

### Merge, rename variables and select variables of interest
A3_South_GPS <- (A3_South
                 %>% left_join(Village_Key_A3_GPS, by = c("District_of_input" = "District_A3", "Village" = "Village_A3")) # Merged by district and village to include in the data set modified district and village name for which we have GPS coordinates
                 %>% mutate(District_GPS = ifelse(is.na(District_GPS), yes = District_of_input, no = District_GPS), # If no modification needed to match with the GPS dataset, use A3 district
                            Village_GPS = ifelse(is.na(Village_GPS), yes = Village, no = Village_GPS)) # If no modification needed to match with the GPS dataset, use A3 Village
                 %>% left_join(Champasak_Villages_Coordinates, by = c("District_GPS" = "District", "Village_GPS" = "Village")) # Merged by district and village to include in the data set GPS coordinates
                 %>% dplyr::select(-Village, -District_of_input) # Remove undesirable variables
                 %>% rename(District = District_GPS,
                            Village = Village_GPS)
                 )

# Proportion of the data not matched
sum(is.na(A3_South_GPS$Longitude))/nrow(A3_South_GPS) # 11%
                 
########
# Save # 
########
setwd("/Users/francoisrerolle/Desktop/UCSF/Dissertation/Paper-1-Geospatial-Analysis-Forest-Incidence/Data/Merged")
write.csv(A3_South_GPS, file = "A3_South_GPS.csv", row.names = F) # Save an excel file for easy visualization
save(file="A3_South_GPS.RData", A3_South_GPS) # Save an Rdata file to conserve data cleaning/management features

### Asking for additional potential matching

Table_Villages_Missing_Coordinates  <- (A3_South_GPS
                                        %>% filter(is.na(Latitude) | is.na(Longitude))
                                        %>% filter(!is.na(Village))
                                        %>% group_by(District, Village)
                                        %>% count() #counts the number of obervations defined by group_by
                                        %>% arrange(desc(n))
                                        %>% rename(Frequency = n)
                                        %>% dplyr::select(District, Village, Frequency)
                                        %>% filter(Frequency >= 50)
                                        )

setwd("/Users/francoisrerolle/Desktop/UCSF/Dissertation/Paper-1-Geospatial-Analysis-Forest-Incidence/Data/Cleaned/Village Key A3 - GPS")
write.csv(Table_Villages_Missing_Coordinates, file = "Table_Villages_Missing_Coordinates.csv", row.names = F) # Save an excel file for easy visualization
