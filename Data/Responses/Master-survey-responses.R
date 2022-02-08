library(tidyverse)
library(readxl)
library(janitor)


# Upload master responses part 1 ---------------------------------------------------------------------------------------------------

data <- read_excel("Data/Responses/EMS Survey 2016 _Text Responses_MASTER.xlsx") 

data.q1 <- data %>%
  select(1:9) %>%
  gather(key = "response", value = "region", 2:9) %>%
  mutate(region = str_replace(region, "-", NA_character_)) %>%
  drop_na(region) %>%
  select(1,3)

data.q2 <- data %>%
  select(1,10)

data.q3.end <- data %>%
  select(1,11:ncol(.))

master.data <- data.q1 %>%
  left_join(data.q2, by = "Record ID") %>%
  left_join(data.q3.end, by = "Record ID")


# Upload master responses part 2 ------------------------------------------

data.2 <- read_excel("Data/Responses/EMS Survey 2016 - All Responses  1,0 format-  2016-7-5 USE.xlsx") %>%
  mutate(`Education, Certification and Recertification (Q32)` = ifelse(`Education, Certification and Recertification (Q32)` == 1, "Agency covers all costs", 
                                                                       ifelse(`Education, Certification and Recertification (Q32)` == 2, "Agency and staff", "Staff covers all costs")),
         `Training (Q33)` = ifelse(`Training (Q33)` == 1, "Yes", "No"),
         `ContinuingEd (Q92_1)` = ifelse(`ContinuingEd (Q92_1)` == 1, "Yes", "No"))

names(data.2)
write_csv(master.data, "Data/Master-survey-responses.csv")  
