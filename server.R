library(shiny)
load('data/sysdata.rda')

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
    # Unscale and add climate change
    tempUn0 <- input$latitude

    # add climate change
    RCP <- input$cc
    if(RCP == 'RCP4.5') tempUn1 <- tempUn0 + 1.8
    if(RCP == 'RCP6') tempUn1 <- tempUn0 + 2.2
    if(RCP == 'RCP8.5') tempUn1 <- tempUn0 + 3.7

    # scale warming temperature
    env1b <- unname((tempUn1 - vars.means['annual_mean_temp'])/vars.sd['annual_mean_temp'])
    env1a <- unname((tempUn0 - vars.means['annual_mean_temp'])/vars.sd['annual_mean_temp'])

    management <- c(input$Plantation, input$Harvest, input$Thinning, input$Enrichement)/100

    run_dynamic(ENV1a = env1a, ENV1b = env1b, growth = input$growth, management = management, plotLimit = input$plotLimit)
  })

  ##########################################################################################
  #  Output of shiny App for Panel 2 - Summary
  ##########################################################################################

  output$summary <- renderPlot(
  {
    # latitudinal position
    if(input$latitude2 == 'Boreal') env1a = -1.55
    if(input$latitude2 == 'Mixed') env1a = -.5

    # CC scenarios
    if(env1a == -1.55) {
      if(input$cc2 == '0') env1b = -1.55
      if(input$cc2 == 'RCP4.5') env1b = -0.882
      if(input$cc2 == 'RCP6') env1b = -0.7335
      if(input$cc2 == 'RCP8.5') env1b = -0.1772
    }else{
      if(input$cc2 == '0') env1b = -.5
      if(input$cc2 == 'RCP4.5') env1b = 0.168
      if(input$cc2 == 'RCP6') env1b = 0.316
      if(input$cc2 == 'RCP8.5') env1b = 0.873
    }

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
      ylim <- rep(list(NULL), 5)
    }else {
      ylim = list(input$ylimDeltaState, input$ylimDeltaTime, input$ylimR_infinity, input$ylimR_init, input$ylimIntegral)
    }

    run_summary(env1a = env1a, env1b = env1b, growth = input$growth2, managPractices = managP, ylim = ylim)

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
    # latitudinal position
    if(input$latitude3 == 'Boreal') env1a = -1.55
    if(input$latitude3 == 'Mixed') env1a = -.5

    # CC scenarios
    if(env1a == -1.55) {
      if(input$cc3 == '0') env1b = -1.55
      if(input$cc3 == 'RCP4.5') env1b = -0.882
      if(input$cc3 == 'RCP6') env1b = -0.7335
      if(input$cc3 == 'RCP8.5') env1b = -0.1772
    }else{
      if(input$cc3 == '0') env1b = -.5
      if(input$cc3 == 'RCP4.5') env1b = 0.168
      if(input$cc3 == 'RCP6') env1b = 0.316
      if(input$cc3 == 'RCP8.5') env1b = 0.873
    }

    # management practices
    if(input$managPractices2 == 'Plantation') managP2 = c(1, 0, 0, 0)
    if(input$managPractices2 == 'Harvest') managP2 = c(0, 1, 0, 0)
    if(input$managPractices2 == 'Thinning') managP2 = c(0, 0, 1, 0)
    if(input$managPractices2 == 'Enrichement planting') managP2 = c(0, 0, 0, 1)

    plot_outputCor(env1a = env1a, env1b = env1b, growth = input$growth3, managPractices = managP2)

  })
}
