##########################################################################################
#  Function to plot output correlation
##########################################################################################

plot_outputCor <- function(env1b, growth, managPractices)
{
  dat <- solve_summary(env1b, growth, managPractices)
  par(mfrow = c(1, 3), cex = 1.4, mar = c(4,3,3,2), mgp = c(1.5, 0.3, 0), tck = -.008)
  plot(dat$R_inf, dat$deltaTime, type = 'l', lwd = 2.1, xlab = 'Largest real part', ylab = 'Time to reach equilibrium')
  plot(dat$Dis, dat$deltaTime, type = 'l', lwd = 2.1, xlab = 'DeltaEq', ylab = 'Time to reach equilibrium')
  plot(dat$Dis, dat$R_inf, type = 'l', lwd = 2.1, xlab = 'DeltaEq', ylab = 'Largest real part')
}
