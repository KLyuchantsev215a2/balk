        !COMPILER-GENERATED INTERFACE MODULE: Tue Jun 18 15:10:01 2019
        MODULE COMPUTE_ACCELERATION__genmod
          INTERFACE 
            SUBROUTINE COMPUTE_ACCELERATION(CS,N,H,DH,RHO_0,MU,K,ETA,   &
     &DAMPING,VOL,F,COUCHY,PK1,X,X_INIT,V_OLD,NABLA_W_0_1,NABLA_W_0_2,  &
     &ACC,COUNT_HOLE,COUNT_SECTION,INDEX_SECTION,INDEX_HOLE,CI,CI_NEW,  &
     &TABLE,YIELDSTRESS,ETTA,BETAR,GAMMAR,BETAS,GAMMAS,S,S_NEW,DT,ETAN,C&
     &,C_NEW,PK1N)
              INTEGER(KIND=4) :: COUNT_SECTION
              INTEGER(KIND=4) :: COUNT_HOLE
              INTEGER(KIND=4) :: N
              REAL(KIND=8) :: CS
              REAL(KIND=8) :: H
              REAL(KIND=8) :: DH
              REAL(KIND=8) :: RHO_0
              REAL(KIND=8) :: MU
              REAL(KIND=8) :: K
              REAL(KIND=8) :: ETA
              REAL(KIND=8) :: DAMPING
              REAL(KIND=8) :: VOL
              REAL(KIND=8) :: F(2,2,N)
              REAL(KIND=8) :: COUCHY(3,3,N)
              REAL(KIND=8) :: PK1(2,2,N)
              REAL(KIND=8) :: X(2,N)
              REAL(KIND=8) :: X_INIT(2,N)
              REAL(KIND=8) :: V_OLD(2,N)
              REAL(KIND=8) :: NABLA_W_0_1(N,N)
              REAL(KIND=8) :: NABLA_W_0_2(N,N)
              REAL(KIND=8) :: ACC(2,N)
              INTEGER(KIND=4) :: INDEX_SECTION(COUNT_SECTION)
              INTEGER(KIND=4) :: INDEX_HOLE(COUNT_HOLE)
              REAL(KIND=8) :: CI(2,2,N)
              REAL(KIND=8) :: CI_NEW(3,3,N)
              INTEGER(KIND=4) :: TABLE(N,120)
              REAL(KIND=8) :: YIELDSTRESS
              REAL(KIND=4) :: ETTA
              REAL(KIND=8) :: BETAR
              REAL(KIND=8) :: GAMMAR
              REAL(KIND=8) :: BETAS
              REAL(KIND=8) :: GAMMAS
              REAL(KIND=8) :: S(N)
              REAL(KIND=8) :: S_NEW(N)
              REAL(KIND=8) :: DT
              REAL(KIND=8) :: ETAN
              REAL(KIND=8) :: C(3,3,N)
              REAL(KIND=8) :: C_NEW(3,3,N)
              REAL(KIND=8) :: PK1N(2,2,N)
            END SUBROUTINE COMPUTE_ACCELERATION
          END INTERFACE 
        END MODULE COMPUTE_ACCELERATION__genmod
