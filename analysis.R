
# Loading the libraries
library(dplyr)
library(tidyr)
library(plotly)
library(rvest)

# Setting working directory
setwd("~/Info-201-Final-Project")
soccer.data <- read.csv("Data/complete.csv", stringsAsFactors = FALSE, encoding = "UTF-8")

# Group by teams
players.rating.70 <- filter(soccer.data, overall > 70)
league.data <- group_by(players.rating.70, league) %>% 
             summarize(number.players = n(),mean.age = mean(age), mean.rating = mean(overall), median.rating = median(overall))

# Premier league data
premier.league <- filter(soccer.data, grepl("English Premier League", league))

# Teams
premier.top.6.teams <- c("Chelsea", "Tottenham Hotspur", "Manchester City", "Liverpool", "Arsenal", "Manchester United")
premier.top.6.teams.players <- filter(soccer.data, club %in% premier.top.6.teams)
premier.team.body.types <- premier.top.6.teams.players %>% group_by(club) %>% 
                           summarize(amount.lean = sum(grepl("Lean", body_type)), amount.normal = sum(grepl("Normal", body_type)), 
                                     amount.stocky = sum(grepl("Stocky", body_type)))

# determining accuracy
goal.keepers <- filter(soccer.data, is.na(rs))
url <- "https://www.premierleague.com/stats/top/players/clean_sheet"
premier.stats <- read_html(url) %>% 
                 html_nodes("table") %>% 
                 head()
                 #html_nodes(xpath='//*[@id="mainContent"]/div[2]/div/div[2]/div[1]/div[2]/table') %>% 
                 #html_table()


min.overall <- filter(soccer.data, overall >= 90) %>% 
               filter(eur_wage > 500000)