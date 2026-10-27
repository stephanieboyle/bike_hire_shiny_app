# Single entry point for local runs and Posit Connect Cloud.
# Shiny loads global.R before evaluating this file.
source("server.R", local = TRUE)
ui <- source("ui.R", local = TRUE)$value
shiny::shinyApp(ui = ui, server = server)
