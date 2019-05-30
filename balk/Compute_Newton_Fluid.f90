subroutine Compute_Newton_Fluid(F,etaN,C,C_new,PK1N,N,dt)
    
     integer :: N
     real*8 :: F(2,2,N)
     real*8 :: etaN
     real*8 :: C(3,3,N)
     real*8 :: C_new(3,3,N)
     real*8 :: Cpp(3,3)
     real*8 :: Fp(3,3)
     real*8 :: dt
     real*8 :: PK1N(2,2,N)
     real*8 :: trans_Fp(3,3)
    

     real*8 :: invC_new(3,3)
     real*8 :: invC(3,3)
     real*8 :: C_inv_point(3,3)
    
   
     real*8 :: XN(3,3)
    
     real*8 ::multXNC(3,3)
     real*8 :: trace
    
     do i=1,N
         Fp=0
         Cpp(1:3,1:3)=C(1:3,1:3,i)
         Fp(1:2,1:2)=F(1:2,1:2,i)
         Cpp(3,3)=1.0/(C(1,1,i)*C(2,2,i)-C(1,2,i)*C(2,1,i))
         call inv_matrix(Cpp,invC) !inv nC
         
         Fp(3,3)=1
        
         detFp=(Fp(1,1)*Fp(2,2)-Fp(1,2)*Fp(2,1))
        
         call trans(Fp,trans_Fp)
           
         call mymulty(trans_Fp,Fp,Cpp)    !  now C = F' F
         
         
         call inv_matrix(Cpp,invC_new) !inv n+1 C
         
         C_inv_point=1.0d0/dt*(invC_new-invC) !pointC
        
         C(1:3,1:3,i)=Cpp(1:3,1:3)
         
         XN=-etaN*C_inv_point(1:3,1:3)
        
         call mymulty(XN,Cpp,multXNC)
         
         PK1N(1:2,1:2,i)=XN(1:2,1:2)-1.0d0/3.0d0*(multXNC(1,1)+multXNC(2,2)+multXNC(3,3))*C_inv_point(1:2,1:2)
    enddo
end