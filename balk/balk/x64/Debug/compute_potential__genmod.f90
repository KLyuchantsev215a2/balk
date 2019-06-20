        !COMPILER-GENERATED INTERFACE MODULE: Tue Jun 18 20:38:30 2019
        MODULE COMPUTE_POTENTIAL__genmod
          INTERFACE 
            SUBROUTINE COMPUTE_POTENTIAL(F,MU,K,N,U,CI)
              INTEGER(KIND=4) :: N
              REAL(KIND=8) :: F(2,2,N)
              REAL(KIND=8) :: MU
              REAL(KIND=8) :: K
              REAL(KIND=8) :: U(N)
              REAL(KIND=8) :: CI(2,2,N)
            END SUBROUTINE COMPUTE_POTENTIAL
          END INTERFACE 
        END MODULE COMPUTE_POTENTIAL__genmod
