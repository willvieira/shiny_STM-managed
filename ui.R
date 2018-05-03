library(shiny)

# Define UI for app that draws a histogram ----
ui <- fluidPage(

  # App title ----
  titlePanel("Effect of forest management in the migration rate of the eastern North American forest - v0.1"),

  # Sidebar layout with input and output definitions ----
  sidebarLayout(

    # Sidebar panel for inputs ----
    sidebarPanel(width = 3,

      HTML("<font size='4'><b>Climate change scenarios<br></b></font><br>"),
        # Input: Selector for choosing dataset ----
        radioButtons(inputId = "cc",
                    label = "Select the RCP:",
                    choices = c("RCP4.5", "RCP6", "RCP8.5")),

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

      HTML("<font size='4'><b>Xlim of plot<br></b></font><br>"),
        # Input: Selector for choosing dataset ----
        sliderInput(inputId = "plotLimit",
                    label = "Choose a limit",
                    min = 50,
                    max = 500,
                    value = 200)
    ),

    # Main panel for displaying outputs ----
    mainPanel(

      # Output: Histogram ----
      plotOutput(outputId = "distPlot")

    )
  )
)
