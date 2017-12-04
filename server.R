library(shiny)
library(dplyr)

library(plotly)

# Read the csv file of FIFA 2018 soccer player dataset
raw.data <- read.csv("./Data/complete.csv", stringsAsFactors = FALSE, encoding = 'UTF-8')

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
    filtered.data <-  filter(raw.data, overall >= as.numeric(input$overall))
    
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
                 color = ~get(input$categorize)
            ) %>% 
      
      add_trace(data = filtered.data, x = ~get(input$xaxis), y = ~fitted(fit), mode = 'lines', color = NULL, name = "Linear Regression") %>% 
      
      layout(title = paste0(input$xaxis, " V.S ", input$yaxis),
             xaxis = list(title = input$xaxis),
             yaxis = list(title = input$yaxis)
      )
  })

})