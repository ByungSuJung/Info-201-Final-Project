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
                         selectizeInput("Player", "Select Player", choices = soccer.data$full_name, selected = NULL, multiple = FALSE,
                                        options = NULL)
                       ),
                       mainPanel(
                         htmlOutput("playerSummary")
                       ),
                       tabPanel("Summary", textOutput("summary"))
              ),
              tabPanel("Leagues", fluid = TRUE,
                       sidebarPanel(
                         width = 2,
                         selectInput("League", "Select the league you want to view",
                                     choices = league.choices,
                                     selected = "English Premier League"),
                         
                         selectInput("league.xaxis", "Select X-axis",
                                     choices = teams.x.axis,
                                     selected = "Median Overall Rating"),
                         
                         selectInput("league.yaxis", "Select Y-axis",
                                     choices = teams.y.axis,
                                     selected = "Win Percentage")
                         ),
                       mainPanel(
                         plotlyOutput("leaguePlot")
                       )
               )
                       
  )
)