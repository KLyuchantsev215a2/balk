        !COMPILER-GENERATED INTERFACE MODULE: Thu Jun 13 12:44:38 2019
        MODULE PLOT_C__genmod
          INTERFACE 
            SUBROUTINE PLOT_C(N,COUCHY,X,INDEX_SECTION,COUNT_SECTION)
              INTEGER(KIND=4) :: COUNT_SECTION
              INTEGER(KIND=4) :: N
              REAL(KIND=8) :: COUCHY(2,2,N)
              REAL(KIND=8) :: X(2,N)
              INTEGER(KIND=4) :: INDEX_SECTION(COUNT_SECTION)
            END SUBROUTINE PLOT_C
          END INTERFACE 
        END MODULE PLOT_C__genmod