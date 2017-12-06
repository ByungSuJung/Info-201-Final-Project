library(shiny)  

source("server.R")

my.ui <- navbarPage(
  
    titlePanel("TITLE"),
    
    
    tabPanel("Players",
      mainPanel(
        p("Use this plot to measure two variables of your choosing from the FIFA 18 player database"),
        plotlyOutput("playerPlot"),
        
        textOutput("summary")
        
      ),
    
      sidebarPanel(
        width = 2,
        selectInput("Overall", "Select minimum overall rating of the players",
                    choices = list("90","80","70"),
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
    )
)
