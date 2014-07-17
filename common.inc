      parameter (nx = 256)

      real*8 q(5,-1:nx+2), w1(40,-1:nx+2), w2(100,-1:nx+2), x(-1:nx+2)
      real*8 gam, gami1, dx, t, dt, cour, eps, k
      real jplus, jminus, tu, trho, tp

      common/hydro/w1, w2, x, q, t
      common/param0/ tstart, tstop, tdelta, nstep, mbdyl, mbdyr
      common/param/ gam, gami1, cour, eps, dx, dt, k
      common/param2/delt,tdump
