﻿    program base
    integer N,i,count_hole,count_section,k1,k2,a!the number of particles that sample the environment
    integer step!counter for time steps
    integer sqn,fr,coutfr,flag
    real*8 :: rho_0, T, l,CFL!density, total calculation time ,the size of the side of the square, Courant number
    real*8 :: Area,m!body area, mass of a single particle , smoothing radius
    real*8 :: nu,mu,cs,E,k,eta,damping,YieldStress,gammar,betar,gammas,betas,etaN !material constants
    real*8 :: dh,max_h!indent for calculating the derived kernel through finite differences
    real*8 :: dt,time_calculated,s_average!time step, time during calculation
    real*8 :: pi
    real*8 :: Force
    real*8 :: Ken,Poten
    
    real*8, allocatable :: x(:,:)
  
    real*8, allocatable :: xplot(:,:,:)
    real*8, allocatable :: x_init(:,:)
    real*8, allocatable :: x_prev(:,:)
    integer, allocatable :: table(:,:)
    real*8, allocatable :: v(:,:)
     real*8, allocatable :: s(:)
      real*8, allocatable :: s_new(:)
   
    real*8, allocatable :: W(:,:)
    real*8, allocatable :: Wper1(:,:)
    real*8, allocatable :: Wper2(:,:)
    real*8, allocatable :: Wper3(:,:)!tmp
    real*8, allocatable :: Wper4(:,:)!tmp
    real*8, allocatable :: nabla_W(:,:,:)
    real*8, allocatable :: nabla_W_0_1(:,:)
    real*8, allocatable :: nabla_W_0_2(:,:)
    
    real*8, allocatable :: Couchy(:,:,:)
    real*8, allocatable :: PK1(:,:,:)
    real*8, allocatable :: PK1N(:,:,:)
    real*8, allocatable :: F(:,:,:)
    real*8, allocatable :: Ci(:,:,:)
    real*8, allocatable :: C(:,:,:)
    real*8, allocatable :: C_new(:,:,:)
    real*8, allocatable :: Ci_new(:,:,:)
    real*8, allocatable :: U(:)
  
    
    real*8:: vol
    real*8 :: h
    
    real*8, allocatable :: acc(:,:)
    real*8, allocatable :: x_0(:,:),x_n_1(:,:),x_n_2(:,:),x_n_1_2(:,:),x_n_3_2(:,:)
    real*8, allocatable :: v_0_0(:,:),v_n_1(:,:),v_n_2(:,:),v_n_1_2(:,:),v_n_3_2(:,:)
    
    integer, allocatable :: index_hole(:)
    integer, allocatable :: index_section(:)
    
     interface
     
         function Compute_Viscosity(hi,hj,cs,rho_0,xi,vi,xj,vj)
            real*8 ::hi
            real*8 ::hj
            real*8 :: hij
            real*8 :: cs
            real*8 :: rho_0
            real*8 :: xi(1:2)
            real*8 :: vi(1:2)
            real*8 :: xj(1:2)
            real*8 :: vj(1:2)
    
            real*8:: xij(1:2)
            real*8 :: vij(1:2)
            real*8 :: Compute_Viscosity
         end function Compute_Viscosity
         
        function Compute_W (xi,xj,hi,hj)
            real*8 :: xi(2)
            real*8 :: xj(2)
            real*8 :: hi
            real*8 :: hj
            real*8 :: Compute_W
        end function Compute_W
      
        function det (M)
            real*8 :: M(3,3)
            real*8 :: det
        end function det
               
        function trace (M)
            real*8 :: M(3,3)
            real*8 :: trace
        end function trace
        
        function dev (M)
            real*8 :: M(3,3)
            real*8 :: dev(3,3)
        end function dev
      
     end interface
    
    open (unit=1, file="300.txt")
    open (unit=2, file="output_x.txt", action='write')
    open (unit=3, file="output_C.txt", action='write')
    
       
    
    read (1, 1100) rho_0, T,nu, mu, l, dh,CFL,N 
    write (*, 1113) rho_0, T,nu, mu, l, dh,CFL,N
    flag=0
    sqn=21
    pi=3.14159265359
    
    coutfr=1
    Area=3.0d0
    m=rho_0*Area/N
    
    k=175000.0d0
    gammar=30000.0d0
    betar=100.0d0
    
    gammas=-6000.0d0
    betas=20.0d0
    
    damping=0.0d0
    etaN=0.0d0
    eta=100.0d0
    YieldStress=335.0d0
    E=9.0*k*mu/(3.0*k+mu)

    cs=sqrt((k+4.0/3.0*mu)/rho_0)
    
    
    
    allocate(x(2,N))
    allocate(x_init(2,N))
    allocate(x_prev(2,N))
    allocate(xplot(2,N,200))
    allocate(v(2,N))
    allocate(table(N,120))
    
    allocate(acc(2,N))
    allocate(x_0(2,N))
    allocate(v_0_0(2,N))
    allocate(s(N))
    allocate(s_new(N))
    
    allocate(Wper1(N,N))
    allocate(nabla_W_0_1(N,N))
    allocate(nabla_W_0_2(N,N))
    
   
   
    !do i=1,1152
    !     h(i)=0.00683066512
    !     vol(i)=0.05375/1152.0d0
    !enddo
   
    ! do i=1153,2751
     !    h(i)=0.021
      !   vol(i)=0.7125/1598.0d0
    !enddo
    
    
    do i=1,N
        read (1, 1110) a,x(1,i),x(2,i)
    enddo
      
    h=1.0d0*sqrt(m/rho_0)
    vol=m/rho_0
   
    
    dt=0.00001d0!CFL*h/(cs)
   fr=int(T/dt/50)
    
   
    
    call Create_Table(x,h,table,N,dh)
    
   count_hole=0
   count_section=0
    
    do i=1,N
         

    if(x(2,i)>=3.0d0) then
            count_hole=count_hole+1
        end if
        
        if (x(2,i)<=0.0d0) then
                count_section=count_section+1
        end if
        
    enddo
    
    allocate(index_hole(count_hole))
    allocate(index_section(count_section))
     
    k1=1
    k2=1
    do i=1,N
        
     if(x(2,i)>=3.0d0) then  
                index_hole(k1)=i
                k1=k1+1
        end if
        
        
        if (x(2,i)<=0.0d0) then
                index_section(k2)=i                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
                k2=k2+1
        end if
        
    enddo
    x_init=x
    v=0
   
   
   call Compute_nabla_W(x,h,vol,N,Wper1,nabla_W_0_1,nabla_W_0_2,dh,table)!tmp
   
   deallocate(Wper1)
   
    allocate(F(2,2,N))
    allocate(Ci(2,2,N))
    allocate(C(3,3,N))
    allocate(C_new(3,3,N))
    allocate(Ci_new(3,3,N))
    allocate(Couchy(3,3,N))
    allocate(PK1(2,2,N))
    allocate(PK1N(2,2,N))
    allocate(U(N))
   
   
   
   call Compute_F(vol,x,x_init,nabla_W_0_1,nabla_W_0_2,N,F,table)
   Ci=F
   s=0.0d0
   call OneStepPlasticity(F,mu,k,eta,dt,Ci,s,s_new,N,Couchy,Ci_new,PK1,YieldStress,gammar,betar,gammas,betas)
   Ci(1:2,1:2,1:N)=Ci_new(1:2,1:2,1:N)
   PK1N=0
   
  !call Compute_potential(F,mu,k,N,U,Ci)
   
   C=0.0d0
   C(1,1,1:N)=1
   C(2,2,1:N)=1
   C(3,3,1:N)=1
   acc=0.0d0
   
   ! call plot_init(x,N,count_hole,count_section,index_section,index_hole)
    do step=1,int(T/dt)
        
        
        v=v+dt*acc
        x=x+dt*v
        
        do k2=1,count_hole
            x(2,index_hole(k2))=x_init(2,index_hole(k2))+0.05*16.0d0*(1-cos(pi*time_calculated))
        enddo  
        
        do k1=1,count_section
            x(2,index_section(k1))=x_init(2,index_section(k1))
        enddo
        
        
        call Compute_Acceleration(cs,N,h,dh,rho_0,mu,k,eta,damping,vol,F,Couchy,PK1,x,x_init,v,nabla_W_0_1,nabla_W_0_2,acc,count_hole,count_section,index_section,index_hole,Ci,Ci_new,table,YieldStress,etta,betar,gammar,betas,gammas,s,s_new,dt,etaN,C,C_new,PK1N)
        
        
        time_calculated=(real(step)*dt)
        
        
        !v=(x-x_prev)/dt
        
    !    Ken=0
       ! Poten=0
       ! call Compute_potential(F,mu,k,N,U,Ci)
        
       ! do i=1,N
       !      Ken=Ken+1.0d0/2.0d0*rho_0*vol*(v(1,i)*v(1,i)+v(2,i)*v(2,i))
        !     Poten=Poten+U(i)*vol
       ! enddo
        
        
        
    
        
        
        
        if(step-int(step/fr)*fr==0) then
             write (*,1112) Couchy(2,2,index_section(1)),time_calculated
    
           xplot(1:2,1:N,coutfr)=x
            coutfr=coutfr+1
            
             Force=0.0d0
       
             !s_average=0.0d0
            ! do i=1,N
            ! s_average=s_average+sqrt((Couchy(1,1,i)-Couchy(2,2,i))**2+(Couchy(2,2,i)-Couchy(3,3,i))**2+(Couchy(3,3,i)-Couchy(1,1,i))**2)
            ! enddo
             
           !  write (2,1112)  s_average/N,time_calculated
             
             do k1=1,count_hole 
                if(x_init(2,index_hole(k1))==3.0d0) then 
                
                    if((x_init(1,index_hole(k1))<=0.0000001)+(x_init(1,index_hole(k1))>=0.9999)) then
                        PK1(2,2,index_hole(k1))=PK1(2,2,index_hole(k1))/2.0d0
                    endif
                    
                    Force=Force+PK1(2,2,index_hole(k1))
                    
                endif
             enddo
        
          ! write (2,1112)  (Force/(count_hole-1.0d0)),x(2,index_hole(1))-x_init(2,index_hole(1))
            !write (2,1111) Ken,Poten,time_calculated
            
       end if
        
      
      
    enddo
    
  
    
    pause
    
    call  plot(xplot,N,50)
    
    deallocate(x)
    deallocate(x_init)
    deallocate(xplot)
    deallocate(v)
    deallocate(table)
    
    deallocate(acc)
    deallocate(x_0)
    deallocate(v_0_0)
    
    

    deallocate(nabla_W_0_1)
    deallocate(nabla_W_0_2)
    deallocate(F)
    deallocate(Ci)
    deallocate(Ci_new)
    deallocate(Couchy)
    deallocate(PK1)
    
