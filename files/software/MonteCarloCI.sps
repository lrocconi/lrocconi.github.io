* Encoding: UTF-8.

*Monte Carlo Confidence Intervals for Indirect Effects by Louis M. Rocconi (2019). 
*Based on Darlington & Hayes (2017, p. 463) sample syntax for Stata. 

define !mcci (b1 = !tokens(1) /se1 = !tokens(1) /b2 = !tokens(1) /se2 = !tokens(1) /seed = !tokens(1) !default(3000)). 
preserve.
DATASET NAME original. 
new file. 
set rng=mc seed = !seed. 
INPUT PROGRAM.
  VECTOR X(2).
     LOOP #I = 1 TO 5000.
        LOOP #J = 1 TO 2.
            IF #J eq 1 X(#J) = (NORMAL(1)*!se1) +!b1.
            IF #J eq 2 X(#J) = (NORMAL(1)*!se2) +!b2.
    END LOOP.
    END CASE.
    END LOOP.
    END FILE.
END INPUT PROGRAM.

compute b4b3 = x1*x2. 
FREQUENCIES b4b3 /percentiles 2.5 97.5 /format notable. 
dataset activate original. 
restore. 
!enddefine. 
