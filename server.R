library(shiny)
library(plyr)
library(dplyr)

library(plotly)

# Read the csv file of FIFA 2018 soccer player dataset
raw.data <- read.csv("./Data/complete.csv", stringsAsFactors = FALSE, encoding = 'UTF-8')

# Changing the column names to be more user friendly
raw.data <- rename(raw.data, c("club"="Club", "age"="Age", "league"="League", "height_cm"="Height(cm)",
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

# Name of positions
positions <- select(raw.data, contains("prefers_")) %>% 
  colnames()

# Column names with numerical data in raw.data
raw.numerical.col.names <- raw.data %>% 
  select_if(is.numeric) %>% 
  colnames()

numeric.col.names <- raw.numerical.col.names[-c(1,2)]


# Shiny server
shinyServer(function(input, output) {
  output$playerPlot <- renderPlotly({

    # Filter the FIFA 2018 player data by overall
    filtered.data <-  filter(raw.data, Overall >= as.numeric(input$Overall))
    
    # Create Linear Regression 
    fit <- lm(filtered.data, formula = get(input$yaxis) ~ get(input$xaxis))
    
    output$summary <- renderText({
      return(paste0("Slope : ", round(fit$coefficients[[2]], 3)))
    })
    
    
    
    # Draw scatter plot
    plot_ly(data = filtered.data,
                 type = 'scatter',
                 mode = 'markers',
                 x = ~get(input$xaxis),
                 y = ~get(input$yaxis),
                 color = ~get(input$categorize),
                 text = ~filtered.data$full_name
            ) %>% 
      
      add_trace(data = filtered.data, x = ~get(input$xaxis), y = ~fitted(fit), mode = 'lines', color = NULL, name = "Linear Regression") %>% 
      
      layout(title = paste0(input$xaxis, " VS. ", input$yaxis),
             xaxis = list(title = input$xaxis),
             yaxis = list(title = input$yaxis)
      )
  })

})