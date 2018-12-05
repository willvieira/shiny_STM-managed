##########################################################################################
#  Function to run plot_summary
##########################################################################################

run_summary <- function(env1a, env1b, growth, managPractices, ylim)
{
  dat <- solve_summary(env1a, env1b, growth, managPractices)
  plot_summary(dat, ylim)
}
