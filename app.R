# Shiny app example

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
        selectInput(inputId = "cc",
                    label = "Choose a scenario:",
                    choices = c("RCP2.6", "RCP4.5", "RCP6", "RCP8.5")),

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


# Define server logic required to draw a histogram ----
server <- function(input, output) {

  # get the model versions
  source("vissault_model_v3.R")
  source("vissault_model_fm.R")
  # parameters
  params = read.table("pars.txt", row.names = 1)


  solveEq <- function(func = model_fm, # = model
                      init, # = T0 ou y
                      ENV1, # temperature
                      plantInt = 0, # Intensity of plantation (in % [0-1])
                      harvInt = 0, # Intensity of harvest (increasing the parameter in % [0-1])
                      thinInt = 0, # Intensity of thinning (increasing the parameter in % [0-1])
                      enrichInt = 0, # Intensity of enrichement planting (in % [0-1])
                      plotLimit = 200, # limit to repeat the loast eq to avoid empty plot
                      maxsteps = 1000) #maxsteps = 10000
  {
    library(rootSolve)

    # get pars
    pars <- get_pars(ENV1 = ENV1, ENV2 = 0, params, int = 5)

    nochange = 0

    trace.mat = matrix(NA, ncol  = length(init), nrow = maxsteps+1)
    trace.mat[1,] = c(init)
    state = init
    #plot(0, state[2], ylim = c(0,1), xlim = c(0, maxsteps), cex = .2)
    for (i in 1:maxsteps)
    {
      di = func(t = 1, state, pars, plantInt, harvInt, thinInt, enrichInt)
      state = state + di[[1]]
      trace.mat[i+1,] = state

      if(sum(abs(trace.mat[i, ] - trace.mat[i-1, ])) < 1e-8) nochange = nochange+1

      if(nochange >= 10) break;
      #points(i,state[2], cex=.2)
    }
    trace.mat = trace.mat[1:i,]

    TRE = i - 10

    # repeat the last eq so the plot is not empty
    if(dim(trace.mat)[1] < plotLimit) {
      missing <- plotLimit - dim(trace.mat)[1]
      trace.missing <- matrix(rep(trace.mat[dim(trace.mat)[1], ], missing), ncol = dim(trace.mat)[2], byrow = T)
      trace.mat <- rbind(trace.mat, trace.missing)
    }

    # Compute the Jacobian
    J = jacobian.full(y = state, func = model_fm, parms = pars, plantInt = plantInt, harvInt = harvInt, thinInt = thinInt, enrichInt = enrichInt)

    # Stability
    ev = max(Re(eigen(J)$values)) #in case of complex eigenvalue, using Re to get the first real part

    # Euclidean distance between initial and final state proportion
    dst <- dist(rbind(init, state))

    return(list(eq = state, mat = trace.mat, ev = ev, dst = dst, TRE = TRE))
  }

  plot_solve <- function(data, data1, ylim = NULL, plantInt, harvInt, thinInt, enrichInt)
  {
    if(is.null(ylim)) ylim = c(0, 1)
    xlim = c(0, max(c(dim(data[[2]])[1]), c(dim(data1[[2]])[1])))

    # add regenration state
    data[[2]] <- cbind(data[[2]], apply(data[[2]], 1, function(x) 1-sum(x)))
    data1[[2]] <- cbind(data1[[2]], apply(data1[[2]], 1, function(x) 1-sum(x)))

    # legend
    leg <- function(df) {
      rp = vector('expression', 3)
      rp[1] <- substitute(expression('TRE' == TRE), list(TRE = df[[5]]))[2]
      rp[2] <- substitute(expression('Ev' == ev), list(ev = round(df[[3]], 3)))[2]
      rp[3] <- substitute(expression(Delta ~ Eq == dEq), list(dEq = round(df[[4]], 3)))[2]
      return(rp)
    }

    #  plot
    par(mfrow = c(1, 2), cex = 1.4, mar = c(3,3,1.2,0.5), mgp = c(1.5, 0.3, 0), tck = -.008)
    plot(data[[2]][, 1], type = "l", ylim = ylim, xlim = xlim, xlab = "Time", ylab = "State proportion", lwd = 1.8)
    invisible(sapply(2:4, function(x) lines(data[[2]][, x], col = x, lwd = 1.8)))
    mtext("bfCC", 3, line = -1.2, cex = 1.3)
    legend("topright", legend = leg(data), bty = "n")

    plot(data1[[2]][, 1], type = "l", ylim = ylim, xlim = xlim, xlab = "Time", ylab = "", lwd = 1.8)
    invisible(sapply(2:4, function(x) lines(data1[[2]][, x], col = x, lwd = 1.8)))
    mtext("afCC", 3, line = -1.2, cex = 1.3)
    legend("topright", legend = leg(data1), bty = "n")
    mtext(paste0('Plantation = ', plantInt, '; Harvest = ', harvInt, '; Thinning = ', thinInt, '; Enrich = ', enrichInt), side = 3, line = -.8, cex = 1.5, outer = TRUE)
  }

  run <- function(ENV1a, ENV1b, plantInt = 0, harvInt = 0, thinInt = 0, enrichInt = 0, plotLimit = 200)
  {
    data <- solveEq(func = model_fm, init = eqBoreal, ENV1 = ENV1a, plantInt = plantInt, harvInt = harvInt, thinInt = thinInt, enrichInt = enrichInt, plotLimit, maxsteps = 10000)
    data1 <- solveEq(func = model_fm, init = eqBoreal, ENV1 = ENV1b, plantInt = plantInt, harvInt = harvInt, thinInt = thinInt, enrichInt = enrichInt, plotLimit, maxsteps = 10000)
    plot_solve(data = data, data1 = data1, plantInt = plantInt, harvInt = harvInt, thinInt = thinInt, enrichInt = enrichInt)
  }

  eqBoreal <- get_eq(get_pars(ENV1 = -1.55, ENV2 = 0, params, int = 5))[[1]]

  output$distPlot <- renderPlot({

    if(input$cc == 'RCP2.6') env1b = -1.176
    if(input$cc == 'RCP4.5') env1b = -0.882
    if(input$cc == 'RCP6') env1b = -0.7335
    if(input$cc == 'RCP8.5') env1b = -0.1772

    run(ENV1a = -1.55, ENV1b = env1b, plantInt = input$Plantation, harvInt = input$Harvest, thinInt = input$Thinning, enrichInt = input$Enrichement, plotLimit = input$plotLimit)

    })

}

shinyApp(ui, server)
