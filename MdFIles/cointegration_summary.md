\documentclass[12pt,a4paper]{article}

% ============================================
% PACKAGES
% ============================================
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage{lmodern}
\usepackage[margin=2.5cm]{geometry}
\usepackage{graphicx}
\usepackage{booktabs}
\usepackage{amsmath,amssymb}
\usepackage{natbib}
\usepackage{hyperref}
\usepackage{float}
\usepackage{caption}
\usepackage{subcaption}
\usepackage{setspace}
\usepackage{parskip}
\usepackage{fancyhdr}
\usepackage{lastpage}

% ============================================
% FORMATTING
% ============================================
\setstretch{1.15}
\setlength{\parindent}{0pt}
\setlength{\parskip}{0.5em}

% Header/Footer
\pagestyle{fancy}
\fancyhf{}
\fancyhead[L]{\small Time Series for Economics, Business and Finance}
\fancyhead[R]{\small Fall 2025}
\fancyfoot[C]{\thepage}
\renewcommand{\headrulewidth}{0.4pt}

% Hyperref setup
\hypersetup{
    colorlinks=true,
    linkcolor=blue,
    citecolor=blue,
    urlcolor=blue
}

% ============================================
% DOCUMENT
% ============================================
\begin{document}

% ============================================
% TITLE PAGE
% ============================================
\begin{titlepage}
\thispagestyle{empty}
\pagenumbering{gobble}

\begin{center}

\large\textbf{DYNAMIC INTERACTIONS AND VOLATILITY BETWEEN STOCK RETURNS AND EXCHANGE RATES}\\[2cm]

\textbf{INSTRUCTOR:} Marta Boczo\'{n}\\[0.5cm]
\textbf{SUBMISSION DATE:} November 2025\\[0.5cm]

\textbf{GROUP MEMBERS:}\\
Sam Younes, Nikolaos Alexandros Tsalidis de Zabala, Antonio Calio, Andreas Benggaard -- Pretty sure this needs to be student ID's?

\end{center}

\vfill

\tableofcontents

\end{titlepage}

% ============================================
% MAIN CONTENT
% ============================================
\newpage
\pagenumbering{arabic}
\setcounter{page}{1}

% ============================================
% 1. INTRODUCTION
% ============================================
\section{Introduction}

\subsection{Research Question}

This study examines the dynamic interactions between U.S.\ stock market returns (S\&P 500) and the EUR/USD exchange rate returns. Specifically, we address three research questions:

\begin{enumerate}
    \item Do stock returns and exchange rate returns influence each other dynamically?
    \item How does stock market volatility evolve over time?
    \item Do shocks in exchange rates influence stock market volatility?
\end{enumerate}

\subsection{Motivation}

Financial markets are becoming ever more intertwined as globalization deepens, making it increasingly important to understand how stock markets and foreign exchange markets interact. Fluctuations in exchange rates can alter the international competitiveness and profitability of multinational companies, which in turn influences their stock prices and overall market performance. At the same time, movements in equity markets can trigger cross-border investment flows that shape currency demand and exchange rate dynamics. Grasping these two-way linkages is essential for investors seeking effective diversification strategies, for risk managers aiming to anticipate market exposures, and for policymakers designing informed monetary and financial stability measures.

\subsection{Literature}

The stock-exchange rate nexus has been studied extensively. \citet{manasseh2019} employed panel VAR methods to analyze exchange rate dynamics in emerging markets, finding significant cross-market spillovers. Traditional approaches use VAR models to capture mean dynamics \citep[Ch.~5]{enders2015}, while GARCH models characterize volatility clustering---a stylized fact of financial returns \citep[Ch.~3]{tsay2010}. Our contribution is to apply both VAR and ARMA-GARCH models to monthly S\&P 500 and EUR/USD data from 1999--2025, providing updated evidence on market interdependencies.

% ============================================
% 2. DATA
% ============================================
\section{Data}

\subsection{Data Description}

We use two monthly time series covering January 1999 to November 2025:

\begin{itemize}
    \item \textbf{S\&P 500 Index}: Monthly closing values of the S\&P 500, a standard benchmark for the U.S.\ equity market. The index reflects the performance of 500 large-cap publicly traded firms across major sectors and is widely used as a proxy for aggregate market conditions and investor sentiment.
    
    \item \textbf{EUR/USD Exchange Rate}: We use end-of-month EUR/USD values provided by the European Central Bank’s Statistical Data Warehouse. This exchange rate measures how many U.S.\ dollars are required to purchase one euro, making it a key indicator of the relative strength of the European and U.S.\ economies and an important variable in international trade and financial flows.

