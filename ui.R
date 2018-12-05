library(shiny)

# Define UI for app that draws a histogram ----
ui <- fluidPage(theme = shinythemes::shinytheme("sandstone"),

navbarPage("STM managed - v2.1",

  ##########################################################################################
  #  Panel 1 - Dynamic
  ##########################################################################################

  tabPanel("Dynamic",

  # App title ----
  titlePanel("Effect of forest management in the migration rate of the eastern North American forest"),

    # Sidebar layout with input and output definitions ----
      sidebarLayout(

        # Sidebar panel for inputs ----
        sidebarPanel(width = 3,

          HTML("<font size='4'><b>Climate change scenarios<br></b></font><br>"),
            # Input: Selector for choosing dataset ----
            radioButtons(inputId = "latitude",
                        label = "Select the latitudinal position:",
                        choices = c("Boreal", "Mixed"), inline = T),

            radioButtons(inputId = "cc",
                        label = "Select the RCP:",
                        choices = c("RCP4.5", "RCP6", "RCP8.5"), inline = T),

            radioButtons(inputId = "growth",
                        label = "Select the growth patern of climate change:",
                        choices = c("stepwise", "linear", "exponential"), inline = T),

          HTML("<font size='4'><b>Intensity of management practices<br></b></font><br>"),

            # Input: Slider for the management Intensity ----
            sliderInput(inputId = "Plantation",
                        label = "Plantation intensity",
                        min = 0,
                        max = 1,
                        value = 0),
            sliderInput(inputId = "Harvest",
                        label = "Harvest intensity",
                        min = 0,
                        max = 1,
                        value = 0),
            sliderInput(inputId = "Thinning",
                        label = "Thinning intensity",
                        min = 0,
                        max = 1,
                        value = 0),
            sliderInput(inputId = "Enrichement",
                        label = "Enrichement planting intensity",
                        min = 0,
                        max = 1,
                        value = 0),

          HTML("<font size='4'><b>Limit of x axis<br></b></font><br>"),
            # Input: Selector for choosing dataset ----
            sliderInput(inputId = "plotLimit",
                        label = "Choose a limit",
                        min = 50,
                        max = 500,
                        value = 200)
        ),

        # Main panel for displaying outputs ----
        mainPanel(

          # Output
          plotOutput(outputId = "dynamic", height = 430),
          #plotOutput(outputId = "test")

          div(img(src='model_pr.png', height = 350), style="text-align: center;")
        )
      )
    ),

    ##########################################################################################
    #  Panel 2 - Summary
    ##########################################################################################

    tabPanel("Summary",

      titlePanel("Effect of forest management in the migration rate of the eastern North American forest"),

      # Sidebar layout with input and output definitions ----
      sidebarLayout(

        # Sidebar panel for inputs ----
        sidebarPanel(width = 3,

          HTML("<font size='4'><b>Climate change scenarios<br></b></font><br>"),
            # Input: Selector for choosing dataset ----
            radioButtons(inputId = "latitude2",
                        label = "Select the latitudinal position:",
                        choices = c("Boreal", "Mixed"), inline = T),

            radioButtons(inputId = "cc2",
                        label = "Select the RCP:",
                        choices = c("0", "RCP4.5", "RCP6", "RCP8.5"), inline = T,
                        selected = "RCP4.5"),

            radioButtons(inputId = "growth2",
                        label = "Select the growth patern of climate change:",
                        choices = c("stepwise", "linear", "exponential"), inline = T),

          HTML("<font size='4'><b>Management practices<br></b></font><br>"),

            # Input: checkbox with management practices ----
            checkboxGroupInput("managPractices", "Select at least one management practice:",
                               c("Plantation" = 1,
                                 "Harvest" = 2,
                                 "Thinning" = 3,
                                 "Enrichement" = 4), inline = T),

           HTML("<font size='4'><b>Fixed limit of y axis<br></b></font><br>"),

             checkboxInput("ylimNull", "Manual change of Y axis", FALSE),

             sliderInput(inputId = "ylimDeltaState",
                         withMathJax(label = "$$\\Delta state$$"),
                         min = 0,
                         max = 2,
                         step = 0.01,
                         value = c(1, 1.3)),

             sliderInput(inputId = "ylimDeltaTime",
                         withMathJax(label = "$$\\Delta time$$"),
                         min = 0,
                         max = 300,
                         value = c(30, 280)),

             sliderInput(inputId = "ylimR_infinity",
                         withMathJax(label = "$$-R_{\\infty}$$"),
                         min = -0.6,
                         max = 0,
                         step = 0.01,
                         value = c(-0.5, -0.05)),

             sliderInput(inputId = "ylimR_init",
                         withMathJax(label = "$$-R_{0}$$"),
                         min = -0.3,
                         max = 0.5,
                         step = 0.01,
                         value = c(-0.2, 0.4)),

             sliderInput(inputId = "ylimIntegral",
                         withMathJax(label = "$$\\int S(t)dt$$"),
                         min = 0,
                         max = 180,
                         value = c(5, 165))
        ),

        # Main panel for displaying outputs ----
        mainPanel(
          h3(textOutput(outputId = "error")),
          plotOutput(outputId = "summary", height = 650)
        )
      )
    ),

    ##########################################################################################
    #  Panel 3 - Output correlation
    ##########################################################################################

    tabPanel("Output correlation",

      titlePanel("Effect of forest management in the migration rate of the eastern North American forest"),

      # Sidebar layout with input and output definitions ----
      sidebarLayout(

        # Sidebar panel for inputs ----
        sidebarPanel(width = 3,

          HTML("<font size='4'><b>Climate change scenarios<br></b></font><br>"),
            # Input: Selector for choosing dataset ----
            radioButtons(inputId = "latitude3",
                        label = "Select the latitudinal position:",
                        choices = c("Boreal", "Mixed"), inline = T),

            radioButtons(inputId = "cc3",
                        label = "Select the RCP:",
                        choices = c("0", "RCP4.5", "RCP6", "RCP8.5"),
                        selected = "RCP4.5"),

            radioButtons(inputId = "growth3",
                        label = "Select the growth patern of climate change:",
                        choices = c("stepwise", "linear", "exponential"), inline = T),

          HTML("<font size='4'><b>Management practices<br></b></font><br>"),

            # Input: checkbox with management practices ----
            radioButtons("managPractices2", "Select at least one management practice:",
                         choices = c('Plantation', 'Harvest', 'Thinning', 'Enrichement planting'),
                         selected = 'Plantation')

          ),

        # Main panel for displaying outputs ----
        mainPanel(
          plotOutput(outputId = "cor", height = 1800)
        )
      )
    )
  )
)
