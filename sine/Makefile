copt=  
runhyd: io.o tvd.o
	f77 -o runhyd io.o tvd.o
io.o: io.f common.inc
	f77  -c io.f 
tvd.o: tvd.f
	f77 -c tvd.f
clean: 
	rm *.o *~
nopics:
	rm *.png
