---

layout: post
title: Understanding Gradient Boosting Machines
comments: true

---

 ![gbm](/images/gbm.png)

**<u>Why I am writing this</u>**: I have seen this too many times now; while discussing gradient boosting machines that; some ML practitioners; don't really understand what happens under the hood. Very often their understanding of boosting machines, starts with AdaBoost; and then kinda stops there. 

**<u>Who is this best suited for :</u>** If you know what boosting machines are; but lack clarity on what happens under the hood. 

Few things that I have not discussed [so, if you are here for a complete discussion; necessarily including what I have skipped, probably you should save your time and refer to some other source]:

* Relationship between $\eta$ and number of steps [boosted models ]
* In theory, individual models can be anything , but in most implementations you'd find these to be decision trees
* Individual models need to be weak learners 
* **I have not discussed line search** here to find optimal fraction to multiply the predictions from $f_{t+1}$ before adding it to update $F_t$ 

Few mathematical ideas (Anchor Points) that, i will not be elaborating in this post are given; as is, below :

* **<u>Anchor Point 1</u>**: Gradient descent for parametric model requires us to change parameter by this amount in order to reach to the optimal value of cost function; starting at some random value of parameters :
  *   $$\Delta\beta \rightarrow -\eta\frac{\delta C}{\delta\beta}$$  ,  where $$C$$ is the cost function 
* **<u>Anchor Point 2</u>**: Regression Problems
  * Prediction model : $\hat{y}_i = F(X_i)$
  * cost function : $\sum(y_i - F(X_i))^2$
* **<u>Anchor Point 3</u>**: Classification Problems 
  * Prediction model : $p_i =\frac{1}{1+e^{-F(X_i)}}$
  * Other forms of the relationship written above
    * $\frac{p_i}{1-p_i} = e^{F(X_i)}$
    * $log(\frac{p_i}{1-p_i})=F(X_i)$
    * Cost function : $-\sum[ y_i log(p_i)+(1-y_i)log(1-p_i) ]$ 
      * Note : This cost is used for binary classification and is known as -ve log likelihood or binary cross entropy . For multi-class classification a more generic extension of the same; known as  categorical cross-entropy, is used.

We'll refer to these ideas in the post below wherever necessary.

We can start our discussion now about boosting machines . We'll avoid having diagrams as much as we can. [In my opinion, that is another source of this huge misunderstanding. God bless those +,- diagrams of AdaBoost]

### <u>Bagging Methods</u>

Bagging methods ( such as random forest ) make use of multiple individual models in a way that each individual model is independent of others . For example Prediction with bagging method is simply average of predictions coming from n individual predictors

  $$F(X_i) =\sum\limits_{j=1}^{n}f_j(X_i)/n$$

In case of classification instead of $\hat{y_i}$ , this will be predicted probability $p_i$ where $f_j(X_i)$ will be hard class predictions [1/0].

In case of Random Forest, these individual predictors are decision trees . 

### <u>Boosting Methods</u>

In case of boosting machines there are two things which are different :

* First : $F(X_i)= f_1(X_i)+f_2(X_i) ..... f_n(X_i)$

* Second : These individual models are not independent of each other. In fact each subsequent $f_j(X_i)$ tries to improve upon the individual models added thus far. In other words; every subsequent model tries to 'boost' the performance of the model built before it.

### <u>How is $F(X_i)$ built ?</u>

We just said that each $f_j(X_i)$ is added sequentially and it 'boosts' the model built before it. What exactly does this mean ? 

Let's consider that someone [somehow] has built $F(X_i)$ so far with t individual boosted models. We'll represent the overall model also as $F_t(X_i)$ , to track its development . 

$$ F_t(X_i) = f_1(X_i)+f_2(X_i) ....... f_t(X_i)$$

How do we add, next boosted model $f_{t+1}(X_i)$ here to obtain $F_{t+1}(X_i)$ ? 

$F_{t+1}(X_i) = F_t(X_i)+f_{t+1}(X_i)$

following ideas will helps us in understanding what this $f_{t+1}(X_i)$ is going to be

### <u>Gradient Boosting Machines and Cost in functional space</u>

Cost for any kind of predictive problem is function of real values and predictions [or model outcomes]

$$ C = \mathcal{L}(y_i,F_t(X_i))$$



Value of $\mathcal{L}$ for regression and classification is given at the beginning of this post above under anchor points 2 and 3. 

Idea in Anchor Point 1, pertains to parameters. In context of gradient boosting machines; **Key Idea** is that instead of parameter change we are introducing small changes in our model $F_t$ , and this change is the new individual model being added in the sequence, that is $f_{t+1}$ . Following the idea of gradient descent :

