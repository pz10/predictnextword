sidebar <- dashboardSidebar(
        sidebarMenu(
                textInput(inputId = "text", label = "Text input:", placeholder ="write your text here"),
                
                actionButton(inputId = "predict", label = "predict me!", width = "70%", icon = icon("refresh", "fa-1x"),
                             style = "position: relative; left: 30px; background-color:#959595; color:white"),
                # puzzle-piece
                
                
                # checkboxInput(inputId ="multiple", label = "show all alternative predictions?", value = F),
                checkboxInput(inputId ="stopwords", label = "remove stopwords", value = T),
                
                helpText(   a("     stopwords info", href="http://jmlr.csail.mit.edu/papers/volume5/lewis04a/a11-smart-stop-list/english.stop",
                              target="_blank",
                              class="fa fa-info",
                              style = "position: relative; left: 30px")),

                
                
                h4(   a(".",
                     style = "position: relative; left: -10px")),
                
                h4(   a("about this App", href="https://github.com/pz10/predictnextword",
                        target="_blank",
                        style = "position: relative; left: 10px; color:white")
                )
                
                # sliderInput(inputId = "slider", label = "number of alternatives", min = 1, max = 10, value = 5),
                # menuItem("Next word prediction", tabName = "NextWord", icon = icon("puzzle-piece")),
                # 
                # menuItem("about", icon = icon("info"), tabName = "about")
                # 

                
                
        )
)

body <- dashboardBody(
        # h2("my text"),
        box(width = NULL, textOutput("text")),
        
        h2("next word prediction"),
        box(width = NULL, textOutput("bestprediction")),
        
        h2("alternative prediction(s)"),
        box(width = NULL, dataTableOutput("prediction"))

            
        # tabItems(
        #         tabItem(tabName = "NextWord",
        #                 # h2("my text"),
        #                 box(width = NULL, textOutput("text")),
        #                 
        #                 h2("prediction"),
        #                 box(width = NULL, dataTableOutput("prediction"))
        #                 
        #         ),
        #         
        #         tabItem(tabName = "about",
        #                 h2("about")
        #         )
        # )
)
ui <- dashboardPage(
        dashboardHeader(title = "Next word prediction", disable = FALSE),
        # dropdownMenu(type = "messages",
        #              messageItem(
        #                      from = "Sales Dept",
        #                      message = "Sales are steady this month."
        #              ),
        #              messageItem(
        #                      from = "New User",
        #                      message = "How do I register?",
        #                      icon = icon("question"),
        #                      time = "13:45"
        #              ),
        #              messageItem(
        #                      from = "Support",
        #                      message = "The new server is ready.",
        #                      icon = icon("life-ring"),
        #                      time = "2014-12-01"
        #              )
        # ),
        
        sidebar,
        body
)