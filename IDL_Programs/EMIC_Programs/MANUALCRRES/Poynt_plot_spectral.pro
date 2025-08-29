
FUNCTION XTLabps,value
 Ti=value
 Hour=Long(Ti)/3600
 Minute=Long(Ti-3600*Hour)/60
 Secn=Ti-3600*Hour-60*Minute
 RETURN,String(Hour,Minute,$
       Format="(I2.2,':',I2.2)")
end
;
Function YFLab,Val
Return,String(Val,Format="(F5.1)")
end
;
FUNCTION XTLab,axis,index,value
Ti=value
Hour=Long(Ti)/3600
Minute=Long(Ti-3600*Hour)/60
RETURN,String(Hour,Minute,$
       Format="(I2.2,':',I2.2)")
end
;
Function Tim,Sec
 Hr=Long(Sec)/3600
 Mn=Long(Sec-3600*Hr)/60
 Sc=Sec Mod 60
Return,String(hr,mn,sc,$
   Format="(I2.2,':',I2.2,':',i2.2)")
end

pro Ponyt_plot_spectral,Dsx,Dsy,Dsz,dat5,T,MxFr
;common Arrs,DispX,DispY,DispZ,TT
;common uvalues, ff,f2,f3,f4,f5,f6,dat5,ser5,fil_info
common orbinfo,orb,orb_binfile,orb_date
;Common BLK34,Xdat,Ydat,Zdat,Dte
;Common cm_crres,state,cm_eph,cm_val
;Common BLK1,NPnts,SInt,FFTN,DelF,NyqF,MxF,PntRes,NBlocs,NFr
;Common BLK2,SpW,SpTyp,Smo
;Common BLK4,MnPow,MxPow
;Common BLK5,Ttle,XTtle,YTtle,YRngL,MxFr,MnT,MxT,Scl,DispArr
winnum=1
if dat5 EQ 'ALL FIELDS' then $
 begin
 Set_Plot,'WIN'
 Device,decomposed=0
 REPEAT Begin
 PAgn=0
 Print,'Minimum Sx is ',Min(Dsx)
 Print,'Maximum Sx is ',Max(Dsx)
 Print,'Minimum Sy is ',Min(Dsy)
 Print,'Maximum Sy is ',Max(Dsy)
 Print,'Minimum Sz is ',Min(Dsz)
 Print,'Maximum Sz is ',Max(Dsz)

 Print,'Enter Minimum for Plot :'
 Read,MnRng
 Print,'Enter Maximum for Plot :'
 Read,MxRng
 YRngL=0
 Scl=1
 XTtle='Time (UT)'
 YTtle='Frequency (mHz)'
 Erase
 LoadCT,13 ; 20
 !P.Multi=[0,1,3]
 Window,winnum,XSize=500,YSize=400
 Ttle=' Sx '
 DYNTV,Dsx,Title=Ttle,XTitle=XTtle,YTitle=YTtle,$
  XRange=[Min(T),Max(T)],YRange=[YRngL,MxFr],$
  Scale=Scl,Range=[MnRng,MxRng],Aspect=1.5

 Window,winnum+1,XSize=500,YSize=400
 Ttle=' Sy '
 DYNTV,Dsy,Title=Ttle,XTitle=XTtle,YTitle=YTtle,$
  XRange=[Min(T),Max(T)],YRange=[YRngL,MxFr],$
  Scale=Scl,Range=[MnRng,MxRng],Aspect=1.5

 Window,winnum+2,XSize=500,YSize=400
 Ttle=' Sz '
 DYNTV,Dsz,Title=Ttle,XTitle=XTtle,YTitle=YTtle,$
  XRange=[Min(T),Max(T)],YRange=[YRngL,MxFr],$
  Scale=Scl,Range=[MnRng,MxRng],Aspect=1.5
 Print,'Another Plot at Different Colour Range [0=YES]'
 Read,Agn1
 PAg=Agn1 NE 0
end UNTIL PAg
endif
;**********************************************************************************
if dat5 EQ 'SX' then $
 begin
 Set_Plot,'WIN'
 Device,decomposed=0
 REPEAT Begin
 PAgn=0
 Print,'Minimum Sx is ',Min(Dsx)
 Print,'Maximum Sx is ',Max(Dsx)

 Print,'Enter Minimum for Plot :'
 Read,MnRng
 Print,'Enter Maximum for Plot :'
 Read,MxRng
 YRngL=0
 Scl=1
 XTtle='Time (UT)'
 YTtle='Frequency (mHz)'
 Erase
 LoadCT,13 ; 20
!P.Multi=0

 Window,winnum,XSize=500,YSize=400
 Ttle=' Sx '
 DYNTV,Dsx,Title=Ttle,XTitle=XTtle,YTitle=YTtle,$
  XRange=[Min(T),Max(T)],YRange=[YRngL,MxFr],$
  Scale=Scl,Range=[MnRng,MxRng],Aspect=1.5

  Print,'Another Plot at Different Colour Range [0=YES]'
 Read,Agn1
 PAg=Agn1 NE 0
end UNTIL PAg
endif
;*************************************************************************************
if dat5 EQ 'SY' then $
 begin
 Set_Plot,'WIN'
 Device,decomposed=0
 REPEAT Begin
 PAgn=0
 Print,'Minimum Sy is ',Min(Dsy)
 Print,'Maximum Sy is ',Max(Dsy)

 Print,'Enter Minimum for Plot :'
 Read,MnRng
 Print,'Enter Maximum for Plot :'
 Read,MxRng
 YRngL=0
 Scl=1
 XTtle='Time (UT)'
 YTtle='Frequency (mHz)'
 Erase
 LoadCT,13 ; 20
!P.Multi=0

 Window,winnum+1,XSize=500,YSize=400
 Ttle=' Sy '
 DYNTV,Dsy,Title=Ttle,XTitle=XTtle,YTitle=YTtle,$
  XRange=[Min(T),Max(T)],YRange=[YRngL,MxFr],$
  Scale=Scl,Range=[MnRng,MxRng],Aspect=1.5

 Print,'Another Plot at Different Colour Range [0=YES]'
 Read,Agn1
 PAg=Agn1 NE 0
end UNTIL PAg
endif
;*********************************************************************************
if dat5 EQ 'SZ' then $
 begin
 Set_Plot,'WIN'
 Device,decomposed=0
 REPEAT Begin
 PAgn=0
 Print,'Minimum Sz is ',Min(Dsz)
 Print,'Maximum Sz is ',Max(Dsz)

 Print,'Enter Minimum for Plot :'
 Read,MnRng
 Print,'Enter Maximum for Plot :'
 Read,MxRng
 YRngL=0
 Scl=1
 XTtle='Time (UT)'
 YTtle='Frequency (mHz)'
 Erase
 LoadCT,13 ; 20
!P.Multi=0

 Window,winnum+2,XSize=500,YSize=400
 Ttle=' Sz '
 DYNTV,Dsz,Title=Ttle,XTitle=XTtle,YTitle=YTtle,$
  XRange=[Min(T),Max(T)],YRange=[YRngL,MxFr],$
  Scale=Scl,Range=[MnRng,MxRng],Aspect=1.5
 Print,'Another Plot at Different Colour Range [0=YES]'
 Read,Agn1
 PAg=Agn1 NE 0
end UNTIL PAg
endif

end