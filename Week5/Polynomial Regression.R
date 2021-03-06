library(ISLR)
attach(Wage)

dim(Wage)
names(Wage)
range(age)

# Fit a polynomial regression model
  # poly( , 3) returns an n-by-3 matrix: each column has mean zero and 
  # sample variance 1, and they are orthogonal to each other. The 1st column 
  # is a linear combination of age and intercept, the 2nd column is a linear 
  # combination of age^2, age, and intercept, and the 3rd column is a linear 
  # combination of age^3, age^2, age, and intercept.
tmp = poly(age, 3)
dim(tmp)
colMeans(tmp)
round(t(tmp) %*% tmp, dig=4)

fit = lm(wage ~ poly(age, 3), data = Wage)
round(summary(fit)$coef, dig = 3)

  # Alternatively we can use the default design matrix where the j-th column 
  # corresponds to age^j.
fit2 = lm(wage ~ age + I(age^2) + I(age^3), data=Wage)
round(summary(fit2)$coef, dig = 3)

  # The default design matrix can also be generated by poly
  # with option raw = TRUE. 
  # fit3 should return the same set of coefficients as fit2
fit3 = lm(wage ~ poly(age, 3, raw = T), data = Wage)
round(summary(fit2)$coef, dig = 3)

  # Note that although the coefficients from fit and the ones from fit2 are 
  # different, the t-value and p-value for the last predictor are always the same.
  # Different ways to fit a polynomial regression model in R. The coefficients 
  # might not be the same but the fitted curves are the same.
predict(fit, newdata = list(age=82))
predict(fit2, newdata = list(age=82))

  # The fitted curve from the all three models should be the same.
agelims = range(age)
age.grid = seq(from = agelims[1], to = agelims[2])
preds = predict(fit, newdata = list(age = age.grid), se=TRUE)
plot(age, wage, xlim = agelims, pch = '.', cex = 2, col="darkgrey")
title("Degree -3 Polynomial ")
lines(age.grid, preds$fit, lwd=2, col="blue")

# Forward Selection on d
  # Forward selection for the polynomial order d based on the significance of 
  # the coefficient of the highest order starting with quardratic polynomial 
  # function, and we finally pick d=3.
summary(lm(wage ~ poly(age, 2), data=Wage))$coef
summary(lm(wage ~ poly(age, 3), data=Wage))$coef
summary(lm(wage ~ poly(age, 4), data=Wage))$coef

# Backward Selection on d
  # Back selection for the polynomial order d based on the significance of 
  # the coefficient of the highest order starting with d=6, and we finally 
  # pick d=3. For this data, the forward and the backward approaches happen 
  # to pick the same d value, but in general, the two choices (backward or forward) 
  # for d could differ.
summary(lm(wage ~ poly(age, 6), data=Wage))$coef
summary(lm(wage ~ poly(age, 5), data=Wage))$coef
summary(lm(wage ~ poly(age, 4), data=Wage))$coef
summary(lm(wage ~ poly(age, 3), data=Wage))$coef
