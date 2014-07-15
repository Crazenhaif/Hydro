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
      write(*,*)'enter left state: rho, u, p'
      read(5,*)rho1, u1, p1
      write(*,*)'enter right state: rho, u, p'
      read(5,*)rho2, u2, p2
      write(*,*)'enter boundary type, courant #'
      read(5,*)mbdy, cour
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
c     if(i .le. nx/3)then
      if(i .le. nx/2)then
      q(1,i) = rho1
      q(2,i) = rho1 * u1
      q(3,i) = gami1*p1 + 0.5*rho1*u1*u1
      p = p1
      else
c     elseif(i. le. 2*nx/3)then
      q(1,i) = rho2
      q(2,i) = rho2 * u2
      q(3,i) = gami1*p2 + 0.5*rho2*u2*u2
      p = p2
c     else
c     q(1,i) = rho1
c     q(2,i) = rho1 * u1
c     q(3,i) = gami1*p1 + 0.5*rho1*u1*u1
c     p = p1
      endif
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
      if(mbdy.ne.-2)goto 110
c     open bc
      do 102 i = 1,3
      q(i,-1) = q(i,1)
      q(i,0)  = q(i,1)
      q(i,nx+1) = q(i,nx)
102   q(i,nx+2) = q(i,nx)
      return
110   continue

      if(mbdy .ne. 1)goto 120
c     reflecting bc
      data sne/1.,-1,1./
      do 103 i = 1,3
      q(i,-1) = sne(i)*q(i,2)
      q(i,0)  = sne(i)*q(i,1)
      q(i,nx+1) = sne(i)*q(i,nx)
103   q(i,nx+2) = sne(i)*q(i,nx-1)
      return
120   continue
c     periodic boundaries
      do 104 i = 1,3
      q(i,-1) = q(i,nx-2)
      q(i,0) = q(i,nx-1)
      q(i,nx+1) = q(i,1)
104   q(i,nx+2) = q(i,2)
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
