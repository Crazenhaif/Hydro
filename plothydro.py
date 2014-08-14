import numpy
import matplotlib.pyplot as plt
import matplotlib.axes as makeaxis

def plothyd(x,rho,u,p,h,plotnum,jp,jm,trho,tu,tp):
        
    start = plotnum*256
    end = (plotnum+1)*256-1
    
    xplt = x[start:end]
    rhoplt = rho[start:end]
    uplt = u[start:end]
    pplt = p[start:end]
    hplt = h[start:end]
    jpplt = jp[start:end]
    jmplt = jm[start:end]
    txplt = x[start:end:10]
    trhoplt = trho[start:end:10]
    tuplt = tu[start:end:10]
    tpplt = tp[start:end:10]
    
    rhomax = numpy.amax(abs(rho))
    umax = numpy.amax(abs(u))
    pmax = numpy.amax(abs(p))
    hmax = numpy.amax(abs(h))
    jpmax = numpy.amax(abs(jp))
    jmmax = numpy.amax(abs(jm))
    trhomax = numpy.amax(abs(trho))
    tumax = numpy.amax(abs(tu))
    tpmax = numpy.amax(abs(tp))
    
    rhoplt = rhoplt/rhomax
    uplt = uplt/umax
    pplt = pplt/pmax
    hplt = hplt/hmax
    jpplt = jpplt/(2*jpmax)
    jmplt = jmplt/(2*jmmax)
    trhoplt = trhoplt/trhomax
    tuplt = tuplt/tumax
    tpplt = tpplt/tpmax
    
    plt.plot(xplt,rhoplt)
    plt.plot(txplt, trhoplt, 'kx',markersize=5)
    plt.plot(xplt, uplt+1.5, 'r')
    plt.plot(txplt, tuplt+1.5, 'kx',markersize=5)
    plt.axhline(y=1.5,xmin =0,xmax = 1,color = 'k')
    plt.axhline(y=3,xmin =0,xmax = 1,color = 'k')
    plt.axhline(y=5,xmin =0,xmax = 1,color = 'k')
    plt.plot(xplt, pplt+3, 'g')
    plt.plot(txplt, tpplt+3, 'kx',markersize=5)
    plt.plot(xplt,jpplt+5,'b')
    plt.plot(xplt,jmplt+5,'r')
    plt.ylim(0,6)
    plt.xlim(0,1)
    plt.xlabel('x')
    plt.text(-.13, 0.5, 'Density')
    plt.text(-.13, 2, 'Velocity')
    plt.text(-.13, 3.4, 'Pressure')
    plt.text(-.15, 5.3, 'Jplus(blue)')
    plt.text(-.15, 5.7, 'Jminus(red)')
    plt.savefig(str(plotnum))
    plt.clf()


def main():
    
    data = numpy.genfromtxt('tvd.out')
    x = data[:,0]
    rho = data[:,1]
    u = data[:,2]
    p = data[:,3]
    h = data[:,4]
    jp = data[:,5]
    jm = data[:,6]
    trho = data[:,7]
    tu = data[:,8]
    tp = data[:,9]
    
    plotnum = 0
    for i in range(0,99):
        plothyd(x,rho,u,p,h,plotnum,jp,jm,trho,tu,tp)
        plotnum += 1    
        
        
#    plothyd(x,rho,plotnum)
#    
 #   plotnum += 1
  #  plothyd(x,rho,plotnum)
#
 #   plotnum += 1
  #  plothyd(x,rho,plotnum)
#
 #   plotnum += 1
  #  plothyd(x,rho,plotnum)

main()
