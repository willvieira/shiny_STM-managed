##########################################################################################
#  Function to run plot_summary
##########################################################################################

run_summary <- function(env1b, growth, managPractices, ylimTRE = NULL, ylimEv = NULL)
{
  dat <- solve_summary(env1b, growth, managPractices)
  plot_summary(dat, ylimTRE, ylimEv)
}
