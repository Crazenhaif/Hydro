import numpy
import matplotlib.pyplot as plt
import matplotlib.axes as makeaxis

def plothyd(x,rho,u,p,h,plotnum):
        
    start = plotnum*256
    end = (plotnum+1)*256-1
    
    xplt = x[start:end]
    rhoplt = rho[start:end]
    uplt = u[start:end]
    pplt = p[start:end]
    hplt = h[start:end]
    
    rhomax = numpy.amax(abs(rho))
    umax = numpy.amax(abs(u))
    pmax = numpy.amax(abs(p))
    hmax = numpy.amax(abs(h))
    
    rhoplt = rhoplt/rhomax
    uplt = uplt/umax
    pplt = pplt/pmax
    hplt = hplt/hmax
    
    plt.plot(xplt,rhoplt)
    plt.plot(xplt, uplt+1.5, 'r')
    plt.axhline(y=1.5,xmin =0,xmax = 1,color = 'k')
    plt.axhline(y=3,xmin =0,xmax = 1,color = 'k')
    plt.axhline(y=4.5,xmin =0,xmax = 1,color = 'k')
    plt.plot(xplt, pplt+3, 'g')
    plt.plot(xplt,hplt+4.5,'c')
    plt.ylim(0,6)
    plt.xlim(0,1)
    plt.xlabel('x')
    plt.text(-.13, 0.5, 'Density')
    plt.text(-.13, 2, 'Velocity')
    plt.text(-.13, 3.4, 'Pressure')
    plt.text(-.13, 5, 'Entropy')
    plt.savefig(str(plotnum))
    plt.clf()


def main():
    
    data = numpy.genfromtxt('tvd.out')
    x = data[:,0]
    rho = data[:,1]
    u = data[:,2]
    p = data[:,3]
    h = data[:,4]
    
    plotnum = 0
    for i in range(0,99):
        plothyd(x,rho,u,p,h,plotnum)
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
