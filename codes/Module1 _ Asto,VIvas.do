** Tarea Califica da Modulo 1 - Econometria Avanzada **
* Sonia Asto - 20166142
*Claudia Vivas - 20141150


cls 
clear all 

global data "G:\My Drive\PUCP\10°CICLO\Econometría Avanzada - Micro\Modulo 1\Trabajo Calificado"

global tablas "G:\My Drive\PUCP\10°CICLO\Econometría Avanzada - Micro\Modulo 1\Trabajo Calificado\Tablas"

use "$data\projoven.dta",clear

* === limpieza de datos =====

	* crear variables 
	gen age2 = age*age
	gen id=_n
	
	* etiquetas
	label variable treatment "tratamiento"
	label variable age "edad"
	label variable sex "sexo"
	label variable children "tiene hijos"
	label variable nchildren "numero de hijos"
	label variable training0 "estudio"
	label variable water "agua potable"
	label variable toilet "inodoro con cisterna"
	label variable earnings1 "ingresos mensuales luego del programa"
	label variable floor "suelo de tierra"
	label variable ceiling "techo de esteras"
	label variable walls "paredes de esteras"
	label variable educ5 "secundaria completa"
	label variable single "soltero"
	label variable married "casado"
	label variable age2 "edad al cuadrado"
	label variable earnings0 "ingresos mensuales antes del programa"
	label variable duration0 "duracion antes del tratamiento (dias)"
	
*==== 2.1 =====

	* test de medias respecto a todas las variables de control
	foreach x in age age2 educ5 sex married water toilet floor walls ceiling children nchildren training0 duration0{ 
	ttest `x', by(treatment)
	}
	
* ==== 2.2 =====

	* ATT: efecto del tratamiento sobre los ingresos 
	reg earnings1 treatment age age2 educ5 sex married water toilet floor walls ceiling children nchildren training0 duration0
	eststo: reg earnings0 treatment age age2 educ5 sex married water toilet floor walls ceiling children nchildren training0 duration0
	
* ==== 2.3 ====

	* re estimating ATT
	eststo: reg earnings1 treatment married water toilet floor walls ceiling children nchildren training0 duration0
	
	*Table 1
	esttab using "$tablas/tab_reg_1.tex", replace b(3) se(3) nomtitle label ///
	star(* 0.10 ** 0.05 *** 0.01) booktabs alignment(D{.}{.}{-1}) ///
	title(OLS Regression \label{reg1}) ///
	addnotes("Dependent variable: earnings. No experimental case." ///
	         "Data source: PROJOVEN.")
	
* ==== 2.4 ====
	preserve
	* reshape porque los datos son de corte transversal
	reshape long earnings, i(id) j(year)
	
	* estimador D-D
	gen did= year*treatment
	
	* clear previous regressions
	eststo clear
	
	eststo: reg earnings treatment year did age age2 educ5 sex married water toilet floor walls ceiling children nchildren training0 duration0
	
	*Table 2
	esttab using "$tablas/tab_reg_2.tex", replace b(3) se(3) nomtitle label ///
	star(* 0.10 ** 0.05 *** 0.01) booktabs alignment(D{.}{.}{-1}) ///
	title(Diff - Diff Methodology \label{reg1}) ///
	addnotes("Dependent variable: earnings. No experimental case." ///
	         "Data source: PROJOVEN.")
	restore

* ==== 2.6 ====
	
	*Compute the propensity score
	eststo clear
	eststo: pscore treatment age age2 educ5 sex married water toilet floor walls ceiling children nchildren training0 duration0 earnings0, pscore(ps1) blockid(block) comsup level(0.01) logit
	
	*Table 3
	esttab using "$tablas/tab_logit_ps.tex", replace b(3) se(3) nomtitle label ///
	star(* 0.10 ** 0.05 *** 0.01) booktabs alignment(D{.}{.}{-1}) ///
	title(Logit Regression\label{reg1}) ///
	addnotes("Dependent variable: treatment. No experimental case." ///
	         "Data source: PROJOVEN.")
	
	*Matching with a nearest neighbor
	eststo clear
	eststo: psmatch2 treatment if comsup==1, outcome(earnings1) pscore(ps1) neighbor(1)  
	
	*Table 4
	esttab using "$tablas/tab_psc1.tex", replace b(3) se(3) nomtitle label ///
	star(* 0.10 ** 0.05 *** 0.01) booktabs alignment(D{.}{.}{-1}) ///
	title(Propensity Score Matching Methodology \label{reg1}) ///
	addnotes("Dependent variable: earnings. No experimental case." ///
	         "Data source: PROJOVEN." "Matching with one nearest neighbor")
* ==== 2.7 ====
	
	*Matching with 5 nearest neighbors
	eststo clear	
	eststo: psmatch2 treatment if comsup==1, outcome(earnings1) pscore(ps1) neighbor(5)
	
	*Table 5
	esttab using "$tablas/tab_psc5.tex", replace b(3) se(3) nomtitle label ///
	star(* 0.10 ** 0.05 *** 0.01) booktabs alignment(D{.}{.}{-1}) ///
	title(Propensity Score Matching Methodology \label{reg1}) ///
	addnotes("Dependent variable: earnings. No experimental case." ///
	         "Data source: PROJOVEN." "Matching with five nearest neighbors")
	
	*ATT: * Logra rechazar la hiptesis nula con mayor severidad
	
* ==== 2.8 ====
	
	*Matching using kernel distribution
	eststo clear	
	eststo: psmatch2 treatment if comsup==1, outcome(earnings1) pscore(ps1) kernel
	
	*Table 6
	esttab using "$tablas/tab_psc_kernel.tex", replace b(3) se(3) nomtitle label ///
	star(* 0.10 ** 0.05 *** 0.01) booktabs alignment(D{.}{.}{-1}) ///
	title(Propensity Score Matching Methodology \label{reg1}) ///
	addnotes("Dependent variable: earnings. No experimental case." ///
	         "Data source: PROJOVEN." "Matching with kernel distribution")
	
* ==== 2.9 ====
	eststo clear
	eststo: pstest age age2 educ5 sex married water toilet floor walls ceiling children nchildren training0 duration0 earnings0
	
	*Table 7
	esttab using "$tablas/tab_test.tex", replace b(3) se(3) label ///
	star(* 0.10 ** 0.05 *** 0.01) alignment(D{.}{.}{-1}) ///
	title(Balancing Covariate Test) ///
	addnotes("Data source: PROJOVEN")


	