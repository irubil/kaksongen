{smcl}
{hline}
help for {cmd:kaksongen}{right:Marko Ledić, Ivica Rubil and Ivica Urban | December 2022 | v1.0.1}

{hline}

{title:Title}

{phang} {cmd:kaksongen} {hline 2} module to compute the decomposition of the impact of a tax on social welfare, according to {browse "https://link.springer.com/article/10.1007/s10797-022-09752-y":Ledić, Rubil and Urban (2022)} generalisation of the framework developed by 
{browse "https://link.springer.com/article/10.1007/s10888-020-09463-6":Kakwani and Son (2021)}.

{hline}

{title:Syntax}

{phang} {cmd:kaksongen}
{it:xvar tvar} 
[{it:aweight}] 
[{cmd:if} {it:exp}] 
[{cmd:in} {it:range}], 
 {opt alpha(numlist)} 
[{opt rho(real)}
 {opt asvar:iables} 
 {opt nodiv:bytax}
 {opt gr:aph} 
 {it:scatter_options}
 {it:twoway_options}]

{phang}where:

{p 8 15}{it:xvar} - variable representing pre-tax income;

{p 8 15}{it:tvar} - variable representing the tax.

{phang}See {browse "https://link.springer.com/article/10.1007/s10797-022-09752-y":Ledić, Rubil and Urban (2022)} for details.


{phang}{opt by} or {opt bys:ort} may {ul:not} be used with {cmd:kaksongen}; see {help by}.

{phang}{cmd:aweight} are allowed; see {help weights}. 

{hline}

{title:Description}

{pstd}{cmd:kaksongen} computes the decomposition of the impact of a tax on social welfare measured by the S-Gini family of social welfare functions,
where one of the components measures the welfare impact of tax progressivity/regressivity. The package implements the decomposition model of {browse "https://link.springer.com/article/10.1007/s10797-022-09752-y":Ledić, Rubil and Urban (2022)},
which is a generalisation of the framework developed by {browse "https://link.springer.com/article/10.1007/s10888-020-09463-6":Kakwani and Son (2021)}. The generalisation concerns the possibility of computing the decomposition for the whole continuum of intermediate inequality views that lie in between the so-called relative and the so-called absolute inequality views. According to the relative view, the level of inequality does not change if all incomes are changed by the same proportion (i.e., the same percentage); and according to the absolute view, the inequality does not change when all incomes are changed by the same absolute amount. The intermediate views are certain combinations of the relative and absolute views. 

{hline}

{title:Options}
{synoptset 22 tabbed}
{syntab:Required}
{synopt:{opt alpha(numlist)}}specifies the values of alpha. The maximum number of values is 101.{p_end}

