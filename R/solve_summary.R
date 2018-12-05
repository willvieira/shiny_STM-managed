##########################################################################################
#  Function to get summarized data using the solveEq function
##########################################################################################

solve_summary <- function(env1a, env1b, growth, managPractices)
{
  # data frame to save solveEq output
  dat <- setNames(data.frame(seq(0, 1, length.out = 40), NA, NA, NA, NA, NA, NA, NA, NA, NA), c('managInt', 'deltaTime', 'deltaState', 'R_inf', 'R_init', 'integral', 'EqB', 'EqT', 'EqM', 'EqR'))

  # management practices
  managPrac <- list()
  for(i in 1:4) {
    managPrac[[i]] <- seq(0, managPractices[i], length.out = 40)
  }

  # solveEq for each management intensity
  for(i in 1:dim(dat)[1])
  {
    # create management vector from managPrac list
    management = c(managPrac[[1]][i], managPrac[[2]][i], managPrac[[3]][i], managPrac[[4]][i])
    res <- solve_Eq(func = model_fm, ENV1a = env1a, ENV1 = env1b,
                    growth,
                    management = management)

    dat[i, c('EqB', 'EqT', 'EqM', 'EqR')] <- c(res[['eq']], 1 - sum(res[['eq']]))
    dat[i, c('deltaTime', 'deltaState', 'R_inf', 'R_init', 'integral')] <- c(res[['deltaTime']], res[['deltaState']], res[['R_inf']], res[['R_init']], res[['integral']])

  }
  return(dat)
}
