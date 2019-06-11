        !COMPILER-GENERATED INTERFACE MODULE: Tue May 28 17:15:36 2019
        MODULE ONESTEPPLASTICITY__genmod
          INTERFACE 
            SUBROUTINE ONESTEPPLASTICITY(F,MU,K,ETA,DT,CI,S,N,COUCHY,   &
     &CI_NEW,PK1,YIELDSTRESS,GAMMA,BETA)
              INTEGER(KIND=4) :: N
              REAL(KIND=8) :: F(2,2,N)
              REAL(KIND=8) :: MU
              REAL(KIND=8) :: K
              REAL(KIND=8) :: ETA
              REAL(KIND=8) :: DT
              REAL(KIND=8) :: CI(2,2,N)
              REAL(KIND=8) :: S(N)
              REAL(KIND=8) :: COUCHY(2,2,N)
              REAL(KIND=8) :: CI_NEW(3,3,N)
              REAL(KIND=8) :: PK1(2,2,N)
              REAL(KIND=8) :: YIELDSTRESS
              REAL(KIND=8) :: GAMMA
              REAL(KIND=8) :: BETA
            END SUBROUTINE ONESTEPPLASTICITY
          END INTERFACE 
        END MODULE ONESTEPPLASTICITY__genmod