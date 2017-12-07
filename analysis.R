
# Loading the libraries
library(dplyr)
library(tidyr)
library(plotly)


# Setting working directory
soccer.data <- read.csv("Data/complete.csv", stringsAsFactors = FALSE, encoding = "UTF-8")

# Function for finding leagues
Find2016LeagueData <- function(league.teams){
  full.league <- filter(soccer.data, club %in% league.teams)
  full.league.name <- as.character(unique(full.league$league))
  full.league <- group_by(full.league, club) %>% summarize(amount.players = n(), median.overall = median(overall), median.potential = median(potential), 
                                 median.physical = median(phy), average.int.rep = mean(international_reputation), median.agility = median(agility),
                                 median.aggression = median(aggression), median.stamina = median(stamina), median.composure = median(composure))
  full.league$league <- full.league.name
  return (full.league)
}

# Britain
britain.wins <- read.csv("Data/premier2016-2017.csv", stringsAsFactors = FALSE)
britain.teams <- britain.wins$club
britain.last.season <- Find2016LeagueData(britain.teams)
britain.full <- left_join(britain.last.season, britain.wins)


# USA
usa.wins <- read.csv("Data/MLS2017-2018.csv", stringsAsFactors = FALSE)
usa.teams <- usa.wins$club
usa.last.season <- Find2016LeagueData(usa.teams)
usa.full <- left_join(usa.last.season, usa.wins)

# France
french.wins <- read.csv("Data/ligue12016-2017.csv", stringsAsFactors = FALSE)
french.teams <- french.wins$club
french.last.season <- Find2016LeagueData(french.teams)
french.full <- left_join(french.last.season, french.wins)

# Italy
italy.wins <- read.csv("Data/serieA2016-2017.csv", stringsAsFactors = FALSE)
italy.teams <- italy.wins$club
italy.last.season <- Find2016LeagueData(italy.teams)
italy.full <- left_join(italy.last.season, italy.wins)

# German
germany.wins <- read.csv("Data/bundesliga2016-2017.csv", stringsAsFactors = FALSE)
germany.teams <- germany.wins$club
germany.last.season <- Find2016LeagueData(germany.teams)
germany.full <- left_join(germany.last.season, germany.wins)

# Spain
spain.wins <- read.csv("Data/laliga2016-2017.csv", stringsAsFactors = FALSE)
spain.teams <- spain.wins$club
spain.last.season <- Find2016LeagueData(spain.teams)
spain.full <- left_join(spain.last.season, spain.wins)

# Mexico
mexico.wins <- read.csv("Data/ligaMXclausura2016-2017.csv", stringsAsFactors = FALSE)
mexico.teams <- mexico.wins$club
mexico.last.season <- Find2016LeagueData(mexico.teams)
mexico.full <- left_join(mexico.last.season, mexico.wins)

# Prep for graphs

## combining the data frames
britain.usa <- rbind(britain.full, usa.full)
french.germany <- rbind(french.full, germany.full)
spain.mexico <- rbind(spain.full, mexico.full)
fre.ger.ita <- rbind(french.germany, italy.full)
bri.usa.spa.mex <- rbind(britain.usa, spain.mexico)
all.leagues <- rbind(bri.usa.spa.mex, fre.ger.ita)

## Turning wins and losses to percentages
all.leagues <- mutate(all.leagues, percent.win = Wins/Games.Played*100) 
all.leagues <- mutate(all.leagues, percent.loss = Losses/Games.Played*100)

## Changing column names for all graphs
new.column.names <- c("Clubs","Number of Players", "Median Overall Rating", "Median Potential Rating", "Median Physical Rating", "Average International Reputation Rating",
                      "Median Agility Rating", "Median Aggression Rating", "Median Stamina Rating", "Median Composure Rating", "League", "Games Played", "Wins","Draws",
                      "Losses", "Goals For", "Goals Against", "Difference in Goals", "Points for Standings", "Win Percentage", "Loss Percentage")
colnames(all.leagues) <- new.column.names

## Leagues
league.choices <- c("All",unique(all.leagues$League))

## Y Axis
teams.y.axis <- c("Win Percentage", "Loss Percentage", "Goals For", "Goals Against", "Difference in Goals", "Points for Standings")

## X Axis
teams.x.axis <- c("Median Overall Rating", "Median Potential Rating", "Median Physical Rating", "Average International Reputation Rating",
                  "Median Agility Rating", "Median Aggression Rating", "Median Stamina Rating", "Median Composure Rating")

## Prep names
soccer.data <- plyr::rename(soccer.data, c("club"="Club", "age"="Age", "league"="League", "height_cm"="Height(cm)",
                                           "weight_kg"="Weight(kg)", "eur_value"="Value(EUR)","eur_wage"="Wage(EUR)",
                                           "eur_release_clause"="Release Clause(EUR)", "overall"="Overall", "potential"
                                           ="Potential", "pac"="Pace", "sho"="Shooting", "pas"="Passing", "dri"="Dribbling",
                                           "def"="Defense", "phy"="Physical", "international_reputation"="International
                                           Reputation", "skill_moves"="Skill Moves", "weak_foot"="Weak Foot", "crossing"=
                                             "Crossing", "finishing"="Finishing", "heading_accuracy"="Heading Accuracy",
                                           "short_passing"="Short Passing", "volleys"="Volleys", "dribbling"="Dribbling Skill",
                                           "curve"="Curve", "free_kick_accuracy"="Free Kick Accuracy", "long_passing"="Long Passing",
                                           "ball_control"="Ball Control", "acceleration"="Acceleration", "sprint_speed"="Sprint Speed",
                                           "agility"="Agility", "reactions"="Reactions", "balance"="Balance", "shot_power"="Shot Power",
                                           "jumping"="Jumping", "stamina"="Stamina", "strength"="Strength", "long_shots"="Long Shots",
                                           "aggression"="Aggression", "interceptions"="Interceptions", "positioning"="Positioning",
                                           "vision"="Vision", "penalties"="Penalties", "composure"="Composure", "marking"="Marking",
                                           "standing_tackle"="Standing Tackle", "sliding_tackle"="Sliding Tackle", "gk_diving"="Goalkeeper Diving",
                                           "gk_handling"="Goalkeeper Handling", "gk_kicking"="Goalkeeper Kicking", "gk_positioning"=
                                             "Goalkeeper Positioning", "gk_reflexes"="Goalkeeper Reflexes", "rs"="Right Striker", "rw"= "Right Wing",
                                           "rf"="Right Forward", "ram"="Right Attacking Midfielder", "rcm"="Right Center Midfielder",
                                           "rm"="Right Midfielder", "rdm"="Right Defensive Midfielder", "rcb"="Right Center Back",
                                           "rb"="Right Back", "rwb"="Right Wing Back", "st"="Striker", "lw"="Left Wing", "cf"="Center Forward",
                                           "cam"="Center Attacking Midfielder", "cm"="Center Midfielder", "lm"="Left Midfielder",
                                           "cdm"="Center Defensive Midfielder", "cb"="Center Back", "lb"="Left Back", "lwb"="Left Wing Back",
                                           "ls"="Left Striker", "lf"="Left Forward", "lam"="Left Attacking Midfielder", "lcm"="Left Center Midfielder",
                                           "ldm"="Left Defensive Midfielder", "lcb"="Left Center Back", "gk"="Goalkeeper"))

rm(list = ls()[grep(".last",ls())])
rm(list = ls()[grep(".wins",ls())])
#rm(list = ls()[grep("not.",ls())])
#rm(list = ls()[grep(".teams",ls())])
