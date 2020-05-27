library(shiny)

ui <- fluidPage(theme = shinythemes::shinytheme("cosmo"),

includeCSS('style.css'),

navbarPage("ShinyApp for the STManaged model",

tabPanel("Home",

  HTML("
      <script id='MathJax-script' async src='https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js'></script>
      <link rel='stylesheet' href='https://use.fontawesome.com/releases/v5.8.1/css/all.css' integrity='sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf' crossorigin='anonymous'>
      <link rel='stylesheet' href='https://cdn.rawgit.com/jpswalsh/academicons/master/css/academicons.min.css'>
      
      <header>

        <h1>Effect of Forest Management on Transient Dynamics After Climate Change</h1>
                
        <div class='author'>Willian Vieira <a style='font-size: 20px; color: rgb(172, 203, 72);'  href='https://orcid.org/0000-0003-0283-4570' target='_blank';'><i class='ai ai-orcid'></i></a></div>
        
        <div class='date'>Last updated on May 26, 2020</div>

        <div class='summary'> This is an application accompanying the publication in which we test the potential of forest management to accelerate northward range shift of the boreal-temperate forest ecotone. We use a State and Transition Model with four forest states: (B)oreal, (T)emperate, (M)ixed, and (R)egeneration. The proportion between the four states vary in function of mean annual temperature and preciptation. In colder temperature Boreal state is dominant, while Temperate dominates in a warmer temperature. Given future warmer temperatures due to climate change, it is expected that forest proportion will shift to warmer adapted states (Temperate). However, several tree species are expected to lag behind climate change due to slow demography, competitive interactions and dispersal limitations. It means that after warming temperature, tree species may take too long to reach the new equilibrium with the new climate conditions. Here we assess how forest management may accelerate this transition to the new equilibrium. We characterize the transient phase using five different metrics and quantify the effect of forest management in each of these metrics. For more details about the model and metrics, check the full article on the following link.</div>
      
      </header>
      
      <nav class='artifacts'>
        <a style='font-size: 25px; color: rgb(139, 165, 54); title='Article' href='https://willvieira.github.io/ms_STM-managed/' target='_blank';'><i class='fas fa-newspaper'></i></a>
        &nbsp;
        <a style='font-size: 25px; color: rgb(139, 165, 54); title='Github repo' href='https://github.com/willvieira/shiny_STM-managed' target='_blank';'><i class='fab fa-github'></i></a>
      </nav>

      <article class='container'>
        
        <p>
          To assess the potential of forest management to accelerate the response of forest to warming temperature, we applied warming temperature and focused on the dynamics of the transient period of the four forest states over time until they reach the new steady state. Once equilibrium with the new climate conditions is reached, we can calculate the five metrics describing this transient phase.
          In the following section we describe the five metrics of the transient dynamics. We finish with details of each of the three tabs in this application in which you can play with different parameters and have full control of the model used in the manuscript.
        </p>
        
        <h2>Transient metrics</h2>

          <p>
            The five metrics characterizing the transient phase after warming temperature for each latitude position allowed us to fully describe the transient phase and the effect of forest management during this phase.
            The first two metrics are the asymptotic and initial resilience as measures of local stability derived from the Jacobian Matrix <span class='math inline'>\\(J\\)</span> at the new equilibrium <span class='citation' data-cites='Arnoldi2016'>(Arnoldi, Loreau, and Haegeman <a href='#ref-Arnoldi2016' role='doc-biblioref'>2016</a>)</span>.
            <span class='math inline'>\\(J\\)</span> was numerically calculated using the R package rootSolve <span class='citation' data-cites='Soetaert2009 Soetaert2009a'>(Soetaert and Herman <a href='#ref-Soetaert2009' role='doc-biblioref'>2009</a>; Soetaert <a href='#ref-Soetaert2009a' role='doc-biblioref'>2009</a>)</span>. The asymptotic resilience (<span class='math inline'>\\(R_{\\infty}\\)</span>) is the leading eigen value of <span class='math inline'>\\(J\\)</span>, and quantifies the asymptotic rate of return to equilibrium after small perturbation. The more negative <span class='math inline'>\\(R_{\\infty}\\)</span>, the greater asymptotic resilience. Initial resilience (<span class='math inline'>\\(-R_0\\)</span>) is the leading eigen value of the following matrix:
          </p>

          <p><span class='math display'>\\[
            M = \\frac{-J + J^T}{2}
            \\]</span>
          </p>
        
          <p>
            Positive values of <span class='math inline'>\\(-R_0\\)</span> indicate a smooth transition to the new equilibrium whereas negative values indicate reactivity, <em>i.e.</em> an initial amplification against final equilibrium. The third metric is the exposure of the ecosystem states (<span class='math inline'>\\(\\Delta_{state}\\)</span>), defined by the difference in state proportion between pre- and post-temperature warming <span class='citation' data-cites='Dawson2011'>(Dawson et al. <a href='#ref-Dawson2011' role='doc-biblioref'>2011</a>)</span>. The fourth metric is the return time (<span class='math inline'>\\(\\Delta_{time}\\)</span>) or ecosystem sensitivity, which is estimated by the number of steps of the transitory phase, where each time step of the model is equal to 5 years. The last metric is the cumulative amount of changes in the transitory phase, or ecosystem vulnerability <span class='citation' data-cites='Boulangeat2018'>(Boulangeat et al. <a href='#ref-Boulangeat2018' role='doc-biblioref'>2018</a>)</span>. It is defined as the sum of all changes in the states after warming temperature and is obtained by the integral of the states change over time (<span class='math inline'>\\(\\int S(t)dt\\)</span>). These five metrics together can summarize the multidimensionality of the response of a system to external disturbances.
          </p>

        <h2>Tab description</h2>

        <p> In the first tab <spam>Dynamic</spam>... </p>

        <p> In the second tab <spam>Figure 1</spam>... </p>

        <p> In the third tab <spam>Figure 3</spam>... </p>

        <h2>References</h2>

          <div id='ref-Arnoldi2016'>
              <p>Arnoldi, J. F., M. Loreau, and B. Haegeman. 2016. “Resilience, reactivity and variability: A mathematical comparison of ecological stability measures.” <em>Journal of Theoretical Biology</em> 389: 47–59. <a href='https://doi.org/10.1016/j.jtbi.2015.10.012'>https://doi.org/10.1016/j.jtbi.2015.10.012</a>.</p>
          </div>
          <div id='ref-Boulangeat2018'>
              <p>Boulangeat, Isabelle, Jens Christian Svenning, Tanguy Daufresne, Mathieu Leblond, and Dominique Gravel. 2018. “The transient response of ecosystems to climate change is amplified by trophic interactions.” <em>Oikos</em>, 1–12. <a href='https://doi.org/10.1111/oik.05052'>https://doi.org/10.1111/oik.05052</a>.</p>
          </div>
          <div id='ref-Dawson2011'>
              <p>Dawson, Terence P., Stephen T Jackson, Joanna I House, Iain Colin Prentice, and Georgina M. Mace. 2011. “Supporting Online Material for Beyond Predictions : Biodiversity Conservation in a Changing Climate.” <em>Science</em> 86 (53). <a href='https://doi.org/10.1126/science.1200303'>https://doi.org/10.1126/science.1200303</a>.</p>
          </div>
          <div id='ref-Soetaert2009a'>
              <p>Soetaert, Karline. 2009. <em>rootSolve: Nonlinear root finding, equilibrium and steady-state analysis of ordinary differential equations (R package v1.6)</em>.</p>
          </div>
          <div id='ref-Soetaert2009'>
              <p>Soetaert, Karline, and Peter M. J. Herman. 2009. <em>A Practical Guide to Ecological Modelling. Using R as a Simulation Platform</em>. Springer.</p>
          </div>

      </article>")
  ),

  ##########################################################################################
  #  Panel 1 - Dynamic
  ##########################################################################################

  tabPanel("Dynamic",

  # App title ----
  titlePanel("Effect of Forest Management on Transient Dynamics After Climate Change"),

    # Sidebar layout with input and output definitions ----
      sidebarLayout(

        # Sidebar panel for inputs ----
        sidebarPanel(width = 3,

          HTML("<font size='4'><b>Latitudinal position<br></b></font>"),
            # Input: Selector for choosing dataset ----
            sliderInput(inputId = "latitude",
                        label = "Select the mean annual temperature:",
                        min = -2.6,
                        max = 5,
                        value = 0.08,
                        post = '°C'),

          HTML("<br><font size='4'><b>Climate change scenarios<br></b></font>"),

            radioButtons(inputId = "cc",
                        label = "Select the RCP:",
                        choices = c("RCP2.6","RCP4.5", "RCP6", "RCP8.5"),
                        inline = T,
                        selected = "RCP4.5"),

            radioButtons(inputId = "growth",
                        label = "Select how warming temperature increases:",
                        choices = c("stepwise", "linear", "exponential"), inline = T),

          HTML("<br><font size='4'><b>Intensity of management practices</b></font>"),

            # Input: Slider for the management Intensity ----
            sliderInput(inputId = "Plantation",
                        label = "Plantation intensity",
                        min = 0,
                        max = 100,
                        step = 0.5,
                        value = 0,
                        post = '%'),
            sliderInput(inputId = "Enrichement",
                        label = "Enrichement planting intensity",
                        min = 0,
                        max = 100,
                        step = 0.5,
                        value = 0,
                        post = '%'),
            sliderInput(inputId = "Harvest",
                        label = "Harvest intensity",
                        min = 0,
                        max = 100,
                        step = 0.5,
                        value = 0,
                        post = '%'),
            sliderInput(inputId = "Thinning",
                        label = "Thinning intensity",
                        min = 0,
                        max = 100,
                        step = 0.5,
                        value = 0,
                        post = '%'),

          HTML("<br><font size='4'><b>Limit of x axis<br></b></font>"),
            # Input: Selector for choosing dataset ----
            sliderInput(inputId = "plotLimit",
                        label = "Choose a limit",
                        min = 50,
                        max = 500,
                        value = 200)
        ),

        # Main panel for displaying outputs ----
        mainPanel(

          # Output
          plotOutput(outputId = "dynamic", height = 470),

          div(img(src='model_pr.png', height = 350), style="text-align: center;")
        )
      )
    ),

    ##########################################################################################
    #  Panel 2 - Fig1
    ##########################################################################################

    tabPanel("Figure 1",

      titlePanel("Effect of Forest Management on Transient Dynamics After Climate Change"),

      # Sidebar layout with input and output definitions ----
      sidebarLayout(

        # Sidebar panel for inputs ----
        sidebarPanel(width = 3,

          HTML("<font size='4'><b>Climate change scenarios<br></b></font>"),
            radioButtons(inputId = "cc2",
                        label = "Select the RCP:",
                        choices = c("RCP2.6", "RCP4.5", "RCP6", "RCP8.5"), inline = T,
                        selected = "RCP4.5"),

          HTML("<br><font size='4'><b>Intensity of management practices<br></b></font>"),

            sliderInput(inputId = "managInt",
                        label = "Select the intensity of forest management:",
                        min = 0.1,
                        max = 99.7,
                        step = 0.4,
                        value = 0.5,
                        post = '%'),

           HTML("<br><font size='4'><b>Range of y axis</b></font>"),

            radioButtons(inputId = "range_yLim",
                         label = "",
                         choices = c("Fixed", "Dynamic"), inline = T,
                         selected = "Fixed")
        ),

        # Main panel for displaying outputs ----
        mainPanel(
          plotOutput(outputId = "fig1", height = 850, width = '115%')
        )
      )
    ),

    ##########################################################################################
    #  Panel 3 - Output correlation
    ##########################################################################################

    tabPanel("Figure 2",

      titlePanel("Effect of Forest Management on Transient Dynamics After Climate Change"),

      # Sidebar layout with input and output definitions ----
      sidebarLayout(

        # Sidebar panel for inputs ----
        sidebarPanel(width = 3,

          HTML("<font size='4'><b>Climate change scenarios<br></b></font>"),
            radioButtons(inputId = "cc3",
                        label = "Select the RCP:",
                        choices = c("RCP2.6", "RCP4.5", "RCP6", "RCP8.5"), inline = T,
                        selected = "RCP4.5"),

          HTML("<br><font size='4'><b>Latitudinal position</b></font>"),

            sliderInput(inputId = "envir1a",
                        label = "Select the mean annual temperature:",
                        min = -2.6,
                        max = 5,
                        step = 0.1,
                        value = -1,
                        post = '°C'),

           HTML("<br><font size='4'><b>Range of y axis</b></font>"),

            radioButtons(inputId = "range_yLim2",
                         label = "",
                         choices = c("Fixed", "Dynamic"), inline = T,
                         selected = "Fixed")
        ),

        # Main panel for displaying outputs ----
        mainPanel(
          plotOutput(outputId = "fig2", height = 850, width = '115%')
        )
      )
    )
  )
)
