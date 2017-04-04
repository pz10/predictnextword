server <- function(input, output) {
        output$text <- renderText(input$text)
        
        data <- reactive({
                input$predict
                isolate({
                        string <- input$text
                        output <- get.ranks(string)
                        if(input$stopwords==T){
                                output <- output[prediction %!in% myStopWords$stopWords]
                        }
                        
                        output <- output[,.(rank = 1:.N, prediction= prediction)]
                        # 
                        # if(input$multiple==F){
                        #         output <- output[1:5]
                        # }
                        
                        if(nrow(output)>0){
                                return(output) 
                        }else{
                                output <- data.table(rank = 1:2, prediction= c("the", "man"))
                                return(output)
                        }
                        
                })
        })

        output$prediction <-
                renderDataTable({
                        if (input$predict != 0)
                                data()
                }, options = list(
                        columnDefs = list(className = 'dt-center', targets = 5),
                        pageLength = 5,
                        lengthMenu = c(5, 10, 25, 100)
                ))

        # 
        # output$prediction <-
        #         renderDataTable({
        #                 data()
        #         }, options = list(
        #                 columnDefs = list(className = 'dt-center', targets = 5),
        #                 pageLength = 5,
        #                 lengthMenu = c(5, 10, 25, 100)
        #         ))
        
                
        
        output$bestprediction <- 
                renderText({
                        if (input$predict != 0)
                                data()$prediction[1]
                })
        
}