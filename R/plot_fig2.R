##########################################################################################
#  Function to plot solve_summary
##########################################################################################

plot_fig2 <- function(fig2List, dat_Plantation, dat_Harvest, dat_Thinning, dat_Enrichment, dat_noManaged, dat_noCC, range_yLim, env1a)
{
  
  practices <- c('Plantation', 'Enrichment', 'Harvest', 'Thinning')
  metrics <- c('Exposure', 'Sensitivity', 'Asymptotic resilience', 'Initial resilience', 'Cumulative state changes')

  xLim <- c(0, 1)

  # get yLim
  dfYlim <- setNames(data.frame(matrix(rep(NA, length(metrics) * 2), ncol = 2)), c('min', 'max'))
  if(range_yLim == 'Fixed')
  {
    for(mt in 1:length(metrics))
      dfYlim[mt, ] <- range(unlist(lapply(fig2List, function(x) range(x[, metrics[mt]]))))
  }

  Alpha = 190
  mgCols = setNames(c(rgb(144, 178, 67, Alpha, maxColorValue = 255),
                      rgb(11, 89, 105, Alpha, maxColorValue = 255),
                      rgb(249, 66, 37, Alpha, maxColorValue = 255),
                      rgb(253, 168, 48, Alpha, maxColorValue = 255),
                      rgb(0, 0, 0, Alpha, maxColorValue = 255)), practices)

  # states color
  stateCols <- c("darkcyan", "orange", "palegreen3", "black")

  # Create img directory in case it does not exists
  par(mfcol = c(3, 3), mar = c(1, 2.5, .5, 0.8), oma = c(1.5, 0, 0.5, 5), mgp = c(1.4, 0.2, 0), tck = -.008, cex = 1.4)

  plot(dat_noManaged[, c('env1aUnscaled', 'EqB')], type = 'l', xlab = '', ylab = 'State proportion', ylim = c(0, .98), col = stateCols[1], lwd = 2.1)
  points(dat_noManaged$env1aUnscaled, dat_noManaged$EqM + dat_noManaged$EqT, type = 'l', col = stateCols[2], lwd = 2.1)
  points(dat_noCC[, c('env1aUnscaled', 'EqB')], type = 'l', xlab = '', ylab = 'State proportion', ylim = c(0, 1), col = stateCols[1], lty = 2, lwd = 2.1)
  points(dat_noCC$env1aUnscaled, dat_noCC$EqM + dat_noCC$EqT, type = 'l', col = stateCols[2], lty = 2, lwd = 2.1)
  axis(1, labels = F)
  legend(1.7, 0.94, legend = c('Boreal', 'Mixed +\nTemperate'), lty = 1, col = c(stateCols[1], stateCols[2]), bty = 'n', cex = 1, lwd = 2.1)
  legend(1.7, 0.58, legend = c(expression(paste('T'[0], ' equilibrium')), expression(paste('T'[1], ' equilibrium'))), lty = c(2, 1), col = 1, bty = 'n', cex = 1, lwd = 2.1)
  abline(v = env1a, lwd = 3)
  abline(v = as.numeric(env1a) - 0.075, lwd = 1.5, col = 'gray')
  abline(v = as.numeric(env1a) + 0.075, lwd = 1.5, col = 'gray')

  for(mt in metrics)
  {
    # ylim again
    if(range_yLim == 'Fixed')
    {
      yLim = as.numeric(dfYlim[which(mt == metrics), ])
    }else{ 
      yLim <- min(unlist(lapply(as.list(practices), function(x) min(get(paste0('dat_', x))[, mt]))))
      yLim[2] <- max(unlist(lapply(as.list(practices), function(x) max(get(paste0('dat_', x))[, mt]))))
    }

    plot(get('dat_Plantation')[, c('managInt', mt)], type = 'l', lwd = 2.1, col = mgCols[1], xlim = xLim, ylim = yLim, ylab = mt, cex.lab = 1.1, xaxt = 'n')
    # xaxis
    axis(1, labels = ifelse(mt == 'Cumulative state changes' | mt == 'Sensitivity', T, F))

    for(mg in practices[-1])
    {
      points(get(paste0('dat_', mg))[, c('managInt', mt)], type = 'l', lwd = 2.1, col = mgCols[mg])
    }
  }
  
  mtext("Managemenet intensity", 1, line = 1.1, cex = 1.4, at = -0.1)
  
  #legend 
  plot.new();plot.new()
  par(xpd = TRUE)
  legend(-.2, 0.75, legend = practices, lty = 1, col = mgCols, bty = 'n', cex = 1, lwd = 2.3)

}



# Function to get data and run plot function above
run_fig2 <- function(fig2List, RCP, env1a, range_yLim)
{

  env1a <- as.character(env1a)

  dat_Plantation <- fig2List[[paste('Plantation', RCP, env1a, sep = '_')]]
  dat_Harvest <- fig2List[[paste('Harvest', RCP, env1a, sep = '_')]]
  dat_Thinning <- fig2List[[paste('Thinning', RCP, env1a, sep = '_')]]
  dat_Enrichment <- fig2List[[paste('Enrichment', RCP, env1a, sep = '_')]]
  dat_noManaged <- fig1List[[paste('noManaged', RCP, '0.000', sep = '_')]]
  dat_noCC <- fig1List[['noCC']]

  plot_fig2(fig2List, dat_Plantation, dat_Harvest, dat_Thinning, dat_Enrichment, dat_noManaged, dat_noCC, range_yLim, env1a)
}