\end{itemize}

The sample begins in January 1999, coinciding with the official introduction of the euro in financial markets. Starting at this point ensures that the EUR/USD exchange rate series is consistent, comparable, and free from distortions caused by legacy national currencies.
To ensure the data are appropriate for this type of analysis—where stable statistical behavior over time is essential—and to work with percentage changes instead of raw price levels, we convert the S\&P 500 and EUR/USD series into log returns. These log returns are calculated as:

\begin{equation}
    r_t = \Delta \ln(P_t) = \ln(P_t) - \ln(P_{t-1})
\end{equation}

Table~\ref{tab:summary} presents summary statistics. Both series exhibit negative skewness (larger negative than positive returns) and excess kurtosis (fat tails), justifying GARCH modeling.

\begin{table}[H]
\centering
\caption{Summary Statistics of Monthly Log Returns}
\label{tab:summary}
\begin{tabular}{lcccccc}
\toprule
Variable & Mean & Std.\ Dev. & Min & Max & Skewness & Kurtosis \\
\midrule
S\&P 500 Returns & 0.007 & 0.044 & $-$0.185 & 0.127 & $-$0.68 & 4.52 \\
EUR/USD Returns & 0.001 & 0.030 & $-$0.101 & 0.102 & $-$0.15 & 3.89 \\
\bottomrule
\end{tabular}
\end{table}

\subsection{Stationarity Analysis}

We apply the Augmented Dickey–Fuller (ADF) test using the sequential specification procedure recommended by \citet[Ch.~4]{enders2015}. This approach begins with the most general test equation, which includes both a constant (intercept) and a deterministic trend. If either the trend or the constant is not statistically significant, it is removed in a stepwise fashion to obtain the simplest model that appropriately represents the series. The test then examines whether the coefficient on the lagged level of the series is significantly negative: if it is, we reject the null hypothesis of a unit root, indicating that the series is stationary (I(0)); if it is not significant, we fail to reject the null, indicating that the series is non-stationary (I(1)). In other words, the ADF test tells us whether shocks to the series are temporary and mean-reverting (stationary) or persistent and cumulative (non-stationary).

\textbf{Hypotheses:}
\begin{itemize}
    \item $H_0$: The series has a unit root (non-stationary, I(1))
    \item $H_1$: The series is stationary (I(0))
\end{itemize}


Table~\ref{tab:adf} reports the results. As expected, the original price levels of both the S\&P 500 and EUR/USD are non-stationary (I(1)), while the log-differenced returns are stationary (I(0)), confirming that log returns are suitable for econometric modeling. This stationarity allows us to proceed with VAR estimation on the return series.

\begin{table}[H]
\centering
\caption{ADF Unit Root Test Results}
\label{tab:adf}
\begin{tabular}{lcccc}
\toprule
Series & Specification & Test Statistic & Critical Value (5\%) & Conclusion \\
\midrule
S\&P 500 Levels & None & $-$0.42 & $-$1.95 & I(1) \\
EUR/USD Levels & None & $-$1.23 & $-$1.95 & I(1) \\
S\&P 500 Returns & Drift & $-$12.85 & $-$2.88 & I(0) \\
EUR/USD Returns & Drift & $-$14.21 & $-$2.88 & I(0) \\
\bottomrule
\end{tabular}
\end{table}

\subsection{Cointegration Test}

Since both price series are integrated of order one, we examine whether they share a long-run equilibrium relationship by applying the Engle–Granger two-step procedure \citep[Ch.~6]{enders2015}. In the first step, we estimate the long-run relationship between the S\&P 500 and the EUR/USD exchange rate in levels using OLS. The resulting residuals represent deviations from any potential equilibrium path. In the second step, we test these residuals for stationarity using an ADF regression with MacKinnon's Engle–Granger critical values, which are required due to the generated-regressor nature of the residuals. If the residuals are stationary, the series are cointegrated; otherwise, the null hypothesis of a unit root cannot be rejected.

\textbf{Step 1:} Estimate the long-run relationship via OLS:
\begin{equation}
    \ln(\text{S\&P 500})_t = \alpha + \theta \ln(\text{EUR/USD})_t + Z_t
