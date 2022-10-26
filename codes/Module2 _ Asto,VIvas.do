/*------------------------------------------------------------------------------
					   TRABAJO CALIFICADO - MODULO 2
				Econometría Avanzada: Corte Transversal y Panel

* Integrantes: 
	- Claudia Vivas ()
	- Rosmery Asto ()
------------------------------------------------------------------------------*/

clear all
cls

global data "C:\Users\c3318\OneDrive\2022-2\Econometria avanzada Corte transversal y panel\Modulo 2\trabajo calificado"
global tabla "C:\Users\c3318\Dropbox\Aplicaciones\Overleaf\Tarea calificada - modulo 2"

use "$data\acemoglu_2001.dta", clear
merge 1:1 shortnam using "$data\paises.dta", nogen
drop if asia==. & africa ==.

gen america = (Continente=="América")
gen other = (asia==0 & africa==0 & america==0) 

drop Continente País


	* etiquetas
	label variable euro1900 "European settlements in 1900"
	label variable cons00a "Constraint on executive in 1900"
	label variable democ00a "Democracy in 1900"
	label variable cons1 "Constraint on executive in first year of independence"
	label variable democ1 "Democracy in first year of independence"
	label variable avexpr "Average protection against expropiation risk, 1985-1995"
	label variable lat_abst "Latitude"
	label variable logpgp95 "Log GDP per capita (PPP) in 1995"
	label variable asia "Asia dummy"
	label variable africa "Africa dummy"
	label variable other "Other continent dummy"


* PREGUNTA A: Replicar Tabla 2
*------------
	eststo clear
	
	* Whole world (1)
	quietly reg logpgp95 avexpr
	eststo ols_1

	* Base Sample (2)
	quietly reg logpgp95 avexpr if baseco==1
	eststo ols_2

	* Whole world (3)
	quietly reg logpgp95 avexpr lat_abst
	eststo ols_3

	* Whole world (4)
	quietly reg logpgp95 avexpr lat_abst asia africa other
	eststo ols_4

	* Base Sample (5)
	quietly reg logpgp95 avexpr lat_abst if baseco==1
	eststo ols_5

	* Base Sample (6)
	quietly reg logpgp95 avexpr lat_abst asia africa other if baseco==1
	eststo ols_6

	*Agrupando los resultados de las regresiones en una tabla
	esttab using "$tabla/tabla2.tex", replace nocon b(2) se(2) r2(2) nomtitle  ///
	star(* 0.10 ** 0.05 *** 0.01) booktabs alignment(D{.}{.}{-1}) ///
	title(OLS Regressions\label{tabla2}) ///
	addnotes("Dependent variable: Log GDP per capita in 1995")
	
* PREGUNTA C: Replicar Tabla 4
*------------

* PANEL A
	eststo clear

	* Base Sample (1)
	quietly ivreg logpgp95 (avexpr = logem4) if baseco==1
	eststo iv_1

	* Base Sample (2)
	quietly ivreg logpgp95 lat_abst (avexpr = logem4) if baseco==1
	eststo iv_2

	* Base Sample without Neo-Europes (3)
	quietly ivreg logpgp95 (avexpr = logem4) if baseco==1 & rich4==0
	eststo iv_3

	* Base Sample without Neo-Europes (4)
	quietly ivreg logpgp95 lat_abst (avexpr = logem4) if baseco==1 & rich4==0
	eststo iv_4

	* Base Sample without Africa (5)
	quietly ivreg logpgp95 (avexpr = logem4) if baseco==1 & africa==0
	eststo iv_5

	* Base Sample without Africa (6)
	quietly ivreg logpgp95 lat_abst (avexpr = logem4) if baseco==1 & africa==0
	eststo iv_6

	* Base Sample with continent dummies (7)
	quietly ivreg logpgp95 asia africa other (avexpr = logem4) if baseco==1
	eststo iv_7

	* Base Sample with continent dummies (8)
	quietly ivreg logpgp95 lat_abst asia africa other (avexpr = logem4) if baseco==1
	eststo iv_8

