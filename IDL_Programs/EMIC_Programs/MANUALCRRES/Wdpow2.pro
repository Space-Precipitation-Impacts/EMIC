; Widget controlled dynamic power
; spectrum analysis program
;
; Colin Waters
; SPWG, Uni of Newcastle
; Department of Physics
; Written : Dec-Jan, 1997-8
;
; Modifications :
;
FUNCTION XTLab,axis,index,value
 Ti=value
 Hour=Long(Ti)/3600
 Minute=Long(Ti-3600*Hour)/60
RETURN,String(Hour,Minute,$
       Format="(I2.2,':',I2.2)")
end
;
PRO DPChoice_event, ev
Common BLK1,NPnts,SInt,FFTN,DelF,NyqF,MxF,PntRes,NBlocs,NFr
Common BLK2,SpW,SpTyp,Smo
Common BLK3,FrRes,TRes,FBlks   ; Widget IDs
Widget_Control,ev.id,Get_UValue=UVal
Case UVal of
 'FSL' : Begin
          Widget_Control,ev.id,Get_Value=FFTN
          DelF=1000.0/(FFTN*SInt)
          Widget_Control,FrRes,Set_Value='Delta F : '+$
           StrTrim(String(DelF),2)+' mHz'
          NBlocs=Fix((NPnts-FFTN)/PntRes)
          Widget_Control,FBlks,Set_Value='No of FFTs '+StrTrim(String(NBlocs),2)
         end
 'MFS' : Widget_Control,ev.id,Get_Value=MxF
 'PRS' : Begin
          Widget_Control,ev.id,Get_Value=PntRes
          TmRes=PntRes*SInt
          Widget_Control,TRes,Set_Value='Time Res. '+StrTrim(String(TmRes),2)+' Sec'
          NBlocs=Fix((NPnts-FFTN)/PntRes)
          Widget_Control,FBlks,Set_Value='No of FFTs '+StrTrim(String(NBlocs),2)
         end
 'SPW' : Widget_Control,ev.id,Get_Value=SpW
 'TFR' : Widget_Control,ev.id,Get_Value=SpTyp
 'SMC' : Widget_Control,ev.id,Get_Value=Smo
 'DNE' : Widget_Control,ev.top,/DESTROY
 end
END
;
PRO DPChoice
Common BLK1,NPnts,SInt,FFTN,DelF,NyqF,MxF,PntRes,NBlocs,NFr
Common BLK2,SpW,SpTyp,Smo
Common BLK3,FrRes,TRes,FBlks
 base   = Widget_Base(/COLUMN,XSize=190)
 FFTSL  = Widget_Slider(base,value=FFTN,UValue='FSL',$
          Minimum=10,Maximum=1200,Title='FFT Length [Points]')
  DelF=1000.0/(FFTN*SInt)
 FrRes  = Widget_Text(base,value='Delta F : '+ $
           StrTrim(String(DelF),2)+' mHz',UValue='FRR')
 MFSL   = Widget_Slider(base,value=MxF,UValue='MFS',Maximum=NyqF,$
           Title='Max. Freq. [mHz] Nyquist = '+StrTrim(String(NyqF),2)+' mHz')
 PRes   = Widget_Slider(base,value=PntRes,UValue='PRS',Maximum=FFTN,$
          Minimum=1,Title='FFT Step [Points]')
          TmRes=PntRes*SInt
 TRes   = Widget_Text(base,value='Time Res. '+StrTrim(String(TmRes),2)+' Sec.',UValue='TRS')
 FBlks  = Widget_Text(base,value='No of FFTs '+StrTrim(String(NBlocs),2),UValue='FBL')
 SpWgt  = CW_FSlider(base,value=SpW,UValue='SPW',format='(F3.1)',$
          Maximum=5.0,Title='Spectral Weighting',/drag,/Frame)
 FTArr=StrArr(2) & FTArr[0]='Time' & FTArr[1]='Frequency'
 FrTm   = CW_BGroup(base,FTArr,UValue='TFR',$
           Label_top='Smoothing Domain',Set_Value=1,/row,/Exclusive)
 SmArr=StrArr(5)
 For i=0,4 do SmArr(i)=StrTrim(String(i+1),2)
 SmVal  = CW_BGroup(base,SmArr,UValue='SMC',$
           Label_top='Amount of Smoothing',Set_Value=1,/row,/Exclusive)
 DneBut = Widget_Button(base,value='Done',UValue='DNE')
 WIDGET_CONTROL, base, /REALIZE
 XMANAGER, 'DPChoice',base
