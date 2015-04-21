## Sequence of execution of scripts

data_processing_routines.R    		## 1. Data Utilities

data_preprocessing.R                ## 2. Data Preprocessing - Cleanup and sampling

build_ngrams.R                      ## 3. Build ngrams

ngrams_prob_MLE.R                   ## 4. NGrams Model  - Conditional Probability (Maximum Likelihood Estimates MLE)

ngram_reduction.R                   ## 5. N-Gram reduction to manage size of the model.

build_test_phrases.R                ## 6. Build Phrases for testing from test data.

evaluate_prediction_MLE.R           ## 7. Accuracy Evaluation of conditional probability using MLE

Predict_Next_Word_MLE.R             ## 8. Prediction Model for MLE evaluation of single word prediction

###### Additional Scripts - MODEL 2 - Rejected as accuracy was lower

ngrams_prob_KN.R                    ## 9. NGrams Rejected Model  - Kneser Ney Smoothing Probability 

evaluate_prediction_KN.R            ## 10. Accuracy Evaluation of Kneser Ney Model

Predict_Next_Word_KN.R              ## 11. Prediction Model for KN probability evaluation of single word prediction