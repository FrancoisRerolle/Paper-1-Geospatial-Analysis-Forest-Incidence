#This code runs some descriptive statistics on the cleaned final dataset

#Clear working environment
rm(list=ls())

#Set working directory
setwd("/Users/francoisrerolle/Desktop/UCSF/Dissertation/Paper-1-Geospatial-Analysis-Forest-Incidence/Data/Final")

#Load packages
library(tidyverse)
library(reshape2)
library(ggplot2)
library(ggpubr)


# Load the data
load("A3_South.RData")

# Correct class
A3_South <- (A3_South
             %>% mutate(RDT_result = as.factor(RDT_result),
                        Microscopy_result = as.factor(Microscopy_result),
                        District = as.factor(District),
                        Village = as.factor(Village))
             )

# Restrict to 4 districts of collection
A3_South_MPSS <- (A3_South
                  %>% filter(District %in% c("Moonlapamok", "Pathoomphone", "Sanasomboon", "Sukhuma"))
                  %>% mutate(District = as.factor(District),
                             Village = as.factor(Village))
                  )

setwd("/Users/francoisrerolle/Desktop/UCSF/Dissertation/Paper-1-Geospatial-Analysis-Forest-Incidence/Analyses")