END
;
PRO OutF_Event,ev
Common BLK1,NPnts,SInt,FFTN,DelF,NyqF,MxF,PntRes,NBlocs,NFr
Common BLK4a,MnPw,MxPw,MnPow,MxPow
Common BLK5,Ttle,XTtle,YTtle,YRngL,MxFr,MnT,MxT,Scl,DispArr
COMMON BLK6,WrF,OutName
 Widget_Control,WrF,Get_Value=OutName
 OpenW,u,OutName(0),/Get_Lun
 PrintF,u,NBlocs,NFr
 PrintF,u,Ttle
 PrintF,u,XTtle
 PrintF,u,YTtle
 PrintF,u,MnT,MxT
 PrintF,u,YRngL,MxFr/1000.0
 PrintF,u,Scl
 PrintF,u,MnPw,MxPw
 PrintF,u,DispArr
 Free_Lun,u
 Widget_Control,ev.top,/DESTROY
end
;
PRO OutF
COMMON BLK6,WrF,OutName
 base2=Widget_Base(Group_Leader=base)
 WrF=Widget_Text(base2,value='********.PIC',UValue='WFL',$
  XOFFSET=10,YOFFSET=50,/EDITABLE)
 Widget_Control, base2,/REALIZE
 XMANAGER,'OutF',base2
end
;
PRO SpChoice_event, ev
Common BLK1,NPnts,SInt,FFTN,DelF,NyqF,MxF,PntRes,NBlocs,NFr
Common BLK2,SpW,SpTyp,Smo
Common BLK4a,MnPw,MxPw,MnPow,MxPow
Common BLK5,Ttle,XTtle,YTtle,YRngL,MxFr,MnT,MxT,Scl,DispArr
Common BLK6,WrF,OutName
Widget_Control,ev.id,Get_UValue=UVal
Case UVal of
 'MNP' : Begin
          Widget_Control,ev.id,Get_Value=MnPw
          If MnPw GT MxPw Then $
          Begin
           Msg=Dialog_Message('Min. Power too Large')
           Widget_Control,ev.id,Set_Value=MxPw-10.
          end
         end
 'MXP' : Begin
          Widget_Control,ev.id,Get_Value=MxPw
          If MxPw LT MnPw Then $
          Begin
           Msg=Dialog_Message('Max. Power too Small')
           Widget_Control,ev.id,Set_Value=MnPw+10.
          end
         end
 'WTF' : Begin
          OutF
         end
 'PAG' : Begin
          Widget_Control,ev.id,Set_Value='Plotting...Please Wait...'
          Window,0,XSize=600,YSize=450
          Erase
          XTtle='Time (UT)' & YTtle='Frequency (mHz)'
          YRngL=0 & Scl=1
          DYNTV,DispArr,Title=Ttle,XTitle=XTtle,YTitle=YTtle,$
           XRange=[MnT,MxT],YRange=[YRngL,MxFr],$
           Scale=Scl,Range=[MnPw,MxPw],Aspect=1.5
          Widget_Control,ev.id,Set_Value='Plot Again'
         end
 'EXP' : Begin
          WDelete,0
          OpenW,u,'C:\TEMP\WDPOW.PAR',/Get_Lun
          Printf,u,FFTN,MxF,PntRes,SpW,SpTyp,Smo
          Free_Lun,u
          Widget_Control,ev.top,/DESTROY
         end
 end
