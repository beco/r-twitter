library(twitteR)
source('init.R')

shinyServer(function(input, output) {

  setup_twitter_oauth(twitter_oauth, twitter_secret)

  user <- 'beco'

  observe({
    output$status <- renderText({"loading… connecting to twitter"})
    if(user != input$screen_name) {
      user <- input$screen_name
      otweets <- userTimeline(user, 200, NULL, NULL, TRUE)
    }
    output$active_user <- renderText(user)
    output$status <- renderText({"done!"})

    #tweets <- otweets[1:input$num]
    tweets <- otweets
    dates  <- sapply(tweets, function(x) format(as.POSIXct(x$created, origin="1970-01-01"), "%m/%d"))
    hours  <- sapply(tweets, function(x) format(as.POSIXct(x$created, origin="1970-01-01"), "%H"))
    locs <- sapply(tweets, function(x){
      if(!identical(x$latitude, character(0))){
        c(x$latitude, x$longitude, x$text)
      }
    })
    locs <- Filter(Negate(is.null), locs)
    locsdf <- data.frame(t(matrix(unlist(locs), byrow=T)))
    colnames(locsdf) <- c("lat", "long", "text")

    print(table(hours))

    output$plot_day <- renderPlot({
     plot(table(dates), xlab="mes/dia", ylab="tweets", main ="tweets por día")
    })

    output$plot_hour <- renderPlot({
      plot(table(hours), xlab="hora del día", ylab="tweets", main="tweets por hora del día")
    })

    # leaflet(data = locsdf) %>% addTiles() %>% setView(lng = -99.20303, lat = 19.4259, zoom = 18) %>%
    #  addMarkers(~long, ~lat, popup = ~as.character(text))

    output$map <- renderLeaflet({
      leaflet(data = locsdf) %>%
        addTiles(
          urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
          attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      ) %>%
      setView(lng = -99.20303, lat = 19.4259, zoom = 18) %>%
      addMarkers(~long, ~lat, popup = ~as.character(text))
  })
  })
})
