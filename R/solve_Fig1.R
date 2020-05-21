##########################################################################################
# Functions and code to solve figure 1
# Will Vieira
# May 20, 2020
##########################################################################################


# It would take about 3-4 seconds to plot the figure in the shiny
# So here I calculate all the possibilities from the dashboard and store it the data folder



# Source needed functions
filesToSource <- c('R/solve_Eq.R', 'R/vissault_model_fm.R', 'R/vissault_model_v3.R')
invisible(lapply(as.list(filesToSource), source))
load('data/sysdata.rda')


# Function to solve

  solve_summary <- function(northLimit = -2.5,
                            southLimit = 0.35,
                            RCP,
                            RCPgrowth,
                            managPractices)
  {

    # create env1 before (a) and after (b) climate change
    env1a <- seq(northLimit, southLimit, length.out = 200)

    # unscale temperature to add climate change
    tempSc0 <- env1a
    tempUn0 <- tempSc0 * vars.sd['annual_mean_temp'] + vars.means['annual_mean_temp']

    # add climate change
    if(RCP == 2.6) tempUn1 <- tempUn0 + 1 # increase of 1 degree
    if(RCP == 4.5) tempUn1 <- tempUn0 + 1.8
    if(RCP == 6) tempUn1 <- tempUn0 + 2.2
    if(RCP == 8.5) tempUn1 <- tempUn0 + 3.7
    if(RCP == 0) tempUn1 <- tempUn0

    # scale warming temperature
    env1b <- (tempUn1 - vars.means['annual_mean_temp'])/vars.sd['annual_mean_temp']

    # data frame to save solveEq output
    dat <- setNames(data.frame(env1a, env1b, tempUn0, NA, NA, NA, NA, NA, NA, NA, NA, NA), c('env1a', 'env1b', 'env1aUnscaled', 'Exposure', 'Asymptotic resilience', 'Sensitivity', 'Initial resilience', 'Cumulative state changes', 'EqB', 'EqT', 'EqM', 'EqR'))

    # solveEq for each latitudinal cell
    for(i in 1:nrow(dat))
    {
      # create management vector from managPrac list
      res <- solve_Eq(func = model_fm, ENV1a = dat[i, 'env1a'], ENV1b = dat[i, 'env1b'],
                      growth = RCPgrowth,
                      management = managPractices)

      dat[i, c('EqB', 'EqT', 'EqM', 'EqR')] <- c(res[['eq']], 1 - sum(res[['eq']]))
      dat[i, c('Exposure', 'Asymptotic resilience', 'Sensitivity', 'Initial resilience', 'Cumulative state changes')] <- c(res[['deltaState']], res[['R_inf']], res[['deltaTime']], res[['R_init']], res[['integral']])

      cat('     solving to equilibrium -> ', round(i/nrow(dat) * 100, 0), '%\r')
    }
    cat('     solving to equilibrium -> ', round(i/nrow(dat) * 100, 0), '%\n')
    return(dat)
  }

#


# Parallel loop over all posibilities

  # get dat for noManaged and then all practices for two RCP scenarios (4.5 and 8.5)
  if(!dir.exists('data')) dir.create('data')
  practices <- c('Plantation', 'Harvest', 'Thinning', 'Enrichment')
  CC <- c(2.6, 4.5, 6, 8.5)
  managInt <- seq(0.001, 1, 0.004)
  simulations <- expand.grid(practices, CC, managInt)
  simulations <- rbind(simulations, data.frame(Var1 = rep('noManaged', length(CC)), Var2 = CC, Var3 = rep(0, length(CC))))


  # Parallel stuff
  library(foreach)
  cl <- parallel::makeForkCluster(12)
  doParallel::registerDoParallel(cl)

  myList <- foreach(i = 1:nrow(simulations)) %dopar% {
    cat("Simulation", i, "of", nrow(simulations), '\n')

    RCP <- simulations[i, 2]
    manag <- rep(0, 4)
    manag[which(simulations[i, 1] == practices)] <- simulations[i, 3]

    # run simulation
    simResult <- solve_summary(northLimit = -2.5, southLimit = 0.35, RCP = RCP, RCPgrowth = 'linear', managPractices = manag)

  }

  parallel::stopCluster(cl)

  # Name each element of the list with the simulation name
  names(myList) <- apply(simulations, 1, function(x) paste0(x, collapse = '_'))

  saveRDS(myList, file = 'data/data_fig1.RDS')

#



# Get range of each transient metric to compose yLim of each plot
  
  # variable names
  metrics <- c('Asymptotic resilience', 'Exposure', 'Initial resilience', 'Sensitivity', 'Cumulative state changes')

  # where to save range
  df <- setNames(data.frame(matrix(NA, ncol = 2)), c('min', 'max'))
  
  for(mt in 1:length(metrics))
    df[mt, ] <- range(unlist(lapply(myList, function(x) range(x[, metrics[mt]]))))
  
#
