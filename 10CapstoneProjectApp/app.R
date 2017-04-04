require(shiny)
require(shinythemes)
require(shinydashboard)

# source("preprocess.R")
source("preprocess_fullReadInFiles.R")

source("ui_1.R")
source("server_1.R")
shinyApp(ui = ui, server = server)