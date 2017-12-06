library(shiny)  

source("server.R")

my.ui <- fluidPage(
  
  tabsetPanel(type = "tabs",
              tabPanel("Plot", fluid = TRUE,
                       sidebarPanel(
                         width = 2,
                         selectInput("Overall", "Select minimum overall rating of the players",
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
                       ),
                       mainPanel(
                         plotlyOutput("playerPlot"))
              ),
              tabPanel("Players", fluid = TRUE,
                       sidebarPanel(
                         width = 2,
                         selectizeInput("Player", "Select Player", choices = c(soccer.data$full_name), selected = NULL, multiple = FALSE,
                                        options = list(placeholder = 'Search for Player'))
                       ),
                       mainPanel(
                         htmlOutput("playerSummary")
                       ),
              tabPanel("Summary", textOutput("summary"))
              )
  )
)