{syntab:Not required}
{synopt:{opt rho(#)}}specifies the value of the S-Gini parameter rho > 1. If not specified, the default value of 2 is applied.{p_end}
{synopt:{opt asvar:iables}}requests that the computed statistics, provided in stored results as a matrix r(results), be provided as variables as well. The variable names are the same as the matrix rows{p_end}
{synopt:{opt nodiv:bytax}}requests that the decompostion be not divided through by the mean tax. This means that the welfare loss will be measured in dollars, rather than in dollars per dollar of tax revenue.{p_end}
{synopt:{opt gr:aph}}requests that DeltaW, N_alpha, P_alpha, and H (see below under Stored results) be plotted. This option may be used only if the option {opt asvar:iables} is specified.{p_end}
{synopt:{opt drop}}requests that the variables generated by the option {opt asvar:iables} be dropped automatically. It is useful if you specified {opt asvar:iables} just to be able to specify the option {opt gr:aph}.{p_end}
{synopt:{it:scatter_options}}refers to options of {help twoway_scatter}; ignored if the option {opt gr:aph} is not specified.{p_end}
{synopt:{it:twoway_options}}refers to {help twoway_options}; ignored if the option {opt gr:aph} is not specified. 

{hline}

{title:Examples}

{pstd}A hypothetical population has 1000 persons who live in two regions.{p_end}
{phang}. {stata clear}{p_end}
{phang}. {stata set obs 1000}{p_end}
{phang}. {stata gen region = 1}{p_end}
{phang}. {stata replace region = 2 if _n / 2 == round(_n / 2)}{p_end}
{phang}. {stata set seed 4231}{p_end}
{phang}. {stata gen X = 5000 * exp(rnormal(1, 0.7))}{p_end}
{phang}. {stata sort X}{p_end}

{pstd}Net tax (T) is the difference between gross tax (GT) and tax credit (TC). To obtain gross tax, the rates 0%, 30% and 60% are applied to the portions of income below $10,000, between $10,000 and $20,000, and beyond $20,000, respectively. Tax credit equals 100% of gross tax and is obtained by all people from region 2.{p_end}
{phang}. {stata gen GT = 0.0 * min(X, 10000) + 0.3 * min(max(X - 10000, 0), 20000 - 10000) + 0.6 * max(X - 20000, 0)}{p_end}
{phang}. {stata gen TC = (region == 2) * GT}{p_end}
{phang}. {stata gen T = GT - TC}{p_end}

{pstd}Calculate decomposition for alpha = 0, 0.1, ..., 1:{p_end}
{phang}. {stata kaksongen X T, alpha(0(.1)1)}{p_end}

{pstd}The same decomposition, but with results provided as variables:{p_end}
{phang}. {stata kaksongen X T, alpha(0(.1)1) asvar}{p_end}

{pstd}The same decomposition, but without division by the average tax:{p_end}
{phang}. {stata kaksongen X T, alpha(0(.1)1) nodiv}{p_end}

{pstd}The same decomposition, but with deltaW, N(alpha), P(alpha), and H plotted:{p_end}
{phang}. {stata kaksongen X T, alpha(0(.1)1) asvar gr ti("Decomposition")}{p_end}

{hline}

{title:Stored results}
{synoptset 15 tabbed}
{syntab:Macros}
{synopt:{bf:r(tvar)}}name of the tax variable (see syntax){p_end}
{synopt:{bf:r(xvar)}}name of the pre-tax income variable (see syntax){p_end}
{synopt:{bf:r(cmd)}}full command issued by the user{p_end}
{synopt:{bf:r(alpha)}}list of alphas specified (see options){p_end}
{synopt:{bf:r(rho)}}S-Gini parameter specified (see options){p_end}

{syntab:Matrices}
{synopt:{bf:r(results)}}20-by-N matrix of results, where N is the number of values of alpha specified.
The names of the 20 statistics can be easily mapped to the notation in {browse "https://link.springer.com/article/10.1007/s10797-022-09752-y":Ledić, Rubil and Urban (2022)}. From the top row downwards,
the statistics are: alpha, rho, DeltaW, N_alpha, P_alpha, H, delta_alpha, pi_alpha, eta_alpha, alpha_zero, tau, tau_star_alpha, 
tau_over_tau_star_alpha, Gx, Gy, Dy, Dt, mux, muy, mut. Some of these vary by alpha, while some are fixed.{p_end}

{hline}

{title:Latest version}

{phang}
The latest version of {cmd:kaksongen} is available {browse "https://github.com/irubil/kaksongen":here} or {browse "https://github.com/MarkoLedic/kaksongen":here}.

{hline}

{title:Required packages}

{phang}{cmd:sgini} by Philippe Van Kerm. Available at SSC; see {browse "https://ideas.repec.org/c/boc/bocode/s458778.html":here}.

{hline}

{title:Authors}

{phang}Marko Ledić, Faculty of Economics and Business, University of Zagreb, markoledic@gmail.com{p_end}
{phang}Ivica Rubil, The Institute of Economics, Zagreb, irubil@gmail.com{p_end}
{phang}Ivica Urban, Institute of Public Finance, Zagreb, urbanivica@gmail.com{p_end}

{pstd}If you have a question on the current version, or have an idea of how to improve it, or you encounter a bug, please write us at any of the e-mail addressed above.

{pstd}Please cite the package as follows: Ledić, M., Rubil, I. & Urban, I. (2022). kaksongen: Stata module for computing the decomposition of the social welfare impact of taxation [Stata package]. {browse "https://github.com/irubil/kaksongen"} 

{hline}

{title:References}

{phang}Kakwani, N., & Son, H. H. (2021). {browse "https://link.springer.com/article/10.1007/s10888-020-09463-6":Normative Measures of Tax Progressivity: an International Comparison.} {it:Journal of Economic Inequality}, 19(1), 185–212.{p_end} 
{phang}Ledić, M., Rubil, I. & Urban, I. (2022). {browse "https://link.springer.com/article/10.1007/s10797-022-09752-y":Tax progressivity and social welfare with a continuum of inequality views.} {it: International Tax and Public Finance.}

{hline}

{title:Acknowledgements}

{pstd} Creation of this package has been fully supported by the Croatian Science Foundation under the project “Impact of taxes and benefits on income distribution and economic efficiency” (ITBIDEE) (IP-2019-04-9924).