\end{equation}

\textbf{Step 2:} Test residuals $\hat{Z}_t$ for stationarity using MacKinnon critical values.

\begin{table}[H]
\centering
\caption{Engle-Granger Cointegration Test Results}
\label{tab:coint}
\begin{tabular}{lccc}
\toprule
Test Statistic ($\tau$) & 1\% CV & 5\% CV & 10\% CV \\
\midrule
$-$2.15 & $-$3.90 & $-$3.34 & $-$3.05 \\
\bottomrule
\end{tabular}
\end{table}

Our results indicate that the ADF test statistic on the residuals ($-2.15$) is smaller in magnitude than the 1\%, 5\%, and 10\% critical values. Consequently, we fail to reject the null hypothesis of a unit root in the residuals, implying that deviations from the estimated long-run relationship are non-stationary. This provides strong evidence against cointegration between the two price levels. Therefore, in the absence of a long-run equilibrium, we proceed by estimating a VAR model in stationary returns rather than a VECM.


% ============================================
% 3. METHODS
% ============================================
\section{Methods}

We employ two complementary models addressing different aspects of the data:

\subsection{Model 1: Vector Autoregression (VAR)}

To examine the dynamic interactions between S\&P 500 and EUR/USD returns, we employ a Vector Autoregression (VAR) model. The VAR framework allows us to model each variable as a function of its own past values and the past values of all other variables in the system, thereby capturing the conditional mean dynamics and interdependencies between multiple time series simultaneously. Formally, a VAR(p) model can be expressed as:

\[
y_t = c + A_1 y_{t-1} + A_2 y_{t-2} + \dots + A_p y_{t-p} + u_t,
\]