esttab using "$tabla/panel_a.doc", replace nocon b(2) se(2) nomtitle label  ///
star(* 0.10 ** 0.05 *** 0.01) booktabs alignment(D{.}{.}{-1}) ///
title(Panel A: Two-Stage Least Squares \label{panela}) ///
addnotes("Dependent variable: Log GDP per capita in 1995")

* PANEL B
	
	eststo clear

	* Base Sample (1)
	quietly reg avexpr logem4 if baseco==1
	eststo ols2_1

	* Base Sample (2)
	quietly reg avexpr logem4 lat_abst if baseco==1
	eststo ols2_2

	* Base Sample without Neo-Europes (3)
	quietly reg avexpr logem4 if baseco==1 & rich4==0
	eststo ols2_3

	* Base Sample without Neo-Europes (4)
	quietly reg avexpr logem4 lat_abst if baseco==1 & rich4==0
	eststo ols2_4

	* Base Sample without Africa (5)
	quietly reg avexpr logem4 if baseco==1 & africa==0
	eststo ols2_5

	* Base Sample without Africa (6)
	quietly reg avexpr logem4 lat_abst if baseco==1 & africa==0
	eststo ols2_6

	* Base Sample with continent dummies (7)
	quietly reg avexpr logem4 asia africa other if baseco==1
	eststo ols2_7

	* Base Sample with continent dummies (8)
	quietly reg avexpr logem4 lat_abst asia africa other if baseco==1
	eststo ols2_8

esttab using "$tabla/panel_b.tex", replace nocon b(2) se(2) r2(2) nomtitle  label///
star(* 0.10 ** 0.05 *** 0.01) booktabs alignment(D{.}{.}{-1}) ///
title(Panel B: First Stage for Average Protection Against Expropiation Risk in 1985-1995 \label{panelc}) ///
addnotes("Dependent variable: Average Protection Against Expropiation Risk")

* PANEL C
	
	eststo clear

	* Base Sample (1)
	quietly reg logpgp95 avexpr if baseco==1
	eststo ols2_1

	* Base Sample (2)
	quietly reg logpgp95 avexpr lat_abst if baseco==1
	eststo ols2_2

	* Base Sample without Neo-Europes (3)
	quietly reg logpgp95 avexpr if baseco==1 & rich4==0
	eststo ols2_3

	* Base Sample without Neo-Europes (4)
	quietly reg logpgp95 avexpr lat_abst if baseco==1 & rich4==0
	eststo ols2_4

	* Base Sample without Africa (5)
	quietly reg logpgp95 avexpr if baseco==1 & africa==0
	eststo ols2_5

	* Base Sample without Africa (6)
	quietly reg logpgp95 avexpr lat_abst if baseco==1 & africa==0
	eststo ols2_6

	* Base Sample with continent dummies (7)
	quietly reg logpgp95 avexpr asia africa other if baseco==1
	eststo ols2_7

	* Base Sample with continent dummies (8)
	quietly reg logpgp95 avexpr lat_abst asia africa other if baseco==1
	eststo ols2_8

esttab using "$tabla/panel_c.tex", replace nocon keep(avexpr) ///
b(2) se(2) r2(2) nomtitle label star(* 0.10 ** 0.05 *** 0.01) ///
booktabs alignment(D{.}{.}{-1}) ///
title(Panel C: Ordinary Least Squares \label{panelc}) ///
addnotes("Dependent variable: Log GDP per capita in 1995")

