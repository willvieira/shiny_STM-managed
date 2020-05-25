##########################################################################################
# Functions and code to solve figure 1
# Will Vieira
# May 21, 2020
##########################################################################################


# It would take about 3-4 seconds to plot the figure in the shiny
# So here I calculate all the possibilities from the dashboard and store it the data folder


# Source needed functions
filesToSource <- c('R/solve_Eq.R', 'R/vissault_model_fm.R', 'R/vissault_model_v3.R')
invisible(lapply(as.list(filesToSource), source))
load('data/sysdata.rda')


# Function to solve

    # get data.table with all five metrics of the transiet dynamic along management intensity
    solve_summary <- function(env1a,
                              RCP,
                              RCPgrowth,
                              managPractices = c(1, 0, 0, 0))
    {
        # unscale temperature to add climate change
        tempUn0 <- env1a

        # add climate change
        if(RCP == 2.6) tempUn1 <- tempUn0 + 1 # increase of 1 degree
        if(RCP == 4.5) tempUn1 <- tempUn0 + 1.8
        if(RCP == 6) tempUn1 <- tempUn0 + 2.2
        if(RCP == 8.5) tempUn1 <- tempUn0 + 3.7

        # scale warming temperature
        env1b <- unname((tempUn1 - vars.means['annual_mean_temp'])/vars.sd['annual_mean_temp'])
        # scale initial temperature
        env1a <- unname((tempUn0 - vars.means['annual_mean_temp'])/vars.sd['annual_mean_temp'])

        # data frame to save solveEq output
        dat <- setNames(data.frame(seq(0, 1, length.out = 50), NA, NA, NA, NA, NA, NA, NA, NA, NA), c('managInt', 'Exposure', 'Asymptotic resilience', 'Sensitivity', 'Initial resilience', 'Cumulative state changes', 'EqB', 'EqT', 'EqM', 'EqR'))

        # management practices
        managPrac <- list()
        for(i in 1:4) {
            managPrac[[i]] <- seq(0, managPractices[i], length.out = 50)
        }

        # solveEq for each management intensity
        for(i in 1:dim(dat)[1])
        {
            # create management vector from managPrac list
            management = c(managPrac[[1]][i], managPrac[[2]][i], managPrac[[3]][i], managPrac[[4]][i])
            res <- solve_Eq(func = model_fm, ENV1a = env1a, ENV1b = env1b,
                            growth = RCPgrowth,
                            management = management)

            dat[i, c('EqB', 'EqT', 'EqM', 'EqR')] <- c(res[['eq']], 1 - sum(res[['eq']]))
            dat[i, c('Exposure', 'Asymptotic resilience', 'Sensitivity', 'Initial resilience', 'Cumulative state changes')] <- c(res[['deltaState']], res[['R_inf']], res[['deltaTime']], res[['R_init']], res[['integral']])

            cat('     solving to equilibrium -> ', round(i/nrow(dat) * 100, 0), '%\r')
        }

        cat('     solving to equilibrium -> ', round(i/nrow(dat) * 100, 0), '%\n')
        return(dat)
    }

#



# Parallel loop over all possibilities

    if(!dir.exists('data')) dir.create('data')

    # Variables with all possibilities
    practices <- c('Plantation', 'Harvest', 'Thinning', 'Enrichment')
    # Climate change
    CC <- c(2.6, 4.5, 6, 8.5)
    # Enviromental gradient
    env1a <- seq(-2.6, 5, 0.1)
    simulations <- expand.grid(practices, CC, env1a)

    # Parallel stuff
    library(foreach)
    cl <- parallel::makeForkCluster(14)
    doParallel::registerDoParallel(cl)

    myList <- foreach(i = 1:nrow(simulations)) %dopar% {
        
        manag <- c(0, 0, 0, 0)
        manag[which(simulations$Var1[i] == practices)] <- 1
        RCPs <- simulations$Var2[i]        
        ENV1A <- simulations$Var3[i]
        
        simResult <- solve_summary(env1a = ENV1A, RCP = RCPs, RCPgrowth = 'linear', managPractices = manag)
        
    }

    parallel::stopCluster(cl)

    # Name each element of the list with the simulation name
    simulations$Var3 <- as.character(simulations$Var3)
    names(myList) <- apply(simulations, 1, function(x) paste0(x, collapse = '_'))

    # save into sysdata.rda
    saveRDS(myList, file = 'data/data_fig2.RDS')
    rm(list = ls())
    load('data/sysdata.rda')
    objs <- ls()
    fig2List <- readRDS('data/data_fig2.RDS')
    save(list = c(objs, 'fig2List'), file = 'data/sysdata.rda', version = 2)
    file.remove('data/data_fig2.RDS')

#