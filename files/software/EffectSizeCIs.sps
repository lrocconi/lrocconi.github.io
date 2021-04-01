* Encoding: UTF-8.
* ======================================================================.
* Date: 28-September-2018 .
* Author: Louis Rocconi .
* Citation: Rocconi, L. M. (2018). SPSS Macro to Compute Confidence Intervals for Effect Sizes. The University of Tennessee, Knoxville. 
* ======================================================================.
* This file contains an SPSS macro to compute confidence intervals for various effect sizes
* Cohen's d, Hedge's g, Eta-Squared, and Omega-Squared in independent, dependent, and single sample t-tests.
* The arguments in the macro include:
* N1 (Sample size for group 1) 
* N2 (Sample size for group 2)
* CL (Confidence Level) {Defaults to 95% CL}
* paired (Indicates independent or dependent/single sample t-test) {Defaults to Independent design}. 
* obs_t (The observed t value). 
* Values must be specified for N1 and obs_t. 
* N2 is not required for the dependent and single sample t-tests.
* The paired argument is used to indicate which test you are conducting,
* 0[default]=dependent and 1=dependent or single sample. 
* CL is optional, and will default to 95%. The CL must be indicated in whole numbers (i.e., 95 for 95% and 90 for 90%). 
* The obs_t argument must be the last argument, the order for the rest of the arguments does not matter.

DEFINE !ESCI (paired !TOKENS(1) !DEFAULT (0) 
    /CL !TOKENS(1) !DEFAULT (95) 
    /n1 !TOKENS(1) 
    /n2 !TOKENS(1) /decimals !TOKENS(1) !DEFAULT (3)
    /obs_t !CMDEND). 

PRESERVE. 

SET ovars labels onumbers values tvars labels tnumbers labels.
INPUT PROGRAM. 
NUMERIC obs_t d g omega eta pvalue tcdf (F8.4). 
NUMERIC n n1 n2 df CL (F8.0).
LOOP #=1 to 1. 
END CASE. 
END LOOP. 
END FILE. 
END INPUT PROGRAM. 
EXE. 

COMPUTE obs_t = !obs_t. 

!IF (!paired = 0) !THEN

COMPUTE n1 = !n1.
COMPUTE n2 = !n2. 
COMPUTE d= obs_t*sqrt((1/n1)+(1/n2)). 
COMPUTE df=n1+n2-2. 
!IFEND. 

!IF (!paired = 1) !THEN

COMPUTE n = !n1. 
COMPUTE n1 = !n1. 
COMPUTE d= obs_t/sqrt(n1). 
COMPUTE df=n1-1.  
!IFEND. 

COMPUTE g=d*(1-(3/(4*df-1))). 
COMPUTE CL=!CL. 
COMPUTE tcdf = cdf.t (obs_t, df). 

DO IF obs_t le 0.
COMPUTE pvalue = (tcdf)*2. 
ELSE IF obs_t gt 0. 
COMPUTE pvalue = (1-tcdf)*2. 
END IF. 

COMPUTE eta = (obs_t*obs_t)/((obs_t*obs_t)+df). 
COMPUTE omega = ((obs_t*obs_t)-1)/((obs_t*obs_t)+df). 
EXECUTE. 

DO IF omega < 0. 
COMPUTE omega = 0. 
END IF. 
EXECUTE. 

COMPUTE rr=1-((100-CL)/100)/2. 
SET MXLOOPS=10000. 
COMPUTE epsilon=.0000000001. 
VECTOR NCt(2, F8.4). 

