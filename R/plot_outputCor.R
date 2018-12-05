##########################################################################################
#  Function to plot output correlation
##########################################################################################

plot_outputCor <- function(env1a, env1b, growth, managPractices)
{
  dat <- solve_summary(env1a, env1b, growth, managPractices)
  par(mfrow = c(5, 2), cex = 1.4, mar = c(3.5,3.35,0.1,1), mgp = c(1.5, 0.3, 0), tck = -.008)

  labs <- c(expression(Delta ['state']),
            expression(Delta ['Time']),
            expression('-R'[infinity]),
            expression(R['0']),
            expression(integral(S(t)*dt)))

  plot(dat$deltaState, dat$deltaTime, type = 'l', lwd = 2.1, xlab = labs[1], ylab = labs[2])
  plot(dat$deltaState, dat$R_inf, type = 'l', lwd = 2.1, xlab = labs[1], ylab = labs[3])
  plot(dat$deltaState, dat$R_init, type = 'l', lwd = 2.1, xlab = labs[1], ylab = labs[4])
  plot(dat$deltaState, dat$integral, type = 'l', lwd = 2.1, xlab = labs[1], ylab = labs[5])
  plot(dat$deltaTime, dat$R_inf, type = 'l', lwd = 2.1, xlab = labs[2], ylab = labs[3])
  plot(dat$deltaTime, dat$R_init, type = 'l', lwd = 2.1, xlab = labs[2], ylab = labs[4])
  plot(dat$deltaTime, dat$integral, type = 'l', lwd = 2.1, xlab = labs[2], ylab = labs[5])
  plot(dat$R_inf, dat$R_init, type = 'l', lwd = 2.1, xlab = labs[3], ylab = labs[4])
  plot(dat$R_inf, dat$integral, type = 'l', lwd = 2.1, xlab = labs[3], ylab = labs[5])
  plot(dat$R_init, dat$integral, type = 'l', lwd = 2.1, xlab = labs[4], ylab = labs[5])
}
