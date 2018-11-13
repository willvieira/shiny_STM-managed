##########################################################################################
#  Function to plot solve_summary
##########################################################################################

plot_summary <- function(dat, ylim = NULL)
{
  # state color
  stateColor <- setNames(c(rgb(0.15,	0.55, 0.54), rgb(0.98, 0.63, 0.22), rgb(0.53, 0.79, 0.51), 'black'), c('Boreal', 'Temperate', 'Mixed', 'Regeneration'))

  # plots
  par(mfrow = c(2, 3), cex = 1.4, mar = c(3,3.35,0.5,1), mgp = c(1.5, 0.3, 0), tck = -.008)

  # Equilibrium
  plot(dat$managInt, dat$EqB, col = stateColor[1], type = 'l', lwd = 2.1, ylim = c(0, 1), xlab = '', ylab = 'Proportion of states')
  invisible(sapply(8:10, function(x) points(dat$managInt, dat[, x], type = 'l', col = stateColor[x-6], lwd = 2.1)))

  # deltaState (exposure)
  plot(dat$managInt, dat$deltaState, ylim = ylim[[1]], type = 'l', lwd = 2.1, xlab = '', ylab = expression(Delta ['state']))

  # detalTime (sensibility)
  plot(dat$managInt, dat$deltaTime, ylim = ylim[[2]], type = 'l', lwd = 2.1, xlab = '', ylab = expression(paste(Delta ['Time'], ' (year*5)')))

  # R_infinity
  plot(dat$managInt, dat$R_inf, ylim = ylim[[3]], type = 'l', lwd = 2.1, xlab = '', ylab = expression('-R'[infinity]))

  # R_init
  plot(dat$managInt, dat$R_init, ylim = ylim[[4]], type = 'l', lwd = 2.1, xlab = '', ylab = expression(R['0']))

  # Integral
  plot(dat$managInt, dat$integral, ylim = ylim[[5]], type = 'l', lwd = 2.1, xlab = '', ylab = expression(integral(S(t)*dt)))

  # text
  mtext("Management intensity", 1, line = -1.3, outer = TRUE, cex = 1.5)
}
