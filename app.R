##################################
# Created by EPI-interactive
# 29 Apr 2019
# https://www.epi-interactive.com
##################################

library(shiny)

#Skeleton 
createTableSkeleton <- function() {
  div(class="skeleton",
      div(class="sk-layout sk-layout-column",
          div(class="sk-text-row skeleton-item"),
          div(class="sk-text-row skeleton-item"),
          div(class="sk-text-row skeleton-item"),
          div(class="sk-text-row skeleton-item"),
          div(class="sk-text-row skeleton-item"),
          div(class="sk-text-row skeleton-item"),
          div(class="sk-text-row skeleton-item"),
          div(class="sk-text-row skeleton-item")
      )    
  )
}

# Basic UI for app
ui <- tagList(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "css/nprogress.css"),
    tags$link(rel = "stylesheet", type = "text/css", href = "css/styles.css"),
    tags$script(src="js/nprogress.js"),
    tags$script(src=("js/main.js"))
    
  ),
  tags$body(
    fluidPage(
      div(class="title", h1("Loading and progress")),
      div(class="app-body",
        div(class="sidebar",
            div(
              selectInput("sort", "Sort cars by:", c("Horsepower"="hp", "Miles per gallon"="mpg"), "Horsepower"),
              selectInput("gears", "Number of gears: ", unique(mtcars$gear), unique(mtcars$gear)[1])
            ),
            tags$img(src="images/Epi_Logo.png", width= "90%")
      ),
      div(class="main",
         tableOutput("table"),
         createTableSkeleton()
      )
      )
    )
  )
)

# Server for app
server <- function(input, output) {
  # Simple data for the table - just takes in 
  appData <- reactive({
    req(input$sort, input$gears)
    # Wait three seconds to simulate complex calculations
    Sys.sleep(3)
    # Only select cars data with selected gear number
    withGear <- mtcars[mtcars$gear == input$gears, ]
    # Sort by chosen sort type
    sorted <- withGear[order(withGear[[input$sort]]), ]
    
    #Cleaning up data for table display
    sorted$cyl <- as.integer(sorted$cyl)
    sorted$hp <- as.integer(sorted$hp)
    sorted$gear <- as.integer(sorted$gear)
    sorted$carb <- as.integer(sorted$carb)
    sorted$vs <- ifelse(sorted$vs == 0,"V-shaped", "Straight")
    sorted$am <- ifelse(sorted$am == 0,"Automatic", "Manual")
    names(sorted) <- c("Miles/(US) gallon", "Number of cylinders", "Displacement (cu.in.)", "Gross horsepower", "Rear axle ratio", "Weight (1000 lbs)", "1/4 mile time", "Engine", "Transmission", "Number of forward gears", "Number of carburetors")
    
    return(sorted)  
  })
  
   # Output the table using the data above
   output$table <- renderTable(appData())
}


# Run the application 
shinyApp(ui = ui, server = server)

