library(shiny)  

source("server.R")

my.ui <- fluidPage(
  
  tabsetPanel(type = "tabs",
              tabPanel("Plot", fluid = TRUE,
                       sidebarPanel(
                         width = 4,
                         sliderInput("Overall", label = h3("Overall"), min = 0, 
                                     max = 100, value = 90),

                         
                         selectInput("xaxis", label = h3("Select X-axis"),
                                     choices = numeric.col.names,
                                     selected = "Age"),
                         
                         selectInput("yaxis", h3("Select Y-axis"),
                                     choices = numeric.col.names,
                                     selected = "Wage(EUR)"),
                         
                         selectInput("categorize", h3("Categorize by"),
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
                       )
                       
              ),
              tabPanel("Summary", textOutput("summary"))
  )
)