library(shiny)

# Define server logic required to draw a histogram ----
server <- function(input, output) {

  # get the model and functions
  file.sources <- dir('R/')
  invisible(sapply(paste0('R/', file.sources), source))

  ##########################################################################################
  #  Output of shiny App for Panel 1 - Dynamic
  ##########################################################################################

  output$dynamic <- renderPlot(
  {
    # CC scenarios
    if(input$cc == 'RCP4.5') env1b = -0.882
    if(input$cc == 'RCP6') env1b = -0.7335
    if(input$cc == 'RCP8.5') env1b = -0.1772

    management <- c(input$Plantation, input$Harvest, input$Thinning, input$Enrichement)

    run_dynamic(ENV1a = -1.55, ENV1b = env1b, growth = input$growth, management = management, plotLimit = input$plotLimit)
  })

  ##########################################################################################
  #  Output of shiny App for Panel 2 - Summary
  ##########################################################################################

  output$summary <- renderPlot(
  {
    # CC scenarios
    if(input$cc2 == '0') env1b = -1.55
    if(input$cc2 == 'RCP4.5') env1b = -0.882
    if(input$cc2 == 'RCP6') env1b = -0.7335
    if(input$cc2 == 'RCP8.5') env1b = -0.1772

    # management practices
    managP <- rep(0, 4)
    for(i in 1:length(input$managPractices)) {
      if(input$managPractices[i] == 1) {
        managP[1] = 1
      }else if(input$managPractices[i] == 2) {
        managP[2] = 1
      }else if(input$managPractices[i] == 3) {
        managP[3] = 1
      }else if(input$managPractices[i] == 4) {
        managP[4] = 1
      }
    }

    if(input$ylimNull == FALSE) {
      ylimTRE = NULL; ylimEv = NULL
    }else {
      ylimTRE = input$ylimTRE; ylimEv = input$ylimEv
    }

    run_summary(env1b = env1b, growth = input$growth2, managPractices = managP, ylimTRE = ylimTRE, ylimEv = ylimEv)

  })

  output$error <- renderText(
  {
    if(is.null(input$managPractices)) warning('Please, select at least one management practice')
  })

  ##########################################################################################
  #  Output of shiny App for Panel 3 - Output correlation
  ##########################################################################################

  output$cor <- renderPlot(
  {
    # CC scenarios
    if(input$cc3 == '0') env1b = -1.55
    if(input$cc3 == 'RCP4.5') env1b = -0.882
    if(input$cc3 == 'RCP6') env1b = -0.7335
    if(input$cc3 == 'RCP8.5') env1b = -0.1772

    # management practices
    if(input$managPractices2 == 'Plantation') managP2 = c(1, 0, 0, 0)
    if(input$managPractices2 == 'Harvest') managP2 = c(0, 1, 0, 0)
    if(input$managPractices2 == 'Thinning') managP2 = c(0, 0, 1, 0)
    if(input$managPractices2 == 'Enrichement planting') managP2 = c(0, 0, 0, 1)

    plot_outputCor(env1b = env1b, growth = input$growth3, managPractices = managP2)

  })
}
