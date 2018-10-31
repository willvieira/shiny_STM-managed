##########################################################################################
#  Function to plot solve_summary
##########################################################################################

plot_summary <- function(dat, ylimTRE = NULL, ylimEv = NULL)
{
  # state color
  stateColor <- setNames(c(rgb(0.15,	0.55, 0.54), rgb(0.98, 0.63, 0.22), rgb(0.53, 0.79, 0.51), 'black'), c('Boreal', 'Temperate', 'Mixed', 'Regeneration'))

  # plots
  par(mfrow = c(2, 3), cex = 1.4, mar = c(3.5,3.35,0.1,1), mgp = c(1.5, 0.3, 0), tck = -.008)

  # Equilibrium
  plot(dat$managInt, dat$EqB, col = stateColor[1], type = 'l', lwd = 2.1, ylim = c(0, 1), xlab = '', ylab = 'Proportion of states')
  invisible(sapply(8:10, function(x) points(dat$managInt, dat[, x], type = 'l', col = stateColor[x-6], lwd = 2.1)))

  # deltaState (exposure)
  plot(dat$managInt, dat$deltaState, type = 'l', lwd = 2.1, xlab = '', ylab = expression(Delta ['state']))

  # detalTime (sensibility)
  plot(dat$managInt, dat$deltaTime, type = 'l', lwd = 2.1, ylim = ylimTRE, xlab = '', ylab = expression(paste(Delta ['Time'], ' (year*5)')))

  # R_infinity
  plot(dat$managInt, dat$R_inf, type = 'l', lwd = 2.1, ylim = ylimEv, xlab = '', ylab = expression('-R'[infinity]))

  # R_init
  plot(dat$managInt, dat$R_init, type = 'l', lwd = 2.1, xlab = '', ylab = expression(R['0']))

  # Integral
  plot(dat$managInt, dat$integral, type = 'l', lwd = 2.1, xlab = '', ylab = expression(integral(S(t)*dt)))

  # text
  mtext("Management intensity", 1, line = -1.8, outer = TRUE, cex = 1.5)
}
