library(leaflet)

shinyUI(pageWithSidebar(
  titlePanel("twitter stuff"),
  sidebarPanel(
    wellPanel(
      textInput("screen_name","Username:", "", NULL, "@pictoline"),
      sliderInput("num", "Number of tweets:", 10, 200, 200, 10)
    ),
    wellPanel(
      "cuenta analizada:",
      strong(textOutput("active_user")),
      hr(),
      strong(textOutput("status"))
    )
  ),
  mainPanel(
    tabsetPanel(
      tabPanel("métricas",
        plotOutput("plot_day", "700px"),
        plotOutput("plot_hour", "700px"),
        plotOutput("plot_weekday", "500px")
      ),
      tabPanel("mapa",
        leafletOutput("map", "700px", "500px")
      )
    )
  )
))
