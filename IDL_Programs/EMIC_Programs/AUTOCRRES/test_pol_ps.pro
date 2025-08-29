pro test_pol_ps,state,nname
common orbinfo,orb,orb_binfile,orb_date
common init_parameter,idl_path,data_path,eph_path,res_path,eve_path,spl_int,fre_int,log_path
 common datafiles, data_files,no_data,para_struct
x=findgen(300)
R=fltarr(300)
RR=fltarr(300)
for i=0, 299 do $
 begin
 RR[i]=10.0
 x[i]=x[i]/300.*24.
 R[i]=1.0

endfor

fname='Orb'+orb+'_orbita.ps'

set_plot,'ps'
device,filename=FName,yoffset=3, ysize=23
!P.MULTI = 0                     ;                     ;
plot,/polar,RR,X/24.*2*!PI,xrange=[-10,10],yrange=[-10,10],xstyle=4,ystyle=4,$
nsum=5,psym=3,title='Crres Orbit'+string(orb)+' '+string(orb_date),$
xmargin=[5,3],charsize=1.0,/device
oplot,/polar,R,X/24.*2*!PI;,/fill;,xrange=[-12,12],yrange=[-12,12]
axis,0,0,xax=1
axis,0,0,yax=1
xyouts,-5,-12,'Lshell versus'+' '+string(nname),charsize=1.5
xyouts,-10.,-1.0,'12LT'
xyouts,9.,-1.0,'24LT'
xyouts,-2.,-9.7,'18LT'
xyouts,-2.,9.3,'06LT'
end