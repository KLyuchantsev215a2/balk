        !COMPILER-GENERATED INTERFACE MODULE: Tue Jun 18 20:38:30 2019
        MODULE ONESTEPPLASTICITY__genmod
          INTERFACE 
            SUBROUTINE ONESTEPPLASTICITY(F,MU,K,ETA,DT,CI,S,S_NEW,N,    &
     &COUCHY,CI_NEW,PK1,YIELDSTRESS,GAMMAR,BETAR,GAMMAS,BETAS)
              INTEGER(KIND=4) :: N
              REAL(KIND=8) :: F(2,2,N)
              REAL(KIND=8) :: MU
              REAL(KIND=8) :: K
              REAL(KIND=8) :: ETA
              REAL(KIND=8) :: DT
              REAL(KIND=8) :: CI(2,2,N)
              REAL(KIND=8) :: S(N)
              REAL(KIND=8) :: S_NEW(N)
              REAL(KIND=8) :: COUCHY(3,3,N)
              REAL(KIND=8) :: CI_NEW(3,3,N)
              REAL(KIND=8) :: PK1(2,2,N)
              REAL(KIND=8) :: YIELDSTRESS
              REAL(KIND=8) :: GAMMAR
              REAL(KIND=8) :: BETAR
              REAL(KIND=8) :: GAMMAS
              REAL(KIND=8) :: BETAS
            END SUBROUTINE ONESTEPPLASTICITY
          END INTERFACE 
        END MODULE ONESTEPPLASTICITY__genmod
