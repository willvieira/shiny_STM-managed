##########################################################################################
#  Function to run both solveEq and plot_solve functions - Dynamic
##########################################################################################

run_dynamic <- function(ENV1a, ENV1b, growth, management = c(0, 0, 0, 0), plotLimit = NULL)
{
  data <- solve_Eq(func = model_fm, ENV0 = -1.55, ENV1 = ENV1a, growth = growth, management, plotLimit, maxsteps = 10000)
  data1 <- solve_Eq(func = model_fm, ENV0 = -1.55, ENV1 = ENV1b, growth = growth, management, plotLimit, maxsteps = 10000)
  plot_solve(data = data, data1 = data1, management = management, plotLimit = plotLimit)
}