END
;
PRO SpChoice
Common BLK4a,MnPw,MxPw,MnPow,MxPow
 base   = Widget_Base(/COLUMN,XSize=190)
 MnPBut= Widget_Slider(base,value=MnPow,UValue='MNP',$
          Minimum=-150,Maximum=MxPow,Title='Min. Power')
 MxPBut= Widget_Slider(base,value=MxPow,UValue='MXP',$
          Minimum=-150,Maximum=MxPow,Title='Max. Power')
 PAgBut= Widget_Button(base,value='Plot Again',UValue='PAG')
 WFBut = Widget_Button(base,value='Write *.PIC File',UValue='WTF')
 ExBut = Widget_Button(base,value='Exit Program',UValue='EXP')
 WIDGET_CONTROL, base, /REALIZE
 XMANAGER, 'SpChoice',base
END
;
; MAIN PROCEDURE STARTS HERE
;
PRO WDPow2,cm_eph,cm_val,state,Dat5
Common BLK1,NPnts,SInt,FFTN,DelF,NyqF,MxF,PntRes,NBlocs,NFr
Common BLK2,SpW,SpTyp,Smo
Common BLK4a,MnPw,MxPw,MnPow,MxPow
Common BLK5,Ttle,XTtle,YTtle,YRngL,MxFr,MnT,MxT,Scl,DispArr

print,Dat5
valnames=tag_names(cm_val)
Npnts=n_elements(cm_val.(0))
XDat=DblArr(NPnts)
ttt=lonarr(Npnts)
ttt=cm_val.(0)
;stop
;********************************************************************************
;Determine which component to plot
;
for i=0, n_elements(valnames) -1 do $
  if Dat5 EQ valnames[i] then $
	XDat=cm_val.(i)

tp=where(XDat,count)
print,count
if count EQ 0 then $
  Result = DIALOG_MESSAGE(string(Dat5)+' Component has no data !') else $
  begin
;********************************************************************************

StaL='CRRES ORBIT'
Year=2001
Month=10
Day=10
Hour=10
Min=10
Sec=10
SInt=(ttt[1]-ttt[0])/1000.

Dte=String(Day,Month,Year,$
 Format="(I2.2,'/',I2.2,'/',I4.2)")
;XDat=DblArr(NPnts)
;
Print,'Reading from Parameter File...'
OpenR,u,'C:\paul\phd\crres_eph_idl\eph\WDPOW.PAR',/Get_Lun
ReadF,u,FFTN,MxF,PntRes,SpW,SpTyp,Smo
Free_Lun,u

NyqF=Fix(1000.0/(2.0*SInt))
If FFTN GT NPnts Then FFTN=NPnts
DelF=1000.0/(FFTN*SInt)
If PntRes LT 5 Then PntRes=5
NBlocs=Fix((NPnts-FFTN)/PntRes)
DPChoice
;Print,SpTyp,SpW,Smo
NFr=Fix(MxF/DelF)+1
MxF=(NFr-1)*DelF
;
TsArr=DblArr(FFTN)    ; Time Series Array
TrArr=DblArr(FFTN)    ; FFT Array
T=LonArr(NBlocs)
T(0)=ttt(0);Long(Hour)*3600+Long(Min)*60+Long(Sec)
For i=1,NBlocs-1 do $
 T(i)=T(i-1)+Long(PntRes*SInt)
DispArr=DblArr(NBlocs,NFr)
;
Wght=DblArr(NFr)
For i=0,NFr-1 do Wght(i)=Float(i)^SpW
Sum1=0.0
For i=0,FFTN-1 do TsArr(i)=XDat(i)
If (SpTyp EQ 1) Then $
Begin
 Wnd=DblArr(5*Smo)
 For i=0,4*Smo do $
 Begin
  Wnd(i)=Exp(-(Float(i-2*Smo)/Float(Smo))^2)
  Sum1=Sum1+Wnd(i)
 End
 For i=0,4*Smo do Wnd(i)=Wnd(i)/Sum1
 iLFr=2*Smo
 LFr=iLFr*DelF
