# This is the server part for a Shiny application
# It's a part of the student project for Developing Data Products course at Coursera

library(shiny)
library(klaR)
library(glmnet)
library(pROC)
data(GermanCredit)

shinyServer(function(input, output) {
 
      ### Preprocess "GermanCredit" data set 
      # Ids of categorical predictors
      cat_data_id <- setdiff(which(unname(unlist(lapply(GermanCredit, function(x) "factor" %in% class(x))))), 21)
      
      # Evaluate WoE (weight of eveidence) of the categorical predictors
      woe_data <- woe(GermanCredit[, cat_data_id], GermanCredit$credit_risk, appont = 0.5)
      
      # Create the final data frame 
      GermanCreditWOE <- cbind(woe_data$xnew, GermanCredit[, setdiff(1:21, cat_data_id)])
      
      # Prepare data for glmnet model fitting
      xx <- as.matrix(GermanCreditWOE[, 1:20])
      yy <- GermanCreditWOE$credit_risk
      
      
      reactive_data = reactive({
          
            # Settings and user input
            nfolds = input$nfolds   # min(nfolds) = 3
            
            # Fit the glm
            model <- cv.glmnet(xx, yy, family = "binomial", type.measure = "auc", nfolds = nfolds)
      })
      
      
      output$plot <- renderPlot({
      
            # Load the model
            model = reactive_data()
            
            # Evaluate the Gini parameters on both data sets
            test_probs <- predict(model, newx = xx, s = "lambda.min", type =  "response")
            test_ROC <- model$cvm[which(model$glmnet.fit["lambda"][[1]] == model$lambda.min)]
            all_ROC <- roc(yy, test_probs)
            
            # Plot
            plot(model)

      })
      
      output$text1 <- renderText({
      
            # Load the model
            model = reactive_data()
            
            # Evaluate AUC on test and out-of-sample set
            test_probs <- predict(model, newx = xx, s = "lambda.min", type =  "response")
            test_ROC <- model$cvm[which(model$glmnet.fit["lambda"][[1]] == model$lambda.min)]
            paste0("Gini on a test set = ", round(2*test_ROC-1, 4))
      })
      
      output$text2 <- renderText({
            
            # Load the model
            model = reactive_data()
            
            # Evaluate AUC on test and out-of-sample set
            test_probs <- predict(model, newx = xx, s = "lambda.min", type =  "response")
            all_ROC <- roc(yy, test_probs)
            result <- 2*all_ROC$auc-1 
            paste0("Gini on the whole set = ", round(result, 4))
      })
      
      output$text3 <- renderText({
            
            # Load the model
            model = reactive_data()
            
            # Evaluate AUC on test and out-of-sample set
            test_probs <- predict(model, newx = xx, s = "lambda.min", type =  "response")
            test_ROC <- model$cvm[which(model$glmnet.fit["lambda"][[1]] == model$lambda.min)]
            all_ROC <- roc(yy, test_probs)
            result <- (2*test_ROC-1)/(2*all_ROC$auc-1) 
            paste0("Ratio: Gini(test set)/Gini(the whole set) = ", round(result, 4))
      })
      
  
 })