* PREGUNTA D: Instrumento débiles
*------------
	* Base Sample (1)
	quietly ivregress 2sls logpgp95 (avexpr = logem4) if baseco==1, small
	estat firststage

	* Base Sample (2)
	quietly ivregress 2sls logpgp95 lat_abst (avexpr = logem4) if baseco==1, small
	estat firststage

	* Base Sample without Neo-Europes (3)
	quietly ivregress 2sls logpgp95 (avexpr = logem4) if baseco==1 & rich4==0, small
	estat firststage

	* Base Sample without Neo-Europes (4)
	quietly ivregress 2sls logpgp95 lat_abst (avexpr = logem4) if baseco==1 & rich4==0, small
	estat firststage

	* Base Sample without Africa (5)
	quietly ivregress 2sls logpgp95 (avexpr = logem4) if baseco==1 & africa==0, small
	estat firststage

	* Base Sample without Africa (6)
	quietly ivregress 2sls logpgp95 lat_abst (avexpr = logem4) if baseco==1 & africa==0, small
	estat firststage

	* Base Sample with continent dummies (7)
	quietly ivregress 2sls logpgp95 asia africa other (avexpr = logem4) if baseco==1, small
	estat firststage

	* Base Sample with continent dummies (8)
	quietly ivregress 2sls logpgp95 lat_abst asia africa other (avexpr = logem4) if baseco==1, small
	estat firststage
	
* PREGUNTA E: Replicar Tabla 8 
*------------
	*PANEL A: 2SLS 
	eststo clear
	
	*Base sample (1)
	quietly ivregress 2sls logpgp95 (avexpr = euro1900) if baseco==1, small
	eststo tab8_pa_1
	
	*Base sample (2)
	quietly ivregress 2sls logpgp95 lat_abst (avexpr = euro1900) if baseco==1, small
	eststo tab8_pa_2
	
	*Base sample (3)
	quietly ivregress 2sls logpgp95 (avexpr = cons00a) if baseco==1, small
	eststo tab8_pa_3
	
	*Base sample (4)
	quietly ivregress 2sls logpgp95 lat_abst (avexpr = cons00a) if baseco==1, small
	eststo tab8_pa_4

	*Base sample (5)
	quietly ivregress 2sls logpgp95 (avexpr = democ00a) if baseco==1, small
	eststo tab8_pa_5
	
	*Base sample (6)
	quietly ivregress 2sls logpgp95 lat_abst (avexpr = democ00a) if baseco==1, small
	eststo tab8_pa_6
	
	*Base sample (7)
	quietly ivregress 2sls logpgp95 (avexpr = cons1) if baseco==1, small
	eststo tab8_pa_7
	
	*Base sample (8)
	quietly ivregress 2sls logpgp95 lat_abst (avexpr = cons1) if baseco==1, small
	eststo tab8_pa_8
	
	*Base sample (9)
	quietly ivregress 2sls logpgp95 (avexpr = democ1) if baseco==1, small
	eststo tab8_pa_9

	*Base sample (10)
	quietly ivregress 2sls logpgp95 lat_abst (avexpr = democ1) if baseco==1, small
	eststo tab8_pa_10

esttab using "$tabla/tab8_panela.tex", replace nocon  /// 
b(2) se(2) r2(2) nomtitle label star(* 0.10 ** 0.05 *** 0.01) ///
booktabs alignment(D{.}{.}{-1}) ///
title(Panel A: Two-Stage Least Squares \label{tab8_panela}) ///
addnotes("Dependent variable: Log GDP per capita in 1995")
	
	*PANEL B: First stage
	eststo clear
	
	*Base sample (1)
	quietly reg avexpr euro1900 if baseco==1
	eststo tab8_pb_1
	
	*Base sample (2)
	quietly reg avexpr euro1900 lat_abst if baseco==1
	eststo tab8_pb_2
	
	*Base sample (3)
	quietly reg avexpr cons00a if baseco==1
	eststo tab8_pb_3
	
	*Base sample (4)
	quietly reg avexpr cons00a lat_abst if baseco==1
	eststo tab8_pb_4

	*Base sample (5)
	quietly reg avexpr democ00a if baseco==1
	eststo tab8_pb_5
	
	*Base sample (6)
	quietly reg avexpr democ00a lat_abst if baseco==1
	eststo tab8_pb_6
	
	*Base sample (7)
	quietly reg avexpr cons1 if baseco==1
	eststo tab8_pb_7
	
	*Base sample (8)
	quietly reg avexpr cons1 lat_abst if baseco==1
	eststo tab8_pb_8
	
	*Base sample (9)
	quietly reg avexpr  democ1 if baseco==1
	eststo tab8_pb_9

	*Base sample (10)
	quietly reg avexpr democ1 lat_abst if baseco==1
	eststo tab8_pb_10
	
