ui <- navbarPage(title = "test",
                 tabPanel("Scot Demo"))

server <- function(input, output, session) {
}

shinyApp(ui = ui, server = server)