!1100 format (7f10.6,1i3)
 !   1113 format ("Density "1f10.6,/,"Time "1f10.6,/,"Poisson's ratio " 1f10.6,/,"Shear modulus " 1f10.6,/,"Side of a square " 1f10.6,/,"For finite difference " 1f10.6,/,"CFL " 1f10.6,/,"Particle count " 1i3)
    !1110 format (1f22.0,1f23.0)
 !   1111 format (3f10.6)
 !   1112 format (4f10.6)
 1100 format (7f10.6,1i4)
 1113 format ("Density "1f12.6,/,"Time "1f10.6,/,"Poisson's ratio " 1f10.6,/,"Shear modulus " 1f15.6,/,"Side of a square " 1f10.6,/,"For finite difference " 1f10.6,/,"CFL " 1f10.6,/,"Particle count " 1i5)
 1110 format (1i12,1f24.0,1f21.0)
 1111 format (3f13.6)
 1112 format (2f25.6)
    
    end program base
    
    
    function Compute_Viscosity(hi,hj,cs,rho_0,xi,vi,xj,vj)
    

    real*8 :: hi
    real*8 :: hj
    real*8 :: hij
    real*8 :: cs
    real*8 :: rho_0
    
    real*8 :: xi(1:2)
    real*8 :: vi(1:2)

    real*8 :: xj(1:2)
    real*8 :: vj(1:2)
    
    real*8:: xij(1:2)
    real*8 :: vij(1:2)
    
    real*8 :: alpha
    real*8 :: betta
    real*8 :: etta
    real*8 :: fi_ij
    
    xij=xi-xj
    vij=vi-vj
     
    hij=0.5d0*(hi+hj)
    alpha=1.0d0
    betta=2.0d0
    etta=0.01d0
    
     if((vij(1)*xij(1)+vij(2)*xij(2))>=0) then
        Compute_Viscosity=0
        return
     endif
     
    fi_ij=(hij*(vij(1)*xij(1)+vij(2)*xij(2))) / ((sqrt(xij(1)*xij(1)+xij(2)*xij(2))+etta*hij*hij));
    
    Compute_Viscosity=(-alpha*cs*fi_ij + betta*f_ij*fi_ij) / rho_0
    
    end function  Compute_Viscosity
    
    function Compute_W(xi,xj,hi,hj)
        real*8::xi(2)
        real*8::xj(2)
        real*8::hi
        real*8::hj
        
        real*8::r(2)
        real*8::q
        real*8::C
        real*8::KERi
        real*8::KERj
        
        KERi=0.0d0
        KERj=0.0d0
        
        r=xi-xj
        q=sqrt(r(1)*r(1)+r(2)*r(2))/hi
        C=1.0/(3.14159265358979323846*hi*hi)

        if((q>=0)*(q<=1)) then
               KERi=C*(10.0d0 / 7.0d0)*(1.0d0-3.0d0/2.0d0*q*q*(1.0d0-q/2.0d0))
        end if
    
        if ((q > 1) * (q <=2)) then
            KERi = C*(10.0d0 / 7.0d0)*(1.0d0/4.0d0)*(2.0d0 - q)*(2.0d0 - q)*(2.0d0 - q)
        end if
        
        q=sqrt(r(1)*r(1)+r(2)*r(2))/hj
        C=1.0d0/(3.14159265358979323846*hj*hj)

        if((q>=0)*(q<=1)) then
               KERj=C*(10.0d0 / 7.0d0)*(1.0d0-3.0d0/2.0d0*q*q*(1.0d0-q/2.0d0))
        end if
    
        if ((q > 1) * (q <=2)) then
            KERj = C*(10.0d0 / 7.0d0)*(1.0d0/4.0d0)*(2.0d0 - q)*(2.0d0 - q)*(2.0d0 - q)
        end if
        
        
    
    Compute_W=(KERi+KERj)/2.0d0
    end function Compute_W
    
    function det (M)
         real*8 :: M(3,3)
         real*8 ::det
         det=(M(1,1)*M(2,2)-M(1,2)*M(2,1))*M(3,3)
         
    end function det
        
    function trace (M)
            real*8 :: M(3,3)
            real*8 :: trace
            trace=M(1,1)+M(2,2)+M(3,3)
    end function trace
    
  
    
    
    
