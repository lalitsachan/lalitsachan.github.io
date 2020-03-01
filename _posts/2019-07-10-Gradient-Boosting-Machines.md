---

layout: post
title: Understanding Gradient Boosting Machines : GBM to Xgboost to LightGBM/CatBoost
comments: true

---

I have seen this too many times now; while discussing gradient boosting machine that people dont really understand what happens under the hood. Very often their understanding of boosting machines starts with AdaBoost and then kinda stops there. Few mathematical ideas that i will not be elaborating in this post are given as is below :

* Gradient descent for paramteric model requires us to change parameter by this amount in order to reach to the optimal value of cost function; starting at some random value of parameters : $$\Delta\beta \rightarrow -\eta\frac{\delta f}{\delta\beta}$$ , where $f$ is the cost function 
* Regression Problems
  * Prediciton model : $\hat{y}_i = f(X_i)$
  * cost function : $\sum(y_i - f(X_i))^2$
* Classification Problems 
  * Prediction model : $p_i =\frac{1}{1+e^{-f(X_i)}}$
  * Other forms of the relationship written above
    * $\frac{p_i}{1-p_i} = e^{f(X_i)}$
    * $log(\frac{p_i}{1-p_i})=f(X_i)$
    * Cost function : $-[\sum y_i log(p_i)+(1-y_i)log(1-p_i) ]$ 
      * Note : This cost is used for binary classification and is known as -ve log likelihood or binary cross entropy . For multiclass classification a more generic extension of the same; known as  categorical crossentropy, is used.

We can start our discussion now about boosting machines 

