; Program to DeSpike Time Series Data
;
;  C Waters Sept 1995
;
Function Tim,Value
 mSec=long(Value)
 milsec=long(mSec) Mod 1000
 seci=Long(mSec/1000)
 secf = long(seci) mod 60
 mni=Long(seci)/60
 mnf = long(mni) mod 60
 hr = Long(mni/60)
 Return,String(hr,mnf,secf,$
  Format="(I2.2,':',I2.2,':',I0)")
end
;
; Main
pro Despike_old,cm_eph,cm_val,state
common orbinfo,orb,orb_binfile,orb_date
Strt=1
Strt=Strt-1
numcmv=1
lim=1.0
leng = n_elements(cm_val.(numcmv))
NPnts=Leng
XDat=FltArr(NPnts)
XDat=cm_val.(numcmv)
XPDat=DblArr(Leng)
YPDat=DblArr(Leng)

;
; Read in Data Segment
;
For i=0,Leng-1 do $
XPDat(i)=XDat(Strt+i)
;DTrend,XPDat,Leng
;stop
ind='index'
vl='value'
openw,uu,'Orb'+STRING(orb)+'despiked1.val',/get_lun
printf,uu,'Orbit: '+STRING(orb)+' '+string(orb_date)
printf,uu,'   '+string(ind)+'      '+string(vl)
mx = abs(xpdat)
mx=max(mx)
For i=0,Leng-2 do $
Begin
Diff=abs(XpDat(i+1)-XpDat(i))/mx
;print,diff
;stop
;YPDat(i)=XPDat(i)
 	if (Diff GE lim) then $
	;if (abs(XDat(i)) GE lim) then $
;stop
 	begin
		j=i
		spk=XDat(i)
		;stop
		if j GE 5 and j LE n_elements(XDat)-5 then $
		begin
	;		medmarr=fltarr(8)
	;		for ii=0,7 do $
	;		begin
	;		medmarr[7-ii]=XDat[j+ii+1]
	;		medmarr[ii]=XDat[j-ii-1]
		;stop
	;		end
			;totnbr=median(medmarr,/even)
		;	stop
			sumnbrplus=XPDat[j+1]+XPDat[j+2]+XPDat[j+3]+XPDat[j+4]
			sumnbrminus=XPDat[j-1]+XPDat[j-2]+XPDat[j-3]+XPDat[j-4]
			;;print,i,YPDat(i)
			totnbr=(sumnbrplus+sumnbrminus)/8.0
			;totnbr=(sumnbrplus)/8.0

		;	stop
			;YPdat(i)=totnbr
			;cm_val.(numcmv)[i]=YPDat(i)
			;cm_val.(numcmv)[i]=10.0
			;stop
			cm_val.(numcmv)[i]=totnbr
			;stop
			print,i,spk
			print,i,totnbr
			printf,uu,i,XDat(i)
		end else $
			begin
			totnbr=XpDat[0:9]/10.0
			printf,uu,i,XDat(i)
			;stop
			cm_val.(numcmv)[i]=total(totnbr)/10.0
			;cm_val.(numcmv)[i]=10.0
		end
	end
End
Free_lun,uu
!P.Multi=[0,1,2]
window,0,xsize=500,ysize=500
;!Y.Range=[-100,100]
;!X.Range=[Min(T),Max(T)]
Plot,cm_val.(0),XDat,TiTle='Original',XTitle='Time (UT)',$
 YTitle='Amplitude',XStyle=1,ystyle=1,XTickFormat='XTLab'
;!Y.Range=[-100,100]
Plot,cm_val.(0),cm_val.(numcmv),Title='DeSpiked',XTitle='Time (UT)',$
 YTitle='Amplitude',XStyle=1,ystyle=1,XTickFormat='XTLab'
!P.Multi=0
YPdat=0.0
XPdat=0.0
XDiff=0.0
;FName=''
;Print,'Enter OutPut File Name : '
;Read,FName
;OpenW,u,FName,/Get_Lun
;If (IFmt EQ 1) Then $
; PrintF,u,Format='(1x,A4,5I5,1x,2F5.1,I5)',$
;  StaL,Year,Month,Day,Hr,Mn,Sc,SInt,Leng
;If (IFmt EQ 2) Then $
; PrintF,u,Format='(1x,A4,4I5,1x,2F5.1,I5)',$
;  StaL,Year,Day,Hr,Mn,Sc,SInt,Leng
; For i=0,Leng-1 do $
;  PrintF,u,XPDat(i)
 Free_Lun,uu
;End
Print,'Finished.'
;stop
End