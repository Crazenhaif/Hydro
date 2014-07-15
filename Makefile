copt=  
runhyd: io.o tvd.o
	fort77 -o runhyd io.o tvd.o
io.o: io.f common.inc
	fort77  -c io.f 
tvd.o: tvd.f
	fort77 -c tvd.f
