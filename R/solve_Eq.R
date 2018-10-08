##########################################################################################
#  Function to solve the model and get the trace matrix, TRE, Eq, deltaEq and eigenvalue
##########################################################################################

solve_Eq <- function(func = model_fm, # = model
                    ENV0, # = to get state at T0 ou y
                    ENV1, # temperature
                    growth = 'linear', # patern of climate change increase [stepwise, linear, exponential]
                    management = c(0, 0, 0, 0), # intensity of management (in % [0-1]) order: plantation, harvest, thinning, enrichmenet
                    plotLimit = 200, # limit to repeat the loast eq to avoid empty plot
                    maxsteps = 1000) #maxsteps = 10000
{
  library(rootSolve)

  # parameters
  params = read.table("data/pars.txt", row.names = 1)

  # get equilibrium for initial condition (ENV0)
  init <- get_eq(get_pars(ENV1 = ENV0, ENV2 = 0, params, int = 5))[[1]]

  # get pars depending on the growth mode
  envDiff <- ENV1 - ENV0
  if(growth == 'stepwise') {
    pars <- get_pars(ENV1 = ENV1, ENV2 = 0, params, int = 5)
  }else if(growth == 'linear') {
    gwt <- 1:20 * envDiff/20 + ENV0
    envGrowth <- c(ENV0, gwt, rep(gwt[20], maxsteps))
  }else if(growth == 'exponential') {
    gwt <- ENV0 * ((ENV1/ENV0)^(1/20*1:20))
    envGrowth <- c(ENV0, gwt, rep(gwt[20], maxsteps))
  }

  nochange = 0

  trace.mat = matrix(NA, ncol  = length(init), nrow = maxsteps+1)
  trace.mat[1,] = c(init)
  state = init
  #plot(0, state[2], ylim = c(0,1), xlim = c(0, maxsteps), cex = .2)
  for (i in 1:maxsteps)
  {
    # because calculate the parameters many times get the app to be slow
    # I try and save some time here removing the parameters calculation if
    # growth is == stepwise (may optimize in a cleaner way)
    if(growth == 'stepwise') {
      di = func(t = 1, state, pars, management)
    }else {
      pars <- get_pars(ENV1 = envGrowth[i], ENV2 = 0, params, int = 5)
      di = func(t = 1, state, pars, management)
    }
    state = state + di[[1]]
    trace.mat[i+1,] = state

    if(sum(abs(trace.mat[i, ] - trace.mat[i-1, ])) < 1e-7) nochange = nochange+1

    if(nochange >= 10) break;
    #points(i,state[2], cex=.2)
  }
  trace.mat = trace.mat[1:i,]

  TRE = i - 10

  # repeat the last eq so the plot is not empty after reaching equilibrium
  if(dim(trace.mat)[1] < plotLimit) {
    missing <- plotLimit - dim(trace.mat)[1]
    trace.missing <- matrix(rep(trace.mat[dim(trace.mat)[1], ], missing), ncol = dim(trace.mat)[2], byrow = T)
    trace.mat <- rbind(trace.mat, trace.missing)
  }

  # Compute the Jacobian
  J = jacobian.full(y = state, func = model_fm, parms = pars, management = management)

  # Stability
  ev = max(Re(eigen(J)$values)) #in case of complex eigenvalue, using Re to get the first real part

  # Euclidean distance between initial and final state proportion
  dst <- dist(rbind(init, state))

  # time to reach equilibrium based in the deltaEq and eigenvalue
  lDst <- dist(rbind(log(init), log(state)))
  TREev <- lDst/ev

  return(list(eq = state, mat = trace.mat, ev = ev, dst = dst, TREev = TREev, TRE = TRE))
}
