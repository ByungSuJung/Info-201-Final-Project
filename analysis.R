
# Loading the libraries
library(dplyr)
library(tidyr)
library(plotly)

# Setting working directory
soccer.data <- read.csv("Data/complete.csv", stringsAsFactors = FALSE, encoding = "UTF-8")


# Function for finding leagues
Find2016LeagueData <- function(league.name, not.current.teams){
  full.league <- filter(soccer.data, league == league.name) %>% 
    group_by(club) %>% summarize(amount.players = n(), median.overall = median(overall), median.potential = median(potential), 
                                 median.physical = median(phy), average.int.rep = mean(international_reputation), median.agility = median(agility),
                                 median.aggression = median(aggression), median.stamina = median(stamina), median.composure = median(composure))
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

# Prep for graphs

## Changing column names for all graphs
new.column.names <- c("Clubs","Number of Players", "Median Overall Rating", "Median Potential Rating", "Median Physical Rating", "Average International Reputation Rating",
                      "Median Agility Rating", "Median Aggression Rating", "Median Stamina Rating", "Median Composure Rating", "Games Played", "Wins","Draws",
                      "Losses", "Goals For", "Goals Against", "Difference in Goals", "Total Points Scored")
colnames(britain.full) <- new.column.names
colnames(french.full) <- new.column.names
colnames(germany.full) <- new.column.names
colnames(italy.full) <- new.column.names
colnames(mexico.full) <- new.column.names
colnames(spain.full) <- new.column.names
colnames(usa.full) <- new.column.names

## Leagues
league.choices <- c("English Premier League","USA Major League Soccer","French Ligue 1","Italian Serie A","German Bundesliga",
                    "Spanish Primera División","Mexican Liga MX")

## X Axis
teams.x.axis <- c("Games.Played", "Wins", "Draws", "Losses", "Goals.For", "Goals.Against", "Goal.Difference", "Points")

## Y Axis
teams.y.axis <- c("")