library(shiny)
library(dplyr)
library(rsconnect)
library(plotly)

# Read the csv file of FIFA 2018 soccer player dataset
raw.data <- read.csv("./Data/complete.csv", stringsAsFactors = FALSE)

data <- raw.data %>% 
  filter(overall >= 70)
# Filter the FIFA 2018 player data by overall
data.filter <- function(my_overall) {
  filter(raw.data, overall >= my_overall)
}

shinyServer(function(input, output) {
  ouput$playerPlot <- renderPlotly({
    
    filtered.data <- data.filter(input$overall)
    
    plot_ly(data = filtered.data,
            type = 'scatter',
            x =
            )
      
      
  })
})