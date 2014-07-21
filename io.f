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
      write(*,*)'enter left boundary type, ', 
     +'right boundary type, and courant number'
      read(5,*)mbdyl, mbdyr, cour
      write(*,*)'enter tstart, tstop, tdump'
      read(5,*)tstart, tstop, tdump
      close(5)
      k = p1/rho1**gam
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
      jplus = u + 2*gami1*(gam*p/q(1,i))**(0.5)
      jminus = u - 2*gami1*(gam*p/q(1,i))**(0.5)
      trho = (((gam-1.0)*(jplus-jminus)/4.0)**2.0/(gam*k))**gami1
      tp = k*trho**(gam)
      tu = (jplus+jminus)/2.0
      write(10,'(10(1pe15.6))')x(i),q(1,i),u,p, ent, jplus, jminus,
     + trho,tu,tp
100   continue
      return
      end

      subroutine bounds
ccccccccccccccccccccccccccccccccccc
c     boundary conditions
ccccccccccccccccccccccccccccccccccc
      include "common.inc"
      dimension sne(3)
      lflag = 0
      rflag = 0
      if(lflag.ne.0)goto 110
      if(mbdyl.ne.-2)goto 110
c     left open bc
      do 102 i = 1,3
      q(i,-1) = q(i,1)
102   q(i,0)  = q(i,1)
      lflag = 1
110   continue

      if(rflag.ne.0)goto 120
      if(mbdyr.ne.-2)goto 120
      do 103 i = 1,3
c     right open bc
      q(i,nx+1) = q(i,nx)
103   q(i,nx+2) = q(i,nx)
      rflag = 1
120   continue

      data sne/1.,-1,1./
      if(lflag.ne.0)goto 130
      if(mbdyl .ne. 1 .and. lflag .ne. 0)goto 130
c     left reflecting bc
      do 104 i = 1,3
      q(i,-1) = sne(i)*q(i,2)
104   q(i,0)  = sne(i)*q(i,1)
      lflag = 1
130   continue
      
      if(rflag.ne.0)goto 140
      if(mbdyr .ne. 1 .and. rflag .ne. 0)goto 140
c     right reflecting bc
      do 105 i = 1,3
      q(i,nx+1) = sne(i)*q(i,nx)
      q(i,nx+2) = sne(i)*q(i,nx-1)
105   rflag = 1
140   continue
      
      if(rflag .ne. 1 .or. lflag .ne. 1)goto 150
      return
150   continue
      
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
c       print *,'dump at time ',t
        jminusval = q(2,128)/q(1,128) - 2.0*gami1*(gam*
     + ((gam-1.0)*(q(3,128) - 0.5*q(2,128)*q(2,128)/(q(1,128))))
     + /(q(1,128)))**(0.5)
        do 101 i = 1,nx
        u = q(2,i)/q(1,i)
        p = (gam - 1.)*(q(3,i) - 0.5*q(2,i)*q(2,i)/q(1,i))
        ent = p/(q(1,i)**gam)
        jplus = u + 2.0*gami1*(gam*p/q(1,i))**(0.5)
        jminus = u - 2.0*gami1*(gam*p/q(1,i))**(0.5)
	tu = ((gam - 1.0)*jminusval + 2*(x(i)/t))/(gam+1.0)
        trho = ((tu-jminusval)/(2*gami1*(gam*k)**(0.5)))**(2*gami1)
        tp = k *trho**gam
c        trho = (((gam-1.0)*(jplus-jminus)/4.0)**2.0/(gam*k))**gami1
c        tp = k*trho**(gam)
c        tu = (jplus+jminus)/2.0
101     write(10,'(10(1pe15.6))')x(i),q(1,i),u,p,ent,jplus,jminus,
     +   trho,tu,tp
      return
      end
