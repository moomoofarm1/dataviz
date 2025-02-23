library(tidyverse)
library(lubridate)

covid <- read_csv(
 "https://opendata.ecdc.europa.eu/covid19/nationalcasedeath/csv"
)

covid2 <-
  covid %>%
  as_tibble() %>%
  select(-source) %>%
  filter(!str_detect(country, "total"),
         !(country %in% c("Bonaire, Saint Eustatius and Saba")))

covid3 <-
  covid2 %>%
  separate(year_week, c("year", "week")) %>%
  mutate(
    year = as.integer(year),
    week = as.integer(week) - 1L,
    date = as.Date(paste(year, week, 1, sep = "/"), "%Y/%W/%u"),
    month = as.integer(month(date))
  ) %>%
  select(
    country,
    country_code,
    population,
    date,
    year,
    month,
    week,
    date,
    indicator,
    weekly_count,
    rate_14_day,
    cumulative_count
  )

write_csv(covid3, "data/covid.csv")
