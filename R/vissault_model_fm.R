#################################
# Define the model
#################################
model_fm = function(t, y, params, management) {
	with(as.list(c(y, params, management)), {

		# management (1. plantation, 2. harvest, 3. thinning, 4. enrichement)
		naturalSuccession <- 1 - management[1] # plantation
		naturalColonization <- 1 - management[4] # enrichement planting
		naturalHarvest <- 1 - management[2]

		# Fraction of empty patches converted into the different states following a disturbance
		pB = alphab * (B + M)
		pT = alphat * (T + M)
		pM = pB * pT
		pB_ = pB * (1 - pT)
		pT_ = pT * (1 - pB)

		# Regeneration state
		R = 1 - B - T - M

		# Differential equations describing the dynamics of the state variables
		dBdt = pB_ * naturalSuccession * R + theta * (1 - thetat) * M - ((betat * (T + M) * naturalColonization) + management[4]) * B - ((epsB * naturalHarvest) + management[2]) * B
		dTdt = ((pT_ * naturalSuccession) + management[1]) * R + (theta * thetat + management[3] * (1 - theta)) * M - betab * (B + M) * T - epsT * T
		dMdt = pM  * naturalSuccession * R + betab * (B + M) * T + ((betat * (T + M) * naturalColonization) + management[4]) * B - (theta * (1 - thetat) + (theta * thetat + management[3] * (1 - theta))) * M - epsM * M
		list(c(dBdt, dTdt, dMdt))
		})
	}

#################################
# Local stabilityr
#################################
get_eq_fm = function(params, y = NULL, management) {

	library(rootSolve)

	# Initial conditions
	if(is.null(y)) {
		y = c(B = 0.25, T = 0.25, M = 0.25)
	}else(y = y)

	# Get the equilibrium
	eq = runsteady(y = y, func = model_fm, parms = params, management = management, times = c(0, 1000))

	# Compute the Jacobian
	J = jacobian.full(y = eq[[1]], func = model_fm, parms = params, management = management)

	# Stability
	ev = max(Re(eigen(J)$values)) #in case of complex eigenvalue, using Re to get the first real part

	# return equilibrium, largest eigenvalue and time to reach equilibrium
	return(list(eq = eq[[1]], ev = ev, TRE = attributes(eq)$steps))
}

#################################
# Wrapper to collect parameters for a given set of environmental conditions
#################################
logit_reverse <- function(x) exp(x) / (1 + exp(x))