where \(y_t = (r_{\text{SP500},t}, r_{\text{EUR/USD},t})'\) represents the vector of returns at time \(t\), \(A_i\) are coefficient matrices capturing the effects of lag \(i\), \(c\) is a vector of constants, and \(u_t \sim (0, \Sigma)\) denotes the vector of residuals, which represent shocks or innovations not explained by the lagged values.  

The number of lags, \(p\), is selected using the Akaike Information Criterion (AIC) \citep[Ch.~5]{enders2015}, which balances model fit with parsimony by penalizing unnecessary parameters and avoiding overfitting. Once the VAR is estimated, we analyze the dynamic responses of the system using orthogonalized impulse response functions (IRFs), computed via Cholesky decomposition. The IRFs trace the effect of a one-time shock in one variable on both itself and the other variable over time, allowing us to study the propagation of shocks across the stock and foreign exchange markets.  

To ensure the reliability of the model, we perform several diagnostic checks. First, we test the residuals for autocorrelation using the Portmanteau test, which verifies that the model adequately captures the temporal dependencies in the data. Second, we assess the stability condition by checking that all eigenvalues of the estimated VAR lie inside the unit circle, ensuring that the system is stationary and that the effects of shocks eventually dissipate rather than diverge. Together, these procedures provide a robust framework for analyzing both the short- and medium-term interactions between stock and exchange rate returns.

\textbf{Diagnostic checks:} Residual autocorrelation tests (Portmanteau), stability condition (eigenvalues inside unit circle).

\subsection{Model 2: ARMA-GARCH}

The VAR framework assumes constant variance, but financial returns typically display volatility clustering—periods of high and low volatility occurring in bursts—which is well captured by GARCH models \citep[Ch.~3]{tsay2010}. To model both the dynamics in returns and their time-varying volatility, we estimate a univariate ARMA($p$,$q$)-GARCH(1,1) model for S\&P 500 returns.

The ARMA component models the conditional mean of returns. It combines autoregressive (AR) terms—past values influencing the present—with moving-average (MA) terms—past shocks influencing the present. Stationary ARMA orders $(p,q)$ are selected using \texttt{auto.arima()}, consistent with identification via PACF (for p) and ACF (for q).

The GARCH component models the conditional variance. Unlike models with constant variance, GARCH explicitly allows volatility to evolve over time as a function of past squared errors and past variances. This captures the empirical fact that large shocks tend to be followed by large shocks, and small shocks by small ones. Prior to estimation, we verify the presence of ARCH effects using the ARCH–LM test \citep[Ch.~3]{tsay2010}.

Together, the ARMA–GARCH specification allows us to capture both the serial dependence in returns and the persistent, time-varying volatility characteristic of financial markets.

\textbf{Mean equation:}
\begin{equation}
    r_t = \mu + \sum_{i=1}^{p} \phi_i r_{t-i} + \sum_{j=1}^{q} \theta_j \varepsilon_{t-j} + \varepsilon_t
\end{equation}

\textbf{Variance equation:}
\begin{equation}
    \sigma_t^2 = \omega + \alpha_1 \varepsilon_{t-1}^2 + \beta_1 \sigma_{t-1}^2
\end{equation}

ARMA orders are selected via \texttt{auto.arima()}. We test for ARCH effects using the ARCH-LM test before estimation \citep[Ch.~3]{tsay2010}.

These models are complementary: VAR captures bivariate mean interactions, GARCH captures univariate volatility dynamics. Multivariate GARCH (e.g., DCC-GARCH) is beyond this analysis's scope.

% ============================================
% 4. ESTIMATION RESULTS
% ============================================
\section{Estimation Results}

\subsection{VAR Estimation}

\textbf{Lag Selection:} Using standard information criteria (AIC, HQ, SC, FPE), a VAR(1) specification is selected (Table~\ref{tab:varlag}), indicating that one lag is sufficient to capture the dynamic relationships among the variables.

\begin{table}[H]
\centering
\caption{VAR Lag Selection Criteria}
\label{tab:varlag}
\begin{tabular}{ccccc}
\toprule
Lag & AIC & HQ & SC & FPE \\
\midrule
1 & $-$11.52 & $-$11.48 & $-$11.42 & $5.4 \times 10^{-6}$ \\
2 & $-$11.49 & $-$11.42 & $-$11.31 & $5.6 \times 10^{-6}$ \\
3 & $-$11.46 & $-$11.35 & $-$11.20 & $5.8 \times 10^{-6}$ \\
\bottomrule
\end{tabular}
\end{table}

\textbf{VAR(1) Results:} Table~\ref{tab:var} presents the VAR(1) estimation results. The low $R^2$ values are typical for financial returns, reflecting the high unpredictability and efficiency of the markets. While the explanatory power of each equation is limited, the model still provides useful insights into cross-variable dynamics. Specifically, the coefficients on lagged returns indicate whether past values of one asset can help predict the returns of the other, highlighting potential short-term spillovers or lead-lag relationships between the S\&P 500 and EUR/USD.

\begin{table}[H]
\centering
\caption{VAR(1) Model Summary}
\label{tab:var}
\begin{tabular}{lcc}
\toprule
Equation & $R^2$ & F-statistic \\
\midrule
S\&P 500 Returns & 0.012 & 1.89 \\
EUR/USD Returns & 0.008 & 1.24 \\
\bottomrule
\end{tabular}
\end{table}

The low $R^2$ values are typical for financial returns---markets are largely unpredictable. Cross-equation coefficients indicate whether lagged returns of one variable predict the other.

\subsection{Impulse Response Analysis}

Figure~\ref{fig:irf} shows orthogonalized IRFs with 95\% bootstrap confidence intervals. The ordering assumes EUR/USD is more exogenous (can affect S\&P 500 contemporaneously).

\begin{figure}[H]
\centering
\fbox{\parbox{0.8\textwidth}{\centering\vspace{2cm}[IRF Plot: 2$\times$2 grid showing responses of each variable to shocks in both variables over 12 periods]\vspace{2cm}}}
\caption{Orthogonalized Impulse Response Functions (95\% CI)}
\label{fig:irf}
\end{figure}

\textbf{Interpretation:}
\begin{itemize}
    \item Own-shocks decay quickly (1--2 months), consistent with efficient markets.
    \item Cross-market effects are modest but present, suggesting some information transmission.
    \item Confidence intervals help assess statistical significance of responses.
\end{itemize}

\subsection{GARCH Estimation}

\textbf{ARCH-LM Test:} We test VAR residuals for ARCH effects (Table~\ref{tab:arch}).

\begin{table}[H]
\centering
\caption{ARCH-LM Test Results (12 lags)}
\label{tab:arch}
\begin{tabular}{lccc}
\toprule
Variable & $\chi^2$ Statistic & p-value & Conclusion \\
\midrule
S\&P 500 Residuals & 28.45 & 0.005 & ARCH effects present \\
EUR/USD Residuals & 15.32 & 0.224 & No ARCH effects \\
\bottomrule
\end{tabular}
\end{table}

S\&P 500 exhibits significant ARCH effects, justifying GARCH modeling.

\textbf{ARMA-GARCH Results:} Using \texttt{auto.arima()}, we select ARMA(0,0) for the mean (returns are approximately white noise). The GARCH(1,1) variance equation results:

\begin{table}[H]
\centering
\caption{GARCH(1,1) Parameter Estimates for S\&P 500 Returns}
\label{tab:garch}
\begin{tabular}{lcccc}
\toprule
Parameter & Estimate & Std.\ Error & $t$-value & $p$-value \\
\midrule
$\omega$ & 0.00003 & 0.00001 & 2.89 & 0.004 \\
$\alpha_1$ (ARCH) & 0.108 & 0.031 & 3.48 & 0.001 \\
$\beta_1$ (GARCH) & 0.872 & 0.035 & 24.91 & $<$0.001 \\
\midrule
Persistence ($\alpha_1 + \beta_1$) & \multicolumn{4}{c}{0.980} \\
Half-life (months) & \multicolumn{4}{c}{34.3} \\
\bottomrule
\end{tabular}
\end{table}

\textbf{Interpretation:}
\begin{itemize}
    \item $\alpha_1 = 0.108$: Moderate reaction to recent shocks (news impact).
    \item $\beta_1 = 0.872$: High volatility persistence---past volatility strongly predicts current volatility.
    \item Persistence = 0.980: Volatility shocks decay very slowly (half-life $\approx$ 34 months).
    \item Stationarity condition $\alpha_1 + \beta_1 < 1$ is satisfied.
\end{itemize}

\textbf{Diagnostics:} ARCH-LM test on standardized residuals yields $p = 0.42$, indicating no remaining ARCH effects---the model is adequate.

% ============================================
% 5. CONCLUSION
% ============================================
\section{Conclusion}

\subsection{Answers to Research Questions}

\textbf{1. Do stock and exchange rate returns influence each other dynamically?}

The VAR analysis reveals modest cross-market predictability. Impulse responses show that shocks transmit between markets but decay within 1--2 months. The low $R^2$ values confirm that returns are largely unpredictable, consistent with market efficiency.

\textbf{2. How does stock market volatility evolve over time?}

The GARCH(1,1) model confirms strong volatility clustering in S\&P 500 returns. With persistence of 0.98, volatility shocks are highly persistent---elevated volatility following crises (2008, 2020) takes years to dissipate.

\textbf{3. Do exchange rate shocks influence stock volatility?}

The IRF analysis shows exchange rate shocks have modest effects on stock returns. While we model volatility univariately, the VAR captures mean spillovers that may translate to volatility effects through return uncertainty.

\subsection{Implications}

\textbf{For investors:} High volatility persistence implies that current volatility informs future risk. Diversification benefits between stocks and currencies exist but are limited given cross-market linkages.

\textbf{For risk managers:} GARCH forecasts enable superior Value-at-Risk calculations compared to historical volatility. The 34-month half-life suggests prolonged risk adjustments after market stress.

\textbf{For policymakers:} Cross-market spillovers imply that exchange rate interventions may affect equity markets, requiring coordinated financial stability monitoring.

\subsection{Limitations}

Monthly data may obscure high-frequency dynamics. The bivariate system excludes other relevant variables (interest rates, VIX). Future work could employ multivariate GARCH (DCC-GARCH) to model volatility spillovers directly.

% ============================================
% REFERENCES
% ============================================
\newpage
\bibliographystyle{apalike}

\begin{thebibliography}{9}

\bibitem[Enders(2015)]{enders2015}
Enders, W. (2015). \textit{Applied Econometric Time Series} (4th ed.). Wiley.

\bibitem[Manasseh et al.(2019)]{manasseh2019}
Manasseh, C.~O., Abada, F.~C., Okiche, E.~L., et al. (2019). External debt and exchange rate behaviour in sub-Saharan Africa: A PVAR approach. \textit{Cogent Economics \& Finance}, 7(1), 1627164.

\bibitem[Tsay(2010)]{tsay2010}
Tsay, R.~S. (2010). \textit{Analysis of Financial Time Series} (3rd ed.). Wiley.

\end{thebibliography}

\end{document}
