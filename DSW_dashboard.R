
# Albert Cheruiyot
# Water Purification Dahsboard 


library(shiny)
library(shinydashboard)
library(ggplot2)
library(DT)
library(rsconnect)


ui<- dashboardPage(skin = "green",
  dashboardHeader( title = "Chlorined Water" ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Graphs", tabName = "irish",icon = icon("bar-chart-o")),
      menuItem("Data", tabName = "water",icon = icon("table"))
    )
  ),
  dashboardBody(
    
    tabItems(
      tabItem("irish",
              fluidRow(
              box(plotOutput("Bar_plot"), width = 8),
              box(
                selectInput("features","Features:",
                            c("attended_dispenser_meeting","respondent_schooling",
                              "house_walls","country" )),width = 4)),
              fluidRow(
              
                box(plotOutput("pie_plot"), width = 8), 
                    box(
                  selectInput("features","Features:",
                              c("attended_dispenser_meeting","respondent_schooling",
                                "house_walls","country" )),width = 4
              )
      )),
      tabItem("water",
              fluidPage(
                h1("Household data"),
                dataTableOutput("dtable")
                
              )
      )
    )
  )
)


server<-function(input, output){
  output$Bar_plot<-renderPlot({
    data_sub %>% 
      ggplot(aes(x=data_sub[[input$features]] ,fill=data_sub[[input$features]]) , na.rm=TRUE)+
      geom_bar()+
      theme(axis.title.x = element_blank(),
            axis.text.x = element_blank(),
            axis.ticks = element_blank())+
      scale_fill_discrete(name="Features")
      
  })
  
  output$pie_plot<-renderPlot({
    data_sub_2 %>% 
      ggplot(aes(x="", y=prop ,fill=respondent_schooling) )+
      geom_bar(stat = "identity",width = 1)+coord_polar("y", start = 0)+
      theme_void()

  })
  output$dtable<-renderDataTable(data_sub)
}



shinyApp(ui, server)