get_pars = function(ENV1, ENV2, params, int) {

  	logit_alphab 	<- 3.85502802 + 0.09795949 * ENV1 + 7.39804020 * ENV2 - 0.36426173 * ENV1^2 + 5.08246535 * ENV2^2 + 0.00000000 * ENV1^3 + 0.00000000 * ENV2^3
  	logit_alphat 	<- 1.99391609 + 6.25928127 * ENV1 + 1.17114948 * ENV2 + 0.76980055 * ENV1^2 - 0.32574109 * ENV2^2 + 0.00000000 * ENV1^3 + 0.00000000 * ENV2^3
  	logit_betab 	<- -2.20523210 - 1.19790280 * ENV1 + 0.01066048 * ENV2 - 0.38339845 * ENV1^2 - 0.02139923 * ENV2^2 + 0.00000000 * ENV1^3 + 0.00000000 * ENV2^3
  	logit_betat 	<- -1.53724874 + 0.73115855 * ENV1 + 0.22881246 * ENV2 - 1.03032612 * ENV1^2 - 0.22600455 * ENV2^2 + 0.00000000 * ENV1^3 + 0.00000000 * ENV2^3
  	logit_theta		<- -2.81754950 + 0.18052846 * ENV1 - 0.30087526 * ENV2 + 0.30003633 * ENV1^2 + 0.01661800 * ENV2^2 + 0.00000000 * ENV1^3 + 0.00000000 * ENV2^3
  	logit_thetat	<- 0.84883267 + 0.52777617 * ENV1 - 0.10106349 * ENV2 - 0.18996130 * ENV1^2 - 0.18073578 * ENV2^2 + 0.00000000 * ENV1^3 + 0.00000000 * ENV2^3
  	logit_epsB 		<- -5.75961358 -1.02065171 * ENV1 - 0.00707712 * ENV2 -0.24368088 * ENV1^2 - 0.00841648 * ENV2^2 + 0.00000000 * ENV1^3 + 0.00000000 * ENV2^3
  	logit_epsT 		<- -5.75961358 -1.02065171 * ENV1 - 0.00707712 * ENV2 -0.24368088 * ENV1^2 - 0.00841648 * ENV2^2 + 0.00000000 * ENV1^3 + 0.00000000 * ENV2^3
  	logit_epsM 		<- -5.75961358 -1.02065171 * ENV1 - 0.00707712 * ENV2 -0.24368088 * ENV1^2 - 0.00841648 * ENV2^2 + 0.00000000 * ENV1^3 + 0.00000000 * ENV2^3

	alphab = 1-(1-logit_reverse(logit_alphab))^int
	alphat = 1-(1-logit_reverse(logit_alphat))^int
	betab  = 1-(1-logit_reverse(logit_betab))^int
	betat  = 1-(1-logit_reverse(logit_betat))^int
	theta  = 1-(1-logit_reverse(logit_theta))^int
	thetat = 1-(1-logit_reverse(logit_thetat))^int
	epsB    = 1-(1-logit_reverse(logit_epsB))^int
	epsT    = 1-(1-logit_reverse(logit_epsT))^int
	epsM   = 1-(1-logit_reverse(logit_epsM))^int

	return(c(alphab = alphab, alphat = alphat, betab = betab, betat = betat, theta = theta, thetat = thetat, epsB = epsB, epsT = epsT, epsM = epsM))

}

#################################
# COLLECT THE TRANSITION MATRIX
#################################

	get_matrix_fm = function(ENV1 = NULL, ENV2 = NULL, pars = NULL, params = NULL, eq = NULL, int = NULL, management) {

		if(is.null(int)) {
			int = 3
		}
		if(is.null(pars)) {
			pars = get_pars(ENV1, ENV2, params = params, int = int)
		}
		if(is.null(eq)) {
			eq = get_eq_fm(pars, management)[[1]]
		}

		MAT = matrix(nr = 4, nc = 4)

		B = eq[1]
		T = eq[2]
		M = eq[3]
		R = 1 - B - M - T
		names(R) <- "R" #Renaming R because it would get "B" name instead

		pB = pars["alphab"]*(B+M)
		pT = pars["alphat"]*(T+M)
		pM = pB*pT
		pB_ = pB*(1-pT)
		pT_ = pT*(1-pB)

		# ORDER IN THE MATRIX: R, B, M, T

		MAT[1,1] = 1-(pB_*R + pM*R + pT_*R)
		MAT[1,2] = pB_*R
		MAT[1,3] = pM*R
		MAT[1,4] = pT_*R

		MAT[2,1] = pars["epsB"]*B
		MAT[2,2] = 1 - pars["epsB"]*B - pars["betab"]*(B+M)*T
		MAT[2,3] = pars["betab"]*(B+M)*T
		MAT[2,4] = 0

		MAT[3,1] = pars["epsM"]*M
		MAT[3,2] = pars["theta"]*(1-pars["thetat"])*M
		MAT[3,3] = 1 - pars["epsM"]*M - pars["theta"]*M
		MAT[3,4] = pars["theta"]*(pars["thetat"])*M

		MAT[4,1] = pars["epsT"]*T
		MAT[4,2] = 0
		MAT[4,3] = pars["betat"]*(T+M)*B
		MAT[4,4] = 1 - pars["epsT"]*T - pars["betat"]*(T+M)*B

		# Rename Matrix col and row
		nm <- c("R", "B", "M", "T")
		rownames(MAT) <- nm
		colnames(MAT) <- nm

		return(list(eq=c(B,M,T,R),MAT=MAT))

	}
