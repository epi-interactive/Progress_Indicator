library(shiny)
source("global.R")

# Basic UI for app
ui <- tagList(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "nprogress.css"),
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css"),
    tags$script(src="nprogress.js"),
    tags$script(src=("main.js"))
    
  ),
  tags$body(
    fluidPage(
      titlePanel("Showing progress for complex tasks"),
      sidebarLayout(
        sidebarPanel(
          selectInput("sort", "Sort cars by:", c("Horsepower"="hp", "Miles per gallon"="mpg"), "Horsepower"),
          selectInput("gears", "Number of gears: ", unique(mtcars$gear), unique(mtcars$gear)[1])
      ),
      mainPanel(
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
      
  })
  
   # Output the table using the data above
   output$table <- renderTable(appData())
}


# Run the application 
shinyApp(ui = ui, server = server)