end
If (SpTyp EQ 0) Then Wnd=Hanning(FFTN)
PTyp=2
;Print,'Power Type [1=Linear, 2=Log10] : '
;
; Major Loop Starts Here
;
Print,'CALCULATING SPECTRUM.... PLEASE WAIT'
SpArr=DblArr(NFr)   ; Double Prec. Spectral Array
For Bloc=0,NBlocs-1 do $
Begin
 DTrend,TsArr,FFTN     ; Call Linear Detrend
 If (SpTyp EQ 0) Then $
  For i=0,FFTN-1 do TsArr(i)=TsArr(i)*Wnd(i)  ; Hanning
 TrArr=FFT(TsArr,1)    ; FFT - BACKWARD so NO 1/N
 For i=0,NFr-1 do $
 Begin
  V1=(ABS(TrArr(i)))^2
  V2=Float(FFTN)
  SpArr(i)=V1/(V2*V2)
 end;
 If (SpTyp EQ 0) Then $   ; Time Domain Window
 Begin
  If (PTyp EQ 1) Then $
   For i=0,NFr-1 do DispArr(Bloc,i)=SpArr(i)*Wght(i)
  If (PTyp EQ 2) Then $
  Begin
   For i=0,NFr-1 do $
   Begin
    SpArr(i)=SpArr(i)*Wght(i)
    If (SpArr(i) GE 1e10) Then SpArr(i)=1e10
    If (SpArr(i) LT 1e-6) Then SpArr(i)=1e-6
    DispArr(Bloc,i)=20*ALog10(SpArr(i))
   end    ; end of i Loop
  end     ; end of If PTyp = 2
 end      ; end of If WndT = 1
 If (SpTyp EQ 1) Then $   ; Frequency Domain Window
 Begin
  For i=0,iLFr-1 do $
  Begin
   DispArr(Bloc,i)=SpArr(i)*Wght(i)
   If (PTyp EQ 2) Then $
   Begin
    If (DispArr(Bloc,i) LT 1e-6) Then DispArr(Bloc,i)=1e-6
    DispArr(Bloc,i)=20.*ALOG10(DispArr(Bloc,i))
   end
  end
  For i=iLFr,NFr-1-2*Smo do $
  Begin
   DispArr(Bloc,i)=0.0
   Js=i-2*Smo
   Je=i+2*Smo
   iWn=-1
   For j=Js,Je do $
   Begin
    iWn=iWn+1
    DispArr(Bloc,i)=DispArr(Bloc,i)+Wnd(iWn)*SpArr(j)
   end    ; end of J loop
   DispArr(Bloc,i)=DispArr(Bloc,i)*Wght(i)
   If (PTyp EQ 2) Then $
   Begin
    If (DispArr(Bloc,i) LT 1e-6) Then DispArr(Bloc,i)=1e-6
    DispArr(Bloc,i)=20*ALog10(DispArr(Bloc,i))
   end    ; end of If PTyp = 2
  end     ; end of I loop
  For i=NFr-2*Smo,NFr-1 do DispArr(Bloc,i)=-120.
 end      ; end of If Freq Domain Filt.
 Posn=(Bloc+1)*PntRes
 For j=0,FFTN-1 do TsArr(j)=XDat(Posn+j) ; New Data
End    ; end Bloc Loop
;
Set_Plot,'WIN'
LoadCT,13
Device,Decomposed=0
;
MnPow=Min(DispArr)
MxPow=Max(DispArr)
MnPw=MnPow & MxPw=MxPow
Ttle=StaL+' Power Spectrum for '+Dte
MnT=Min(T) & MxT=Max(T)
MxFr=MxF
Window,0,XSize=600,YSize=450
XTtle='Time (UT)'
YTtle='Frequency (mHz)'
YRngL=0 & Scl=1
DYNTV,DispArr,Title=Ttle,XTitle=XTtle,YTitle=YTtle,$
 XRange=[Min(T),Max(T)],YRange=[YRngL,MxF],$
 Scale=Scl,Range=[MnPw,MxPw],Aspect=1.5
SpChoice
Print,'Finished'
endelse
end
