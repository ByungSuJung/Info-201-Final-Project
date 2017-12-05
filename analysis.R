
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
  last.season.full.league <- full.league[!full.league$club %in% not.current.teams,]
  return (last.season.full.league)
}

# Britain
not.current.british.teams <- c("Brighton & Hove Albion", "Huddersfield Town", "Newcastle United")
britain.last.season <- Find2016LeagueData("English Premier League", not.current.british.teams)
britain.wins <- read.csv("Data/premier2016-2017.csv", stringsAsFactors = FALSE)
britain.full <- left_join(britain.last.season, britain.wins)

# USA
not.current.usa.teams <- c("Minnesota United","Atlanta United FC")
usa.last.season <- Find2016LeagueData("USA Major League Soccer", not.current.usa.teams)
usa.wins <- read.csv("Data/MLS2016-2017.csv", stringsAsFactors = FALSE)
usa.full <- left_join(usa.last.season, usa.wins)

# France
not.current.french.teams <- c("Amiens SC Football", "ES Troyes AC", "RC Strasbourg")
french.last.season <- Find2016LeagueData("French Ligue 1", not.current.french.teams)
french.wins <- read.csv("Data/ligue12016-2017.csv", stringsAsFactors = FALSE)
french.full <- left_join(french.last.season, french.wins)

# Italy
not.current.italy.teams <- c("Benevento Calcio", "Ferrara (SPAL)", "Hellas Verona")
italy.last.season <- Find2016LeagueData("Italian Serie A", not.current.italy.teams)
italy.wins <- read.csv("Data/serieA2016-2017.csv", stringsAsFactors = FALSE)
italy.full <- left_join(italy.last.season, italy.wins)

# German
not.current.german.teams <- c("Hannover 96", "VfB Stuttgart")
germany.last.season <- Find2016LeagueData("German Bundesliga", not.current.german.teams)
germany.wins <- read.csv("Data/bundesliga2016-2017.csv", stringsAsFactors = FALSE)
germany.full <- left_join(germany.last.season, germany.wins)

# Spain
not.current.spain.teams <- c("Getafe CF", "Girona CF", "Levante UD")
spain.last.season <- Find2016LeagueData("Spanish Primera División", not.current.spain.teams)
spain.wins <- read.csv("Data/laliga2016-2017.csv", stringsAsFactors = FALSE)
spain.full <- left_join(spain.last.season, spain.wins)

# Mexico
not.current.mexico.teams <- c("Lobos de la BUAP")
mexico.last.season <- Find2016LeagueData("Mexican Liga MX", not.current.mexico.teams)
mexico.wins <- read.csv("Data/ligaMXclausura2016-2017.csv", stringsAsFactors = FALSE)
mexico.full <- left_join(mexico.last.season, mexico.wins)


