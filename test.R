
# Loading the libraries
library(dplyr)
library(tidyr)
library(plotly)
library(rvest)
library(DT)

# Setting working directory
setwd("~/Info-201-Final-Project")
soccer.data <- read.csv("Data/complete.csv", stringsAsFactors = FALSE, encoding = "UTF-8")

# Group by teams
players.rating.70 <- filter(soccer.data, overall > 70)
league.data <- group_by(players.rating.70, league) %>% 
  summarize(number.players = n(),mean.age = mean(age), mean.rating = mean(overall), median.rating = median(overall))

# 7 Leagues
seven.leagues <- c("English Premier League", "USA Major League Soccer", "French Ligue 1", "Italian Serie A", "German Bundesliga", "Spanish Primera División",
                   "Mexican Liga MX")
seven.leagues.data <- filter(soccer.data, league %in% seven.leagues)
seven.leagues.body.types <- seven.leagues.data %>% group_by(league) %>% 
  summarize(percent.lean = round(mean(grepl("Lean", body_type)) * 100, digits = 2), percent.normal = round(mean(grepl("Normal", body_type)) * 100, digits = 2), 
            mean.stocky = round(mean(grepl("Stocky", body_type)), digits = 2))

# Function for finding leagues
Find2016LeagueData <- function(league.name, not.current.teams){
  full.league <- filter(soccer.data, league == league.name) %>% 
    group_by(club) %>% summarize(amount.players = n())
  last.season.full.league <- full.league[full.league$club %in% not.current.teams,]
  return (full.league)
}