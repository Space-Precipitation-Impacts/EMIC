PRO DOO_PLOT,DispArrX,DispArrY,DispArrZ,T
common Arrs,DispX,DispY,DispZ,TT
common uvalues, ff,f2,f3,f4,f5,f6,dat5,ser5,fil_info
common orbinfo,orb,orb_binfile,orb_date
Common BLK34,Xdat,Ydat,Zdat,Dte
Common cm_crres,state,cm_eph,cm_val
Common BLK1,NPnts,SInt,FFTN,DelF,NyqF,MxF,PntRes,NBlocs,NFr
Common BLK2,SpW,SpTyp,Smo
Common BLK4,MnPow,MxPow
Common BLK5,Ttle,XTtle,YTtle,YRngL,MxFr,MnT,MxT,Scl,DispArr
common BLK30, cpchoice_struct
;DpChoice
DispX=DispArrX
DispY=DispArrY
DispZ=DispArrX
TT=T

Set_Plot,'WIN'
LoadCT,13
Device,Decomposed=0
winnum=0
if (dat5 EQ 'ALL E FIELDS') or (dat5 EQ 'ALL B FIELDS') then $
 begin
!P.Multi=[0,1,3]
 Window,winnum+10,XSize=500,YSize=400

Ttle='Power Spectrum for '+'Orbit'+string(orb)+' '+string(orb_date)
MnT=Min(T) & MxT=Max(T)
MxFr=MxF
XTtle='Time (UT)'
YTtle='Frequency (mHz)'
YRngL=0 & Scl=1
DYNTV,DispArrX,Title=Ttle,XTitle=XTtle,YTitle=YTtle,$
 XRange=[Min(T),Max(T)],YRange=[YRngL,MxF],$
 Scale=Scl,Range=[MnPow,MxPow],Aspect=1.5
 ;Window,winnum+1,XSize=500,YSize=400
DYNTV,DispArrY,Title=Ttle,XTitle=XTtle,YTitle=YTtle,$
 XRange=[Min(T),Max(T)],YRange=[YRngL,MxF],$
 Scale=Scl,Range=[MnPow,MxPow],Aspect=1.5
;Window,winnum+2,XSize=500,YSize=400
DYNTV,DispArrZ,Title=Ttle,XTitle=XTtle,YTitle=YTtle,$
 XRange=[Min(T),Max(T)],YRange=[YRngL,MxF],$
 Scale=Scl,Range=[MnPow,MxPow],Aspect=1.5
 widget_control,state.dat_info,$
 set_value='Z min power'+string(float(min(DispArrX)))+' & max power'+string(float(max(DispArrX)))
endif

;dd=['X','Y','Z']
;for ii=1,3 do $
  if dat5 EQ 'EX' or dat5 EQ 'DBX' then $
	begin
 !P.Multi=0
 Window,winnum+10,XSize=500,YSize=400
Ttle='Power Spectrum for '+'Orbit'+string(orb)+' '+string(orb_date)
MnT=Min(T) & MxT=Max(T)
MxFr=MxF
XTtle='Time (UT)'
YTtle='Frequency (mHz)'
YRngL=0 & Scl=1
 DYNTV,DispArrX,Title=Ttle,XTitle=XTtle,YTitle=YTtle,$
 XRange=[Min(T),Max(T)],YRange=[YRngL,MxF],$
 Scale=Scl,Range=[MnPow,MxPow],Aspect=1.5
widget_control,state.dat_info,$
 set_value='min power'+string(float(min(DispArrX)))+' max power'+string(float(max(DispArrX)))
endif

 if dat5 EQ 'EY' or dat5 EQ 'DBY' then $
	begin
 !P.Multi=0
 Window,winnum+10,XSize=500,YSize=400
Ttle='Power Spectrum for '+'Orbit'+string(orb)+' '+string(orb_date)
MnT=Min(T) & MxT=Max(T)
MxFr=MxF
XTtle='Time (UT)'
YTtle='Frequency (mHz)'
YRngL=0 & Scl=1
 DYNTV,DispArrY,Title=Ttle,XTitle=XTtle,YTitle=YTtle,$
 XRange=[Min(T),Max(T)],YRange=[YRngL,MxF],$
 Scale=Scl,Range=[MnPow,MxPow],Aspect=1.5
 widget_control,state.dat_info,$
 set_value='min power'+string(float(min(DispArrY)))+' max power'+string(float(max(DispArrY)))
endif

 if dat5 EQ 'EZ' or dat5 EQ 'DBZ' then $
	begin
 !P.Multi=0
 Window,winnum+10,XSize=500,YSize=400
Ttle='Power Spectrum for '+'Orbit'+string(orb)+' '+string(orb_date)
MnT=Min(T) & MxT=Max(T)
MxFr=MxF
XTtle='Time (UT)'
YTtle='Frequency (mHz)'
YRngL=0 & Scl=1
 DYNTV,DispArrZ,Title=Ttle,XTitle=XTtle,YTitle=YTtle,$
 XRange=[Min(T),Max(T)],YRange=[YRngL,MxF],$
 Scale=Scl,Range=[MnPow,MxPow],Aspect=1.5
widget_control,state.dat_info,$
 set_value='min power'+string(float(min(DispArrZ)))+' max power'+string(float(max(DispArrZ)))
 endif
widget_control,cpchoice_struct.(2),sensitive=1

end