library(shiny)  

source("server.R")
shinyUI(fluidPage(
  
  titlePanel("TITLE"),
  
  p("description"),

  mainPanel(
    
    plotlyOutput("playerPlot"),
    
    textOutput("summary")
    
  ),
  
  sidebarPanel(
    width = 2,
    selectInput("Overall", "Select minimum overall stat of the players",
                choices = list("90","80","70","60"),
                selected = "90"),
    
    selectInput("xaxis", "Select X-axis",
                choices = numeric.col.names,
                selected = "Age"),
    
    selectInput("yaxis", "Select Y-axis",
                choices = numeric.col.names,
                selected = "Wage(EUR)"),
    selectInput("categorize", "Categorize by",
                choices = c("League","Club"),
                selected = "League")
    
  )
))