esttab using "$tabla/tab8_panelb.tex", replace nocon /// replace nocon b(2) se(2) r2(2) nomtitle
b(2) se(2) r2(2) nomtitle label  star(* 0.10 ** 0.05 *** 0.01) ///
booktabs alignment(D{.}{.}{-1}) ///
title(Panel B: First Stage for Average Protection Against Expropiation Risk \label{tab8_panelb}) ///
addnotes("Dependent variable: Average Protection Against Expropiation Risk")

	*PANEL D: Exogenous Log mortality
	eststo clear
	
	*Base sample (1)
	quietly ivregress 2sls logpgp95 logem4 (avexpr = euro1900) if baseco==1, small
	eststo tab8_pd_1
	
	*Base sample (2)
	quietly ivregress 2sls logpgp95 logem4 lat_abst (avexpr = euro1900) if baseco==1, small
	eststo tab8_pd_2
	
	*Base sample (3)
	quietly ivregress 2sls logpgp95 logem4 (avexpr = cons00a) if baseco==1, small
	eststo tab8_pd_3
	
	*Base sample (4)
	quietly ivregress 2sls logpgp95 logem4 lat_abst (avexpr = cons00a) if baseco==1, small
	eststo tab8_pd_4

	*Base sample (5)
	quietly ivregress 2sls logpgp95 logem4 (avexpr = democ00a) if baseco==1, small
	eststo tab8_pd_5
	
	*Base sample (6)
	quietly ivregress 2sls logpgp95 logem4 lat_abst (avexpr = democ00a) if baseco==1, small
	eststo tab8_pd_6
	
	*Base sample (7)
	quietly ivregress 2sls logpgp95 logem4 (avexpr = cons1) if baseco==1, small
	eststo tab8_pd_7
	
	*Base sample (8)
	quietly ivregress 2sls logpgp95 logem4 lat_abst (avexpr = cons1) if baseco==1, small
	eststo tab8_pd_8
	
	*Base sample (9)
	quietly ivregress 2sls logpgp95 logem4 (avexpr = democ1) if baseco==1, small
	eststo tab8_pd_9

	*Base sample (10)
	quietly ivregress 2sls logpgp95 logem4 lat_abst (avexpr = democ1) if baseco==1, small
	eststo tab8_pd_10

esttab using "$tabla/tab8_paneld.tex", replace nocon ///
b(2) se(2) r2(2) nomtitle label star(* 0.10 ** 0.05 *** 0.01) ///
booktabs alignment(D{.}{.}{-1}) ///
title(Panel D: Second Stage with Log Mortality as Exogenous Variable \label{tab8_paneld}) ///
addnotes("Dependent variable: Log GDP per capita in 1995")
	

* PREGUNTA F: Test Durbin Wu Hausman 
*------------

	* Base Sample (1)
	quietly ivregress 2sls logpgp95 (avexpr = logem4) if baseco==1, small
	estat endog

	* Base Sample (2)
	quietly ivregress 2sls logpgp95 lat_abst (avexpr = logem4) if baseco==1, small
	estat endog

	* Base Sample with continent dummies (8)
	quietly ivregress 2sls logpgp95 lat_abst asia africa other (avexpr = logem4) if baseco==1, small
	estat endog
	
* ALBOUY - 2012
*------------
cls

merge 1:1 shortnam using "$data\albouy_2012.dta"

keep if _merge==3
drop _merge

* crear variable neo-europes
gen neoeurop = (shortnam=="USA" | shortnam=="CAN"| shortnam=="AUS" | shortnam=="NZL") 
label variable neoeurop "Neo-Europes"

* continent-other
gen contother = (asia==1 | africa==1 | other==1) 

* PREGUNTA H: Tabla2: First Stage Estimates - Albouy
*------------

	*Panel A: Original Data 
	eststo clear
	
	*no controls (1)
	quietly reg avexpr logem4, cluster(logem4)
	eststo tab2_alb_panela_1
	
	*latitude control (2)
	quietly reg avexpr logem4 lat_abst, cluster(logem4)
	eststo tab2_alb_panela_2
	
	*without neo-europes
	quietly reg avexpr logem4 if neoeurop==0, cluster(logem4) 
	eststo tab2_alb_panela_3
	
	*continent indicators
	quietly reg avexpr logem4 if contother==1, cluster(logem4) 
	eststo tab2_alb_panela_4	

