library(shiny)
library(plyr)
library(dplyr)

library(plotly)
source("analysis.R")

# Name of positions
positions <- select(soccer.data, contains("prefers_")) %>%
  colnames()

# Column names with numerical data in raw.data
raw.numerical.col.names <- soccer.data %>%
  select_if(is.numeric) %>%
  colnames()

numeric.col.names <- raw.numerical.col.names[-c(1,2,8,14)]
soccer.data [is.na(soccer.data) == TRUE] <- 0 

# Shiny server
shinyServer(function(input, output) {
  output$playerPlot <- renderPlotly({

    # Filter the FIFA 2018 player data by overall
    filtered.data <-  filter(soccer.data, Overall >= as.numeric(input$Overall))

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
 
  
  output$player_selected_var <- renderUI({ 
    HTML(paste("","Due to the large number of variables in our data, we'll only mention some of the notable trends:",
    "Potential vs Wage shows people up-and-coming players that can succeed with the right training.",
    "Sprint speed vs Wage/Value. If you run faster, you get paid more.",
    "International Reputation vs Wage shows that international fame is tied to how much a player is paid.",
    "Age vs. Potential shows that soccer is more of a younger man's sport.",
    "Strength and Weight shows users the strongest, heaviest players like Adebayo Akinfenwa that perform decently in soccer.",
    "Strength and Height shows users that there are very tall people who may not be as strong as one would expect.", sep = "<br/>"
    ))
  })
  
  output$playerSummary <- renderText({
    if (input$Player == "") {
      '<h1> Pick a player to see detailed info </h1>'
    } else {
      c('<h1>', input$Player, '</h1>',
        '<p>',
        '<img src="', soccer.data[soccer.data$full_name == input$Player, ]$photo, '">', '<br>',
        '<img src="', soccer.data[soccer.data$full_name == input$Player, ]$club_logo, '">', soccer.data[soccer.data$full_name == input$Player, ]$Club, '<br>',
        soccer.data[soccer.data$full_name == input$Player, ]$Age, 'years old', '<br>',
        'Overall rating: ', soccer.data[soccer.data$full_name == input$Player, ]$Overall, '<br>',
        'Height (cm): ', soccer.data[soccer.data$full_name == input$Player, ][[10]], '<br>',
        'Weight (kg): ', soccer.data[soccer.data$full_name == input$Player, ][[11]], '<br>',
        'Wage (EUR): ', soccer.data[soccer.data$full_name == input$Player, ][[17]], '<br>',
        'Preferred foot: ', soccer.data[soccer.data$full_name == input$Player, ]$preferred_foot, '<br>', 
        '</p>')
    }
  })
  
  output$leaguePlot <- renderPlotly({
    
    # Filter the FIFA 2018 team data by league
    if(input$League == "All"){
      league.filtered.data <- all.leagues
    } else {
      league.filtered.data <-  filter(all.leagues, League == input$League)
    }
    # Create Linear Regression
    league.fit <- lm(league.filtered.data, formula = get(input$league.yaxis) ~ get(input$league.xaxis))
    
    output$league.summary <- renderText({
      return(paste0("Slope : ", round(league.fit$coefficients[[2]], 3)))
    })
    
    # Draw scatter plot
    plot_ly(data = league.filtered.data,
            type = 'scatter',
            mode = 'markers',
            x = ~get(input$league.xaxis),
            y = ~get(input$league.yaxis),
            color = ~league.filtered.data$Clubs,
            text = ~league.filtered.data$Clubs
            ) %>% 
      
      add_trace(data = league.filtered.data, x = ~get(input$league.xaxis), y = ~fitted(league.fit), mode = 'lines', color = NULL, name = "Linear Regression") %>% 
      
      layout(title = paste0(input$league.xaxis, " VS. ", input$league.yaxis),
             xaxis = list(title = input$league.xaxis),
             yaxis = list(title = input$league.yaxis)
      )
  })
  
  output$league_selected_var <- renderUI({
    HTML(paste("","Win Percentages", "",
               "In the English Premier League, many statistics have a positive relationship with a team's win rate. For example, the median overall rating of a team has a positive correlation with the win rate of the team. The team's potential, physical, agility, stamina and composure ratings also had positive relationships with how often a team wins. The only statistic that does not share this relationship in the English Premier League is the median aggression rating of a team. 
               Teams with higher median aggression ratings had lower win percentages. This pattern continues for all the other leagues to varying degrees and with a few notable outliers. Some notable outliers are Agility vs. Win Percentage for the US and the Physical/Aggression Ratings vs. Win Percentages for many soccer leagues. For the first case, a possible explanation is that younger players are faster but less experienced which may lead to more mistakes veterans wouldn't make. For the latter cases, this could relate to the culture around of the league. 
               Some leagues may favor more physical and aggressive players for their teams.","",
               "Loss Percentages", "",
               "Simply put, the relationships in for this are reversed compared to the Win Percentages (positive relationships become negative and vice versa).", "",
               "Goals For", "",
               "When looking at how many goals teams scored, the leagues vary more. For example, there is no correlation between potential and goals scored for a team in the US but there is a negative correlation between the agility rating and goals scored. In other leagues like Italy's Serie A, all statistics have positive correlations. Meanwhile leagues like the Mexican Liga MX and French Ligue 1 have negative relationships with physical ratings and aggression ratings respectively.", "",
               "Goals Against", "",
               "These relationships are reversed compared to the Goals For.", "",
               "Points for Standings", "",
               "The relationships for this are similar to those of the Win Percentages. However, this statistic includes draws. In soccer, points are given for wins and draws. Though draws occur more often in soccer, most games still do not end in draws and only affect statistics slightly.",
               sep = "<br/>"
               ))
  })
})
