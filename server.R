library(shiny)
load('data/sysdata.rda')

# Define server logic required to draw a histogram ----
server <- function(input, output) {

  # get the model and functions
  file.sources <- dir('R/')
  file.sources <- file.sources[!file.sources %in% c('solve_Fig1.R', 'solve_Fig2.R')]
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
    if(RCP == 'RCP2.6') tempUn1 <- tempUn0 + 1
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
  #  Output of shiny App for Panel 2 - Figure 1
  ##########################################################################################

  output$fig1 <- renderPlot(
  {
    # CC scenarios
    if(input$cc2 == 'RCP2.6') RCP = '2.6'
    if(input$cc2 == 'RCP4.5') RCP = '4.5'
    if(input$cc2 == 'RCP6') RCP = '6.0'
    if(input$cc2 == 'RCP8.5') RCP = '8.5'
  

    # management intensity
    managInt <- input$managInt/100

    # if(input$ylimNull == FALSE) {
    #   ylim <- rep(list(NULL), 5)
    # }else {
    #   ylim = list(input$ylimDeltaState, input$ylimDeltaTime, input$ylimR_infinity, input$ylimR_init, input$ylimIntegral)
    # }

    run_fig1(fig1List, RCP, managInt, input$range_yLim)

  })

  ##########################################################################################
  #  Output of shiny App for Panel 3 - Figure 2
  ##########################################################################################

  output$fig2 <- renderPlot(
  {
    # CC scenarios
    if(input$cc3 == 'RCP2.6') RCP = '2.6'
    if(input$cc3 == 'RCP4.5') RCP = '4.5'
    if(input$cc3 == 'RCP6') RCP = '6.0'
    if(input$cc3 == 'RCP8.5') RCP = '8.5'

    # management intensity
    envir1a <- input$envir1a

    run_fig2(fig1List, fig2List, RCP, envir1a, input$range_yLim2)

  })
}
