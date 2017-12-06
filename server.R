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
 
  output$click <- renderPrint({
    d <- event_data ("plotly_click")
    if (is.null(d)) "Click on the graph to display a photo of a player" else d
  })
  
  output$playerSummary <- renderText({
    c('<h1>', input$Player, '</h1>',
      '<p>',
      '<img src="', soccer.data[soccer.data$full_name == input$Player, ]$photo, '">', '<br>',
      
      '</p>')
  })
  
  output$leaguePlot <- renderPlotly({
    # Filter the FIFA 2018 team data by league
    league.filtered.data <-  filter(all.leagues, League == input$League)
    
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
})
