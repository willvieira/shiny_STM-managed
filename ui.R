library(shiny)

# Define UI for app that draws a histogram ----
ui <- fluidPage(theme = shinythemes::shinytheme("cosmo"),

navbarPage("ShinyApp for the STManaged model",

  ##########################################################################################
  #  Panel 1 - Dynamic
  ##########################################################################################

  tabPanel("Dynamic",

  # App title ----
  titlePanel("Effect of Forest Management on Transient Dynamics After Climate Change"),

    # Sidebar layout with input and output definitions ----
      sidebarLayout(

        # Sidebar panel for inputs ----
        sidebarPanel(width = 3,

          HTML("<font size='4'><b>Climate change scenarios<br></b></font><br>"),
            # Input: Selector for choosing dataset ----
            sliderInput(inputId = "latitude",
                        label = "Select the latitudinal position (mean annual temperature):",
                        min = -2.6,
                        max = 5,
                        value = 0.08,
                        post = '°C'),

            radioButtons(inputId = "cc",
                        label = "Select the RCP:",
                        choices = c("RCP2.6","RCP4.5", "RCP6", "RCP8.5"),
                        inline = T,
                        selected = "RCP4.5"),

            radioButtons(inputId = "growth",
                        label = "Select the growth patern of climate change:",
                        choices = c("stepwise", "linear", "exponential"), inline = T),

          HTML("<font size='4'><b>Intensity of management practices<br></b></font><br>"),

            # Input: Slider for the management Intensity ----
            sliderInput(inputId = "Plantation",
                        label = "Plantation intensity",
                        min = 0,
                        max = 100,
                        step = 0.5,
                        value = 0,
                        post = '%'),
            sliderInput(inputId = "Enrichement",
                        label = "Enrichement planting intensity",
                        min = 0,
                        max = 100,
                        step = 0.5,
                        value = 0,
                        post = '%'),
            sliderInput(inputId = "Harvest",
                        label = "Harvest intensity",
                        min = 0,
                        max = 100,
                        step = 0.5,
                        value = 0,
                        post = '%'),
            sliderInput(inputId = "Thinning",
                        label = "Thinning intensity",
                        min = 0,
                        max = 100,
                        step = 0.5,
                        value = 0,
                        post = '%'),

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

          div(img(src='model_pr.png', height = 350), style="text-align: center;")
        )
      )
    ),

    ##########################################################################################
    #  Panel 2 - Fig1
    ##########################################################################################

    tabPanel("Figure 1",

      titlePanel("Effect of Forest Management on Transient Dynamics After Climate Change"),

      # Sidebar layout with input and output definitions ----
      sidebarLayout(

        # Sidebar panel for inputs ----
        sidebarPanel(width = 3,

          HTML("<font size='4'><b>Climate change scenarios<br></b></font><br>"),
            radioButtons(inputId = "cc2",
                        label = "Select the RCP:",
                        choices = c("RCP2.6", "RCP4.5", "RCP6", "RCP8.5"), inline = T,
                        selected = "RCP4.5"),

          HTML("<font size='4'><b>Management intensity<br></b></font><br>"),

            sliderInput(inputId = "managInt",
                        label = "Management intensity",
                        min = 0.1,
                        max = 99.7,
                        step = 0.4,
                        value = 0.5,
                        post = '%'),

           HTML("<br><font size='4'><b>Range of y axis<br></b></font>"),

            radioButtons(inputId = "range_yLim",
                         label = "",
                         choices = c("Fixed", "Dynamic"), inline = T,
                         selected = "Fixed")
        ),

        # Main panel for displaying outputs ----
        mainPanel(
          plotOutput(outputId = "fig1", height = 825, width = '115%')
        )
      )
    ),

    ##########################################################################################
    #  Panel 3 - Output correlation
    ##########################################################################################

    tabPanel("Figure 2",

      titlePanel("Effect of Forest Management on Transient Dynamics After Climate Change"),

      # Sidebar layout with input and output definitions ----
      sidebarLayout(

        # Sidebar panel for inputs ----
        sidebarPanel(width = 3,

          HTML("<font size='4'><b>Climate change scenarios<br></b></font>"),
            radioButtons(inputId = "cc3",
                        label = "Select the RCP:",
                        choices = c("RCP2.6", "RCP4.5", "RCP6", "RCP8.5"), inline = T,
                        selected = "RCP4.5"),

          HTML("<br><font size='4'><b>Latitudinal position</b></font>"),

            sliderInput(inputId = "envir1a",
                        label = "Select the mean annual temperature:",
                        min = -2.6,
                        max = 5,
                        step = 0.1,
                        value = -1,
                        post = '°C'),

           HTML("<br><font size='4'><b>Range of y axis</b></font>"),

            radioButtons(inputId = "range_yLim2",
                         label = "",
                         choices = c("Fixed", "Dynamic"), inline = T,
                         selected = "Fixed")
          ),

        # Main panel for displaying outputs ----
        mainPanel(
          plotOutput(outputId = "fig3", height = 825, width = '115%')
        )
      )
    )
  )
)
