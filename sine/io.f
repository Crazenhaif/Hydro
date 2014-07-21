c  io for Dongsu Ryu`s TVD routine
c  twj: July 1992
      program tvdhyd
      include "common.inc"
      open(unit = 10,file = 'tvd.out')
      call init
      t = tstart
      delt = 0.
      niter = 0
      dumpt = t + tdump
110   call bounds
      t = t + dt
c     call tvd
      call tvd(q, w1, w2, nx)
      niter = niter + 1
c     print *,'niter, dt, t, dumpt ',niter,dt, t, dumpt
      if(t .ge. dumpt)then
      call out
        dumpt = dumpt + tdump
      else
      endif
      if(t .lt. tstop)goto 110
      stop 
      end

      subroutine init 
cccccccccccccccccccccccccccccccccccc
c     inputs
cccccccccccccccccccccccccccccccccccc
      include "common.inc"
      gam = 5./3.
      gami1 = 1./(gam -1.)
      open(unit = 5, file = 'input')
      write(*,*)'enter equilibrium density, velocity and pressure'
      read(5,*)rhoE, uE, pE
      write(*,*)'enter amplitude of density, velocity, and pressure'
      read(5,*)rhoA, uA, pA
      write(*,*)'enter wavenumber of density, velocity, and pressure'
      read(5,*)rhok,uk,pk
      write(*,*)'enter phase of density, velocity, and pressure'
      read(5,*)rho0,u0,p0
      write(*,*)'enter right boundary type, ', 
     +'left boundary type, and courant number'
      read(5,*)mbdyl, mbdyr, cour
      write(*,*)'enter tstart, tstop, tdump'
      read(5,*)tstart, tstop, tdump
      close(5)
      xmin = 0.
      xmax = 1.
      dx = (xmax - xmin)/float(nx)
c     initial conditions
c     write dump of initial values
      do 100 i = -1, nx+2
      x(i) = xmin +(i - 0.5)*dx
      q(1,i) = rhoA * SIN(rhok*x(i)+rho0) +rhoE
      q(2,i) = uA * SIN(uk*x(i)+u0) * q(1,i) + uE
      p = pA*SIN(pk*x(i)+p0) + pE
      q(3,i) = gami1*p + 0.5*q(2,i)*q(2,i)/(q(1,i))
      if(i.lt.1 .or. i .gt. nx)goto 100
      u = q(2,i)/q(1,i)
      ent = p/(q(1,i)**gam)
      write(10,'(5(1pe15.6))')x(i),q(1,i),u,p, ent
100   continue
      return
      end

      subroutine bounds
ccccccccccccccccccccccccccccccccccc
c     boundary conditions
ccccccccccccccccccccccccccccccccccc
      include "common.inc"
      dimension sne(3)
      if(mbdyl.ne.-2)goto 110
c     left open bc
      do 102 i = 1,3
      q(i,-1) = q(i,1)
102   q(i,0)  = q(i,1)
      return
110   continue

      if(mbdyr.ne.-2)goto 120
      do 103 i = 1,3
c     right open bc
      q(i,nx+1) = q(i,nx)
103   q(i,nx+2) = q(i,nx)
      return
120   continue

      data sne/1.,-1,1./
      if(mbdyl .ne. 1)goto 130
c     left reflecting bc
      do 104 i = 1,3
      q(i,-1) = sne(i)*q(i,2)
104   q(i,0)  = sne(i)*q(i,1)
      return
130   continue

      if(mbdyr .ne. 1)goto 140
c     right reflecting bc
      do 105 i = 1,3
      q(i,nx+1) = sne(i)*q(i,nx)
105   q(i,nx+2) = sne(i)*q(i,nx-1)
      return
140   continue

c     periodic boundaries
      do 106 i = 1,3
      q(i,-1) = q(i,nx-2)
      q(i,0) = q(i,nx-1)
      q(i,nx+1) = q(i,1)
106   q(i,nx+2) = q(i,2)
      end

      subroutine out
cccccccccccccccccccccccccccccccccccc
c     output data
cccccccccccccccccccccccccccccccccccc
      include "common.inc"
        print *,'dump at time ',t
        do 101 i = 1,nx
        u = q(2,i)/q(1,i)
        p = (gam - 1.)*(q(3,i) - 0.5*q(2,i)*q(2,i)/q(1,i))
        ent = p/(q(1,i)**gam)
101     write(10,'(5(1pe15.6))')x(i),q(1,i),u,p, ent
      return
      end
