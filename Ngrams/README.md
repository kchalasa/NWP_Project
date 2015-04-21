## Sequence of execution of scripts

data_processing_routines.R    		&nbsp;&nbsp;## 1. Data Utilities

data_preprocessing.R                &nbsp;&nbsp;## 2. Data Preprocessing - Cleanup and sampling

build_ngrams.R                      &nbsp;&nbsp;## 3. Build ngrams

ngrams_prob_MLE.R                   &nbsp;&nbsp;## 4. NGrams Model  - Conditional Probability (Maximum Likelihood Estimates MLE)

ngram_reduction.R                   &nbsp;&nbsp;## 5. N-Gram reduction to manage size of the model.

build_test_phrases.R                &nbsp;&nbsp;## 6. Build Phrases for testing from test data.

evaluate_prediction_MLE.R           &nbsp;&nbsp;## 7. Accuracy Evaluation of conditional probability using MLE

Predict_Next_Word_MLE.R             &nbsp;&nbsp;## 8. Prediction Model for MLE evaluation of single word prediction

###### Additional Scripts - MODEL 2 - Rejected as accuracy was lower

ngrams_prob_KN.R                    &nbsp;&nbsp;## 9. NGrams Rejected Model  - Kneser Ney Smoothing Probability 

evaluate_prediction_KN.R            &nbsp;&nbsp;## 10. Accuracy Evaluation of Kneser Ney Model

Predict_Next_Word_KN.R              &nbsp;&nbsp;## 11. Prediction Model for KN probability evaluation of single word prediction