$$
f_{t+1} \rightarrow -\eta \frac{\delta C}{\delta F_t}
$$



To be clear , $f_{t+1}$ is a model [ and is being used as a parallel to $\Delta\beta$ ]. It doesn't make sense to say that it 'equals' the quantity on the RHS above. 

It simply means that $f_{t+1}$ will be built as RHS as the target and it will change for each step $t$.

##### **<u>GBM for regression</u>**

For regression , considering sum of squared errors as cost function [ this can be any other exotic cost function too, thats another strength of GBMs; that they can work with custom cost functions as well]

$$C = (y_i -F_t)^{2}$$

`We are not writing Xi explicitly anymore to keep things simpler`
$$
\begin{align}
f_{t+1} &\rightarrow -\eta \frac{\delta C}{\delta F_t} 
\\ &\rightarrow -\eta [-2 *(y_i-F_t)]
\\ &\rightarrow \eta (y_i -F_t)
\end{align}
$$


If you realise, $(y_i - F_t)$ is nothing but error of the model so far . An example with target table should make things clear .

| target for $f_1$ = $y_i$ | Predictions of $f_1$ | target for $f_2$ = $\eta(y_i - f_1)$ | Predictions of $f_2$ | Target for $f_3$ = $\eta(y_i -f_1-f_2)$ |
| ------------------------ | -------------------- | ------------------------------------ | -------------------- | --------------------------------------- |
| $y_1$                    | $a_1$                | $\eta(y_1-a_1)$                      | $b_1$                | $\\\eta(y_1-a_1-b_1)$                   |
| $y_2$                    | $a_2$                | $\eta(y_2-a_2)$                      | $b_2$                | $\eta(y_2-a_2-b_2)$                     |
| $y_3$                    | $a_3$                | $\eta(y_3-a_3)$                      | $b_3$                | $\eta(y_3-a_3-b_3)$                     |

As you can see here , each subsequent individual model is building predictions for the errors which could not be handled by the models so far .

##### **<u>GBM for classification</u>**

It's pretty intuitive and hence clear for regression that subsequent models that we are adding to build $F$ ;  are regression models themselves. 

Unfortunate and wrong extrapolation of the same idea that people end up taking, is that, in GBM for classification; individual models will be classificiation models. Which actually is not the case. [and is at the root of why I am writing this ]

Lets start with cost for binary classification in terms of $F_t$ [We'll be using expressions from Anchor Point 3 to progress things here]
$$
\begin{align}
C &= -\Big[ y_i log(p_i)+(1-y_i)log(1-p_i) \Big]
\\ &= -\Big[ y_i [log(p_i)-log(1-p_i)] + log(1-p_i) \Big]
\\ &= -\Big[ y_ilog(\frac{p_i}{1-p_i}) + log(1-p_i)\Big]
\\ &= -\Big[y_i*F_t + log\Big(1-\frac{1}{1+e^{-F_t}}\Big)\Big]
\\ &= -\Big[y_i*F_t + log\Big(\frac{e^{-F_t}}{1+e^{-F_t}}\Big)\Big]
\\ &= -\Big[y_i*F_t + log\Big(\frac{1}{1+e^{F_t}}\Big)\Big]
\\ &= -\Big[y_i*F_t - log(1+e^{F_t})\Big]
\end{align}
$$


gradient expressions will be as follows : 


$$
\begin{align}
f_{t+1} &\rightarrow -\eta \frac{\delta C}{\delta F_t}
\\ &\rightarrow -\eta \Big[-\Big( y_i - \frac{e^{F_t}}{1+e^F_t}\Big) \Big]
\\ &\rightarrow -\eta \Big[-\Big( y_i - \frac{1}{1+e^{-F_t}}\Big) \Big]
\\ &\rightarrow -\eta \Big[-\Big( y_i - p_i\Big) \Big]
\\ &\rightarrow \eta (y_i-p_i)
\end{align}
$$


Couple of key important details to understand from here 

* $\eta(y_i-p_i)$ , clearly is not a target for a classification model. **Each individual model in GBM for classification is a regression model**

* Probability outcome from $F_t$ is **NOT** simply summation of probability outcomes from $f_1,f_2 ....$ . In fact the relationship is pretty complex as you can see here 

  * $p_t = \frac{1}{1+e^{-F_t}}$
  * $F_{t+1} = F_t + f_{t+1}$
  * $p_{t+1} = \frac{1}{1+e^{-F_{t+1}}} = \frac{p_t}{p_t+(1-p_t)e^{-f_{t+1}}}$ 

I hope this discussion brings some clarity into; how GBMs actually work [ especially for classification ]. 