LOOP #=1 TO 2. 
+  COMPUTE minabsdif=1. 
+  COMPUTE bottomNCt=-50. 
+  COMPUTE topNCt=50. 
+  COMPUTE newdelta=1. 
+  COMPUTE incr=1. 
+  IF #=1 P=rr. 
+  IF #=2 P=1-rr. 
+  LOOP. 
+    LOOP NCtvalue= bottomNCt TO topNCt by incr. 
+     COMPUTE delta=newdelta. 
+     COMPUTE prob=ncdf.t(obs_t,df,NCtvalue). 
+     COMPUTE newdelta=abs(p-prob). 
+     DO IF newdelta LT minabsdif. 
+      COMPUTE minabsdif=newdelta. 
+      COMPUTE minNCt=NCtvalue. 
+      END IF. 
+    END LOOP. 
+    COMPUTE bottomNCt=minNCt-incr. 
+    COMPUTE topNCt=minNCt+incr. 
+    COMPUTE incr=incr/10. 
+  END LOOP IF delta LE epsilon. 
+ COMPUTE NCt(#)=minNCt. 
END LOOP. 

!IF (!paired = 0) !THEN

COMPUTE d_upper = NCt2*sqrt((1/n1)+(1/n2)). 
COMPUTE d_lower =  NCt1*sqrt((1/n1)+(1/n2)). 
COMPUTE g_upper=d_upper*(1-(3/(4*(n1+n2)-9))). 
COMPUTE g_lower=d_lower*(1-(3/(4*(n1+n2)-9))). 
!IFEND. 

!IF (!paired = 1) !THEN

COMPUTE d_upper = NCt2/sqrt(n). 
COMPUTE d_lower =  NCt1/sqrt(n). 
COMPUTE g_upper=d_upper*(1-(3/(4*df-1))). 
COMPUTE g_lower=d_lower*(1-(3/(4*df-1))). 
!IFEND. 

COMPUTE eta_u = (NCt2*NCt2)/((NCt2*NCt2)+df). 
COMPUTE eta_l = (NCt1*NCt1)/((NCt1*NCt1)+df). 
COMPUTE omega_u = ((NCt2*NCt2)-1)/((NCt2*NCt2)+df). 
COMPUTE omega_l = ((NCt1*NCt1)-1)/((NCt1*NCt1)+df). 
EXECUTE. 

DO IF NCt1 le 0. 
COMPUTE eta_l = 0. 
END IF. 
EXECUTE. 

DO IF NCt1 lt 1.
COMPUTE omega_l=0.
END IF. 
EXECUTE. 

FORMATS ALL (!concat("F8.",!decimals)) N(F8.0) N1(F8.0) N2(F8.0) CL(F8.0) df (F8.0). 
VARIABLE LABELS n1 "N1" 
/n2 "N2" 
/n "N" 
/obs_t "t-value" 
/pvalue "p-value" 
/d "Cohen's d" 
/g "Hedge's g"
/NCt1 "Lower" 
/NCt2 "Upper" 
/d_lower "Lower" 
/d_upper "Upper" 
/g_lower "Lower" 
/g_upper "Upper" 
/eta "Eta-Squared" 
/omega "Omega-Squared" 
/eta_u "Upper" 
/eta_l "Lower" 
/omega_u "Upper" 
/omega_l "Lower" 
/CL "Confidence Limit*".

OMS 
/SELECT tables 
/IF subtypes=['Case Processing Summary' 'Notes']
/DESTINATION viewer=no.

!IF (!paired = 0) !THEN

SUMMARIZE
/TABLES=N1 N2 obs_t df pvalue 
/FORMAT=list nocasenum
/TITLE='Independent-Samples t Test'
/CELLS=none.
!IFEND. 

!IF (!paired = 1) !THEN

SUMMARIZE
/TABLES=N obs_t df pvalue 
/FORMAT=list nocasenum
/TITLE='One-Sample t Test'
/CELLS=none.
!IFEND. 

OMS 
/SELECT headings
/DESTINATION viewer=no.

SUMMARIZE
/TABLES=d g eta omega
/FORMAT=list nocasenum nototal
/TITLE='Effect Sizes'/cells=none.

SUMMARIZE 
/TABLES=NCt1 NCt2
/FORMAT=list nocasenum nototal
/TITLE='Noncentrality Parameters'
/CELLS=none.

SUMMARIZE 
/TABLES=d d_lower d_upper CL
/FORMAT=list nocasenum nototal
/TITLE="Cohen's d Confidence Interval" 
/CELLS=none 
/FOOTNOTE "*User specified". 
 
SUMMARIZE 
/TABLES=g g_lower g_upper CL
/FORMAT=list nocasenum nototal
/TITLE="Hedges's g Confidence Interval" 
/CELLS=none 
/FOOTNOTE "*User specified". 

SUMMARIZE 
/TABLES=eta eta_l eta_u CL
/FORMAT=list nocasenum nototal
/TITLE="Eta-Squared Confidence Interval" 
/CELLS=none 
/FOOTNOTE "*User specified". 

SUMMARIZE 
/TABLES=omega omega_l omega_u CL
/FORMAT=list nocasenum nototal
/TITLE="Omega-Squared Confidence Interval" 
/CELLS=none 
/FOOTNOTE "*User specified". 
 
OMSEND. 
OMSEND.
RESTORE. 
!ENDDEFINE.