esttab using "$tabla/tab2_abouy_panela.tex", replace nocon ///
b(2) se(2) r2(2) nomtitle label  star(* 0.10 ** 0.05 *** 0.01) ///
booktabs alignment(D{.}{.}{-1}) ///
title(Panel A: Original data \label{tab2_abouy_panela}) ///
addnotes("Dependent variable: Expropiation Risk")	

	*Panel B: Removing conjectured mortality rates
	eststo clear
	
	preserve
	eststo clear
	
	keep if source0 == 1
	
	*no controls (1)
	quietly reg avexpr logem4, robust
	eststo tab2_alb_panelb_1
	
	*latitude control (2)
	quietly reg avexpr logem4 lat_abst, robust
	eststo tab2_alb_panelb_2
	
	*without neo-europes
	quietly reg avexpr logem4 if neoeurop==0, robust
	eststo tab2_alb_panelb_3
	
	*continent indicators
	quietly reg avexpr logem4 if contother==1, robust
	eststo tab2_alb_panelb_4		

esttab using "$tabla/tab2_abouy_panelb.tex", replace nocon /// 
b(2) se(2) r2(2) nomtitle label  star(* 0.10 ** 0.05 *** 0.01) ///
booktabs alignment(D{.}{.}{-1}) ///
title(Panel B: Removing conjectured mortality rates \label{tab2_abouy_panelb}) ///
addnotes("Dependent variable: Expropiation Risk")	
	restore
	
	*Panel C: Original Data, adding campaing and laborer indicators 
	eststo clear
	
	*no controls (1)
	quietly reg avexpr logem4 campaign slave, cluster(logem4)
	eststo tab2_alb_paneld_1
	
	*latitude control (2)
	quietly reg avexpr logem4 lat_abst campaign slave, cluster(logem4)
	eststo tab2_alb_paneld_2
	
	*without neo-europes
	quietly reg avexpr logem4 campaign slave if neoeurop==0, cluster(logem4) 
	eststo tab2_alb_paneld_3
	
	*continent indicators
	quietly reg avexpr logem4 campaign slave if contother==1, cluster(logem4) 
	eststo tab2_alb_paneld_4	

esttab using "$tabla/tab2_abouy_panelc.tex", replace nocon ///
b(2) se(2) r2(2) nomtitle label  star(* 0.10 ** 0.05 *** 0.01) ///
booktabs alignment(D{.}{.}{-1}) ///
title(Panel C: Original Data, adding campaing and laborer indicators \label{tab2_abouy_panelc}) ///
addnotes("Dependent variable: Expropiation Risk")	

	*Panel D: Removing conjectured mortality rates, adding campaing and laborer indicators 
	eststo clear
	
	preserve
	eststo clear
	
	keep if source0 == 1
	
	*no controls (1)
	quietly reg avexpr logem4 campaign slave, robust
	eststo tab2_alb_panelb_1
	
	*latitude control (2)
	quietly reg avexpr logem4 lat_abst campaign slave, robust
	eststo tab2_alb_panelb_2
	
	*without neo-europes
	quietly reg avexpr logem4 campaign slave if neoeurop==0, robust
	eststo tab2_alb_panelb_3
	
	*continent indicators
	quietly reg avexpr logem4 campaign slave if contother==1, robust
	eststo tab2_alb_panelb_4		

esttab using "$tabla/tab2_abouy_paneld.tex", replace nocon /// 
b(2) se(2) r2(2) nomtitle label  star(* 0.10 ** 0.05 *** 0.01) ///
booktabs alignment(D{.}{.}{-1}) ///
title(Panel D: Removing conjectured mortality rates, adding campaing and laborer indicators  \label{tab2_abouy_paneld}) ///
addnotes("Dependent variable: Expropiation Risk")	
	restore