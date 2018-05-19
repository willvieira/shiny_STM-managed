library(shiny)

# Define server logic required to draw a histogram ----
server <- function(input, output) {

  # get the model versions
  source("R/vissault_model_v3.R")
  source("R/vissault_model_fm.R") # model with forest management integrated
  # parameters
  params = read.table("R/pars.txt", row.names = 1)

  ##########################################################################################
  #  Function to solve the model and get the trace matrix, TRE, Eq, deltaEq and eigenvalue
  ##########################################################################################

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

  ##########################################################################################
  #  Function to plot the solved model - dynamic
  ##########################################################################################

  plot_solve <- function(data, data1, plotLimit = NULL, plantInt, harvInt, thinInt, enrichInt)
  {

    if(is.null(plotLimit)) {
      xlim = c(0, max(c(dim(data[[2]])[1]), c(dim(data1[[2]])[1])))
    }else{
      xlim = c(0, plotLimit)
    }

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

    # state color
    stateColor <- setNames(c(rgb(0.15,	0.55, 0.54), rgb(0.98, 0.63, 0.22), rgb(0.53, 0.79, 0.51), 'black'), c('Boreal', 'Temperate', 'Mixed', 'Regeneration'))

    #  plot
    par(mfrow = c(1, 2), cex = 1.4, mar = c(4,3,3,2), mgp = c(1.5, 0.3, 0), tck = -.008)
    plot(data[[2]][, 1], type = "l", col = stateColor[1], ylim = c(0, 1), xlim = xlim, xlab = "", ylab = "State proportion", lwd = 2.1)
    invisible(sapply(2:4, function(x) lines(data[[2]][, x], col = stateColor[x], lwd = 2.1)))
    mtext("bfCC", 3, line = -1.2, cex = 1.3)
    legend("topright", legend = leg(data), bty = "n")

    plot(data1[[2]][, 1], type = "l", col = stateColor[1], ylim = c(0, 1), xlim = xlim, xlab = "", ylab = "", lwd = 2.1)
    invisible(sapply(2:4, function(x) lines(data1[[2]][, x], col = stateColor[x], lwd = 2.1)))
    mtext("afCC", 3, line = -1.2, cex = 1.3)
    mtext("Time (year * 5)", 1, line = -1.8, outer = TRUE, cex = 1.5)
    legend("topright", legend = leg(data1), bty = "n")
    mtext(paste0('Plantation = ', plantInt, '; Harvest = ', harvInt, '; Thinning = ', thinInt, '; Enrich = ', enrichInt), side = 3, line = -2.5, cex = 1.5, outer = TRUE)
  }

  ##########################################################################################
  #  Function to run both solveEq and plot_solve functions - Dynamic
  ##########################################################################################

  run_dynamic <- function(ENV1a, ENV1b, plantInt = 0, harvInt = 0, thinInt = 0, enrichInt = 0, plotLimit = NULL)
  {
    data <- solveEq(func = model_fm, init = eqBoreal, ENV1 = ENV1a, plantInt = plantInt, harvInt = harvInt, thinInt = thinInt, enrichInt = enrichInt, plotLimit, maxsteps = 10000)
    data1 <- solveEq(func = model_fm, init = eqBoreal, ENV1 = ENV1b, plantInt = plantInt, harvInt = harvInt, thinInt = thinInt, enrichInt = enrichInt, plotLimit, maxsteps = 10000)
    plot_solve(data = data, data1 = data1, plantInt = plantInt, harvInt = harvInt, thinInt = thinInt, enrichInt = enrichInt, plotLimit)
  }

  ##########################################################################################
  #  Function to get summarized data using the solveEq function
  ##########################################################################################

  solve_summary <- function(env1b, managPractices) {

    # data frame to save solveEq output
    dat <- setNames(data.frame(seq(0, 1, length.out = 30), NA, NA, NA, NA, NA, NA), c('managInt', 'TRE', 'Ev', 'EqB', 'EqT', 'EqM', 'EqR'))

    # get initial state proportion
    eqBoreal <- get_eq(get_pars(ENV1 = -1.55, ENV2 = 0, params, int = 5))[[1]]

    # management practices
    managPrac <- list()
    for(i in 1:4) {
      managPrac[[i]] <- seq(0, managPractices[i], length.out = 30)
    }

    # solveEq for each management intensity
    for(i in 1:dim(dat)[1]) {

      res <- solveEq(func = model_fm, init = eqBoreal, ENV1 = env1b,
                    plantInt = managPrac[[1]][i],
                    harvInt = managPrac[[2]][i],
                    thinInt = managPrac[[3]][i],
                    enrichInt = managPrac[[4]][i])

      dat[i, c(4: 7)] <- c(res[[1]], 1 - sum(res[[1]]))
      dat[i, c(2, 3)] <- c(res[[5]], res[[3]])

    }

    return(dat)

  }

  ##########################################################################################
  #  Function to plot solve_summary
  ##########################################################################################

  plot_summary <- function(dat, ylimTRE = NULL, ylimEv = NULL) {

    # state color
    stateColor <- setNames(c(rgb(0.15,	0.55, 0.54), rgb(0.98, 0.63, 0.22), rgb(0.53, 0.79, 0.51), 'black'), c('Boreal', 'Temperate', 'Mixed', 'Regeneration'))

    # plots
    par(mfrow = c(1, 3), cex = 1.4, mar = c(4,3,3,1), mgp = c(1.5, 0.3, 0), tck = -.008)

    # TRE
    plot(dat$managInt, dat$TRE, type = 'l', lwd = 2.1, ylim = ylimTRE, xlab = '', ylab = 'Time to reach equilibrium (year * 5)')

    # Ev
    plot(dat$managInt, dat$Ev, type = 'l', lwd = 2.1, ylim = ylimEv, xlab = '', ylab = 'Largest eigenvalue')

    # Eq
    plot(dat$managInt, dat$EqB, col = stateColor[1], type = 'l', lwd = 2.1, ylim = c(0, 1), xlab = '', ylab = 'State proportion')
    invisible(sapply(5:7, function(x) points(dat$managInt, dat[, x], type = 'l', col = stateColor[x-3], lwd = 2.1)))

    # text
    mtext("Management intensity", 1, line = -1.8, outer = TRUE, cex = 1.5)

  }

  ##########################################################################################
  #  Function to run plot_summary
  ##########################################################################################

  run_summary <- function(env1b, managPractices, ylimTRE = NULL, ylimEv = NULL) {

    dat <- solve_summary(env1b, managPractices)
    plot_summary(dat, ylimTRE, ylimEv)
  }

  ##########################################################################################
  #  Output of shiny App for Panel 1 - Dynamic
  ##########################################################################################

  eqBoreal <- get_eq(get_pars(ENV1 = -1.55, ENV2 = 0, params, int = 5))[[1]]

  output$dynamic <- renderPlot({

    # CC scenarios
    if(input$cc == 'RCP4.5') env1b = -0.882
    if(input$cc == 'RCP6') env1b = -0.7335
    if(input$cc == 'RCP8.5') env1b = -0.1772

    run_dynamic(ENV1a = -1.55, ENV1b = env1b, plantInt = input$Plantation, harvInt = input$Harvest, thinInt = input$Thinning, enrichInt = input$Enrichement, plotLimit = input$plotLimit)

    })

    ##########################################################################################
    #  Output of shiny App for Panel 2 - Summary
    ##########################################################################################

    eqBoreal <- get_eq(get_pars(ENV1 = -1.55, ENV2 = 0, params, int = 5))[[1]]

    output$summary <- renderPlot({

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

      run_summary(env1b = env1b, managPractices = managP, ylimTRE = ylimTRE, ylimEv = ylimEv)

      })

      output$error <- renderText({
        if(is.null(input$managPractices)) warning('Select a managagement practice')
      })

}
