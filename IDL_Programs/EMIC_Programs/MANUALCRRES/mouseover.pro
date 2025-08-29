;Programme: MouseOver.pro
;Date: 18/07/02
;Author: Tapuosi Lotoaniu
;Co-Author: Dr. C. L. Waters
;Description: Prints to standard output the X and Y values from the plot.
;
;

Function X00TLab,Value			;Function to format x axis into hours:minutes:seconds.frac
 mSec=long(Value)
 milsec=long(mSec) Mod 1000
 seci=Long(mSec/1000)
 secf = long(seci) mod 60
 mni=Long(seci)/60
 mnf = long(mni) mod 60
 hr = Long(mni/60)
 Return,String(hr,mnf,secf,$
  Format="(I2.2,':',I2.2,':',I2.2)")
end
;
; Main Program
pro mouseover
common orbinfo,orb,orb_binfile,orb_date
common cm_crres,state,cm_eph,cm_val

;***********************************************************
Common BLK5,Ttle,XTtle,YTtle,YRngL,MxFr,MnT,MxT,Scl;,DispArr
Common BLK1,NPnts,SInt,FFTN,DelF,NyqF,MxF,PntRes,NBlocs,NFr
Common BLK2,SpW,SpTyp,Smo
Common BLK3,FrRes,TRes,FBlks
Common BLK4,MnPow,MxPow
common Data,XDat
common poynt,data0,data1,data2,data3
common orbinfo,orb,orb_binfile,orb_date
;common CPow, MxCPow, MnCPow,CPthres,CPArr
common CPow, CPArr
COMMON factR,FACMAX,I0MAX
common Poyntpow, PoyntArr
;***********************************************************
;MnT = cm_val.(0)[0]
;MXT = cm_val.(0)[N_ELEMENTS(]
WIDGET_CONTROL, state.file_info,get_value=fil_info
print,fil_info
;!P.font=-1
!P.Charthick=1.0
if fil_info EQ 'TIME DOMAIN' then $
begin

Docur=1
;WSet,8;WIndx
 If (DoCur EQ 1) Then $
 Begin
  Print,'Press LEFT Button to Get Values'
  Print,'Press RIGHT Button when Finished'
  ;Print,!P.Color
  Lb=''
  REPEAT Begin
   ;XYOUTS,10,10,color=[0],'         ',/device
   Cursor,x,y,/data,/change
   XYOuts,10,10,Lb,color=[0],/device;,size=1    ; Black
   TLab=X00TLab(x)
   Lb=TLab+' '+String(y)
   ;Lb='hellllllooooo'
   color=!d.n_colors-1
  ;XYOuts,10,10,color=[],Lb,/device   ; White
   XYOUTS,10,10,Lb,color=[235],/device;,size=1.0
   GOut=(!err EQ 4)
  End UNTIL GOut
 End
 end else $
 begin
  O_x=!x & O_y=!y
  Ms = 1
  If (Ms EQ 1) Then $
  Begin
 ; WSet,WIndx
  DigiPic,Min(MnT),Max(MxT),NBlocs,YRngL,MxF,NFr,O_x,O_y,TA,FA,NPnts
  end
 endelse
end