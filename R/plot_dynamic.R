##########################################################################################
#  Function to plot the solved model - dynamic
##########################################################################################

plot_solve <- function(data, data1, plotLimit = NULL, management)
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
    rp = vector('expression', 5)
    rp[1] <- substitute(expression('R'[infinity] == R_inf), list(R_inf = round(df[['R_inf']], 3)))[2]
    rp[2] <- substitute(expression('-R'[0] == R0), list(R0 = round(df[['R_init']], 3)))[2]
    rp[3] <- substitute(expression(Delta ['State'] == dS), list(dS = round(df[['deltaState']], 3)))[2]
    rp[4] <- substitute(expression(Delta ['Time'] == dT), list(dT = df[['deltaTime']]))[2]
    rp[5] <- substitute(expression(''[integral(S(t)*dt)]  == Int), list(Int = round(df[['integral']], 3)))[2]
    return(rp)
  }

  # state color
  stateColor <- setNames(c(rgb(0.15,	0.55, 0.54), rgb(0.98, 0.63, 0.22), rgb(0.53, 0.79, 0.51), 'black'), c('Boreal', 'Temperate', 'Mixed', 'Regeneration'))

  management <- management * 100

  #  plot
  par(mfrow = c(1, 2), cex = 1.4, mar = c(4,3,4,2), mgp = c(1.5, 0.3, 0), tck = -.008)
  plot(data[[2]][, 1], type = "l", col = stateColor[1], ylim = c(0, 1), xlim = xlim, xlab = "", ylab = "State proportion", lwd = 2.1)
  invisible(sapply(2:4, function(x) lines(data[[2]][, x], col = stateColor[x], lwd = 2.1)))
  mtext("No climate change", 3, line = .4, cex = 1.3)
  legend("topright", legend = leg(data), bty = "n")

  plot(data1[[2]][, 1], type = "l", col = stateColor[1], ylim = c(0, 1), xlim = xlim, xlab = "", ylab = "", lwd = 2.1)
  invisible(sapply(2:4, function(x) lines(data1[[2]][, x], col = stateColor[x], lwd = 2.1)))
  mtext("After Climate change", 3, line = .4, cex = 1.3)
  mtext("Time (year * 5)", 1, line = -2.5, outer = TRUE, cex = 1.5)
  legend("topright", legend = leg(data1), bty = "n")
  mtext(paste0('Plantation = ', management[1], '%; Harvest = ', management[2], '%; Thinning = ', management[3], '%; Enrich = ', management[4], '%'), side = 3, line = -2.5, cex = 1.5, outer = TRUE)
}


##########################################################################################
#  Function to run both solveEq and plot_solve functions - Dynamic
##########################################################################################

run_dynamic <- function(ENV1a, ENV1b, growth, management = c(0, 0, 0, 0), plotLimit = NULL)
{
  data <- solve_Eq(func = model_fm, ENV1a = ENV1a, ENV1b = ENV1a, growth = growth, management, plotLimit, maxsteps = 10000)
  data1 <- solve_Eq(func = model_fm, ENV1a = ENV1a, ENV1b = ENV1b, growth = growth, management, plotLimit, maxsteps = 10000)
  plot_solve(data = data, data1 = data1, management = management, plotLimit = plotLimit)
}
