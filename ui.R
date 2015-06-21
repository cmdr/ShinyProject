
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(
  
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),

  # Application title
  titlePanel("Gini coefficients for the Lasso model for German credit data"),
  
  HTML("<p><a href='https://en.wikipedia.org/wiki/Gini_coefficient'> The Gini coefficient </a> is sometimes used as a measure of quality 
      of binary classifiers accross a whole range of their sensitivities. Hence, it can be considered a global measure of classifier's quality. 
      For this reason, the Gini coefficient is often employed as a goal function to be maximized in a process of development of binary classifiers,
      e.g. the logistic regression. </p>

      <p> It is important to remember that for the sake of realistic estimation of a model's performance, one should estimate the quality measure,
      in this case the Gini coefficient, on an out-of-sample data set rather than on a train set. This small shiny app shows the Gini coefficients
      of the regularized logistic regression (lasso) evaluated for an out-of-sample data set as well as for the whole data set. A user-defined
      parameter is a number of folds employed in a training of the model. If n is a number of folds then 1/n fraction of the data set is used for
      the testing purpose and (n-1)/n is used for the fitting. As n changes, we can observe changes in the absolute and relative values of Gini coefficients.
      This example employs <i> GermanCredit </i> data from the <i> klaR</i> library.</p>

      <p> This shiny app requires the following libraries: <i> shiny, glmnet, klaR</i> and <i> pROC </i> to work .</p>

      <p> In addition, the below plot presents the area under <a href='https://en.wikipedia.org/wiki/Lorenz_curve'> the Lorentz curve </a>(AUC), 
      which relates to the Gini coefficient via 
       Gini = 2*AUC - 1, as a function of the penalty coefficient (lambda) in 
      <a href= 'https://en.wikipedia.org/wiki/Least_squares#Lasso_method'> the Lasso model </a>. The numbers above the upper x-axis show
       a number of variables entering the model. As we can observe, the higher the penalty coefficient lambda, the fewer predictors
      enter the model.
       </p>"),

  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("nfolds",
                  "Number of folds:",
                  min = 3,
                  max = 20,
                  value = 5,
                  step = 1)
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("plot", width = "90%"),
      strong(textOutput('text1')),
      strong(textOutput('text2')),
      strong(textOutput('text3'))
      )
   )
))
