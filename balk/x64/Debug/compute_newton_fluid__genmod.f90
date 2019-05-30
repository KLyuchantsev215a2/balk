        !COMPILER-GENERATED INTERFACE MODULE: Tue May 28 16:52:51 2019
        MODULE COMPUTE_NEWTON_FLUID__genmod
          INTERFACE 
            SUBROUTINE COMPUTE_NEWTON_FLUID(F,ETAN,C,PK1N,N,DT)
              INTEGER(KIND=4) :: N
              REAL(KIND=8) :: F(2,2,N)
              REAL(KIND=8) :: ETAN
              REAL(KIND=8) :: C(3,3,N)
              REAL(KIND=8) :: PK1N(2,2,N)
              REAL(KIND=8) :: DT
            END SUBROUTINE COMPUTE_NEWTON_FLUID
          END INTERFACE 
        END MODULE COMPUTE_NEWTON_FLUID__genmod
