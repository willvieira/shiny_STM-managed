##########################################################################################
#  Function to plot solve_summary
##########################################################################################

plot_summary <- function(dat, ylimTRE = NULL, ylimEv = NULL)
{
  # state color
  stateColor <- setNames(c(rgb(0.15,	0.55, 0.54), rgb(0.98, 0.63, 0.22), rgb(0.53, 0.79, 0.51), 'black'), c('Boreal', 'Temperate', 'Mixed', 'Regeneration'))

  # plots
  par(mfrow = c(1, 3), cex = 1.4, mar = c(4,3,3,1), mgp = c(1.5, 0.3, 0), tck = -.008)

  # detalTime
  plot(dat$managInt, dat$deltaTime, type = 'l', lwd = 2.1, ylim = ylimTRE, xlab = '', ylab = 'Time to reach equilibrium (year * 5)')

  # R_infinity
  plot(dat$managInt, dat$R_inf, type = 'l', lwd = 2.1, ylim = ylimEv, xlab = '', ylab = 'Largest eigenvalue')

  # Equilibrium
  plot(dat$managInt, dat$EqB, col = stateColor[1], type = 'l', lwd = 2.1, ylim = c(0, 1), xlab = '', ylab = 'State proportion')
  invisible(sapply(6:8, function(x) points(dat$managInt, dat[, x], type = 'l', col = stateColor[x-4], lwd = 2.1)))

  # text
  mtext("Management intensity", 1, line = -1.8, outer = TRUE, cex = 1.5)
}
