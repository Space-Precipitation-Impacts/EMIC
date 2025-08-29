;  Program to Calculate Dynamic Cross Power
; and Cross Phase plots with the option of Log10
; or linear power, Time or Freq. Domain Smoothing
;
; C. L. Waters
; Canadian Network for Space Research
; University of Alberta
; Edmonton, Alberta, CANADA
; January, 1994
;
; Modification History :
;
; March, 1996 : Added Xph Index Rej Routine : CW
; Nov.,  1996 : Added point shift simulation : CW
; July,  1997 : Added routine so point shift could
;               cycle through colours properly: CW
; July,  1998 : Revised to control program by WIDGETS : CW
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
;
PRO PntPlotChoice_event, ev
Common csblk2,PltTyp,EqStrt,PolStrt
Widget_Control,ev.id,Get_UValue=UVal
Case UVal of
 'EPNT' : Widget_Control,ev.id,Get_Value=EqStrt
 'PPNT' : Widget_Control,ev.id,Get_Value=PolStrt
 'PTY' :  Widget_Control,ev.id,Get_Value=PltTyp
 'DNE' : Widget_Control,ev.top,/DESTROY
 end
END
;
PRO PntPlotChoice
Common csblk2,PltTyp,EqStrt,PolStrt
 base   = Widget_Base(/COLUMN,XSize=190)
 EQPnt  = Widget_Slider(base,value=EqStrt,UValue='EPNT',$
          Minimum=1,Maximum=100,Title='Start Point [EQU File]')
 PLPnt  = Widget_Slider(base,value=PolStrt,UValue='PPNT',$
          Minimum=1,Maximum=100,Title='Start Point [POL File]')
 PltArr =['Cross Power','Cross Phase']
 CSPTyp = CW_BGroup(base,PltArr,UValue='PTY',$
           Label_top='Spectrum Type',Set_Value=PltTyp,/row,/Exclusive)
 DneBut = Widget_Button(base,value='Done',UValue='DNE')
 WIDGET_CONTROL, base, /REALIZE
 XMANAGER, 'PntPlotChoice',base
END
;
PRO ParChoice_event, ev
Common csblk1,NPnts,SInt,FFTN,DelF,NyqF,MxF,PntRes,NBlocs,NFr,SpW,Smo,WndT
Common csblk3,FrRes,TRes,FBlks
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
 'TFR' : Widget_Control,ev.id,Get_Value=WndT
 'SMC' : Widget_Control,ev.id,Get_Value=Smo
 'DNE' : Widget_Control,ev.top,/DESTROY
 end
END
;
PRO ParChoice
Common csblk1,NPnts,SInt,FFTN,DelF,NyqF,MxF,PntRes,NBlocs,NFr,SpW,Smo,WndT
Common csblk3,FrRes,TRes,FBlks
 base   = Widget_Base(/COLUMN,XSize=190)
 FFTSL  = Widget_Slider(base,value=FFTN,UValue='FSL',$
          Minimum=10,Maximum=1800,Title='FFT Length [Points]')
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
           Label_top='Smoothing Domain',Set_Value=WndT,/row,/Exclusive)
 SmArr=StrArr(5)
 For i=0,4 do SmArr(i)=StrTrim(String(i+1),2)
 SmVal  = CW_BGroup(base,SmArr,UValue='SMC',$
           Label_top='Amount of Smoothing',Set_Value=Smo,/row,/Exclusive)
 DneBut = Widget_Button(base,value='Done',UValue='DNE')
 WIDGET_CONTROL, base, /REALIZE
 XMANAGER, 'ParChoice',base
END
;
PRO OutF_Event,ev
Common csblk1,NPnts,SInt,FFTN,DelF,NyqF,MxF,PntRes,NBlocs,NFr,SpW,Smo,WndT
Common csblk2,PltTyp,EqStrt,PolStrt
Common csblk4,MnPw,MxPw,MnPow,MxPow
Common csblk5,Ttle,XTtle,YTtle,YRngL,MnT,MxT,Scl,DispArr,$
              TmpCPhArr,CPow,XStaL,YStaL,XDte
Common csblk6,WrF,OutName
Common csblk7,CPhRej,CPhCorr,MnPh,MxPh,EnhPh,PShft,CPwRej
 Widget_Control,WrF,Get_Value=OutName
 OpenW,u,OutName(0),/Get_Lun
 PrintF,u,NBlocs,NFr
 PrintF,u,Ttle
 PrintF,u,XTtle
 PrintF,u,YTtle
 PrintF,u,MnT,MxT
 PrintF,u,YRngL,MxF/1000.0
 PrintF,u,Scl
 If PltTyp EQ 0 Then $
  PrintF,u,MnPw,MxPw
 If PltTyp EQ 1 Then $
  PrintF,u,MnPh,MxPh
 PrintF,u,DispArr
 Free_Lun,u
 Widget_Control,ev.top,/DESTROY
end
;
PRO OutF
COMMON csblk6,WrF,OutName
 base2=Widget_Base(Group_Leader=base)
 WrF=Widget_Text(base2,value='********.PIC',UValue='WFL',$
  XOFFSET=10,YOFFSET=50,/EDITABLE)
 Widget_Control, base2,/REALIZE
 XMANAGER,'OutF',base2
end
;
PRO CPwChoice_event, ev
Common csblk1,NPnts,SInt,FFTN,DelF,NyqF,MxF,PntRes,NBlocs,NFr,SpW,Smo,WndT
Common csblk2,PltTyp,EqStrt,PolStrt
Common csblk4,MnPw,MxPw,MnPow,MxPow
Common csblk5,Ttle,XTtle,YTtle,YRngL,MnT,MxT,Scl,DispArr,$
              TmpCPhArr,CPow,XStaL,YStaL,XDte
Common csblk6,WrF,OutName
Common csblk7,CPhRej,CPhCorr,MnPh,MxPh,EnhPh,PShft,CPwRej
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
          Widget_Control,ev.id,Set_Value='PLOTTING....Please Wait.....'
          TTle=XStaL+':'+YStaL+' Cross Power for '+XDte
          XTtle='Time (UT)'
          YTtle='Frequency (mHz)'
          Scl=1
          Window,0,XSize=600,YSize=450
          DYNTV,DispArr,Title=Ttle,XTitle=XTtle,YTitle=YTtle,$
           XRange=[MnT,MxT],YRange=[YRngL,MxF],$
           Scale=Scl,Range=[MnPw,MxPw],Aspect=1.5
          Widget_Control,ev.id,Set_Value='Plot Again'
         end
 'EXP' : Begin
          WDelete,0
          OpenW,u,'C:\TEMP\WDCSANL.PAR',/Get_Lun
          PrintF,u,FFTN,MxF,PntRes,SpW,PltTyp,WndT,Smo,MnPh,MxPh,$
           PShft,CPwRej,CPhRej,CPhCorr,EnhPh,MnPw,MxPw
          Free_Lun,u
          Widget_Control,ev.top,/DESTROY
         end
 end
END
;
PRO CPwChoice
Common csblk4,MnPw,MxPw,MnPow,MxPow
 base   = Widget_Base(/COLUMN,XSize=190)
 MnP   = Widget_Text(base,value='Min. Power: '+StrTrim(String(MnPow),2))
 MxP   = Widget_Text(base,value='Max. Power: '+StrTrim(String(MxPow),2))
 MnPBut= Widget_Slider(base,value=MnPw,UValue='MNP',$
          Minimum=MnPow,Maximum=MxPow,Title='Min. Power')
 MxPBut= Widget_Slider(base,value=MxPw,UValue='MXP',$
          Minimum=MnPow,Maximum=MxPow,Title='Max. Power')
 PAgBut= Widget_Button(base,value='PLOT Cross Power',UValue='PAG')
 WFBut = Widget_Button(base,value='Write *.PIC File',UValue='WTF')
 ExBut = Widget_Button(base,value='Exit Program',UValue='EXP')
 WIDGET_CONTROL, base, /REALIZE
 XMANAGER, 'CPwChoice',base
END
;
PRO CPhChoice_event, ev
Common csblk1,NPnts,SInt,FFTN,DelF,NyqF,MxF,PntRes,NBlocs,NFr,SpW,Smo,WndT
Common csblk2,PltTyp,EqStrt,PolStrt
Common csblk4,MnPw,MxPw,MnPow,MxPow
Common csblk5,Ttle,XTtle,YTtle,YRngL,MnT,MxT,Scl,DispArr,$
              TmpCPhArr,CPow,XStaL,YStaL,XDte
Common csblk6,WrF,OutName
Common csblk7,CPhRej,CPhCorr,MnPh,MxPh,EnhPh,PShft,CPwRej
Common csblk8, DMsBut
Widget_Control,ev.id,Get_UValue=UVal
Case UVal of
 'MSE' : Begin
          Widget_control,ev.id,Set_Value='Press RIGHT Button to Close..'
          Lb='                                                     '
          REPEAT Begin
           Cursor,x,y,/data,/down
           XYOuts,10,10,color=0,Lb,/device    ; Black
           TLab=Tim(x)
           color=!d.n_colors-1
           GOut=(!err EQ 4)
           a=fix(((x-MnT)/(PntRes*SInt)))-1
           b=fix(y/DelF)-1
           cph=Disparr(a,b)
           Lb=TLab+' '+StrTrim(String(y),2)+' mHz '+StrTrim(String(cph),2)+' deg'
           XYOuts,10,10,color=[235],Lb,/device   ; White
          End UNTIL GOut
          Widget_Control,ev.id, Set_Value='Active Mouse'
         End
 'PSH' : Widget_Control,ev.id,Get_Value=PShft
'CPWRJ': Widget_Control,ev.id,Get_Value=CPwRej
'CPHRJ': Widget_Control,ev.id,Get_Value=CPhRej
'PHCR' : Widget_Control,ev.id,Get_Value=CPhCorr
'MNPH' : Widget_Control,ev.id,Get_Value=MnPh
'MXPH' : Widget_Control,ev.id,Get_Value=MxPh
'ENP'  : Widget_Control,ev.id,Get_Value=EnhPh
 'WTF' :  OutF
 'PAG' : Begin
          Widget_Control,ev.id,Set_Value='PLOTTING....Please Wait.....'
          Widget_Control,/Hourglass
          GetPhCol
          DispArr=TmpCPhArr
          PShArr=DblArr(NFr)
          For kk=0,NFr-1 do PShArr(kk)=PShft*SInt*DelF*kk*0.360

;          Print,'Sorting Through XPH Array...'
          For kk=0,NBlocs-1 do $
          Begin
           For mm=0,NFr-1 do $
           Begin
            If DispArr(kk,mm) NE -200.0 Then $
            Begin
             DispArr(kk,mm)=DispArr(kk,mm)+PShArr(mm) MOD 360    ; apply point shift
             If DispArr(kk,mm) LT -180 Then DispArr(kk,mm)=DispArr(kk,mm)+360.
             If DispArr(kk,mm) GT 180 Then DispArr(kk,mm)=DispArr(kk,mm)-360.
            end
           end    ; Freq Loop
          end     ; Bloc Loop
          XPhCoh,DispArr,CPhCorr,CPhRej,MnPh-1 ; Do XPH neighbour rejection
          For kk=0,NBlocs-1 do $
          Begin
           For mm=0,NFr-1 do $
           Begin
            If DispArr(kk,mm) NE -200.0 Then $
            Begin
             If (EnhPh EQ 0) Then DispArr(kk,mm)=DispArr(kk,mm)^3/MxPh^2
             CPMag=CPow(kk,mm)
             If (CPMag LE CPwRej) Then DispArr(kk,mm)=-200.0
             If (DispArr(kk,mm) GT MxPh) Then DispArr(kk,mm)=-200.0
             If (DispArr(kk,mm) LT MnPh) Then DispArr(kk,mm)=-200.0
            end
           end
          end
          XTtle='Time (LT)' & Scl=1
          YTtle='Frequency (mHz)'
          TTle=XStaL+':'+YStaL+' Cross Phase for '+XDte
          Window,0,XSize=500,YSize=400
          DYNTV,DispArr,Title=TTle,XTitle=XTtle,YTitle=YTtle,$
           XRange=[MnT,MxT],YRange=[YRngL,MxF],$
           Scale=Scl,Range=[MnPh,MxPh],Aspect=1.5
          Widget_Control,ev.id,Set_Value='Plot Again'
          Widget_Control,DMsBut,Sensitive=1  ; Activate Mouse Buuton
         end
 'EXP' : Begin
          WDelete,0
          OpenW,u,'C:\TEMP\WDCSANL.PAR',/Get_Lun
          PrintF,u,FFTN,MxF,PntRes,SpW,PltTyp,WndT,Smo,MnPh,MxPh,$
           PShft,CPwRej,CPhRej,CPhCorr,EnhPh,MnPw,MxPw
          Free_Lun,u
          Widget_Control,ev.top,/DESTROY
         end
 end
END
;
PRO CPhChoice
Common csblk4,MnPw,MxPw,MnPow,MxPow
Common csblk7,CPhRej,CPhCorr,MnPh,MxPh,EnhPh,PShft,CPwRej
Common csblk8,DMsBut
 base   = Widget_Base(/COLUMN,XSize=190)
 PShSl  = CW_FSlider(base,value=PShft,UValue='PSH',format='(F6.3)',$
          Minimum=-30.0,Maximum=30.0,Title='Point Shift',/drag,/Frame)
 MnP   =  Widget_Text(base,value='Min. Power: '+StrTrim(String(MnPow),2))
 MxP   =  Widget_Text(base,value='Max. Power: '+StrTrim(String(MxPow),2))
 CPwRBut= Widget_Slider(base,value=CPwRej,UValue='CPWRJ',$
          Minimum=-120,Maximum=40,Title='Cross Power Rejection')
 CPhRBut= Widget_Slider(base,value=CPhRej,UValue='CPHRJ',$
          Minimum=0,Maximum=60,Title='Cross Phase Range for Rejection')
 PhCrBut= Widget_Slider(base,value=CPhCorr,UValue='PHCR',$
          Minimum=0,Maximum=9,Title='Cross Phases Within Range')
 MnPhBut= Widget_Slider(base,value=MnPh,UValue='MNPH',$
          Minimum=-180,Maximum=180,Title='Minimum Phase')
 MxPhBut= Widget_Slider(base,value=MxPh,UValue='MXPH',$
          Minimum=-180,Maximum=180,Title='Maximum Phase')
 EnPhs=['Yes','No']
 EnPhse = CW_BGroup(base,EnPhs,UValue='ENP',$
           Label_top='Enhance Phase ?',Set_Value=1,/row,/Exclusive)
 PAgBut= Widget_Button(base,value='PLOT Cross Phase',UValue='PAG')
 DMsBut = Widget_Button(base,value='Activate Mouse',UValue='MSE')
 Widget_Control,DMsBut,Sensitive=0
 WFBut = Widget_Button(base,value='Write *.PIC File',UValue='WTF')
 ExBut = Widget_Button(base,value='Exit Program',UValue='EXP')
 WIDGET_CONTROL, base, /REALIZE
 XMANAGER, 'CPhChoice',base
END
;
; MAIN PROCEDURE STARTS HERE
;
PRO wdcspanl
Common csblk1,NPnts,SInt,FFTN,DelF,NyqF,MxF,PntRes,NBlocs,NFr,SpW,Smo,WndT
Common csblk2,PltTyp,EqStrt,PolStrt
Common csblk4,MnPw,MxPw,MnPow,MxPow
Common csblk5,Ttle,XTtle,YTtle,YRngL,MnT,MxT,Scl,DispArr,$
              TmpCPhArr,CPow,XStaL,YStaL,XDte
Common csblk6,WrF,OutName
Common csblk7,CPhRej,CPhCorr,MnPh,MxPh,EnhPh,PShft,CPwRej
FName='' & StaL='' & IFmt=1  ;Data Format [1=CLW, 2=JCS]
!P.Multi=0
RaDeg=180.0/!Pi
XFName='' & YFName=''
XStaL='' & YStaL=''
FTtle='Select EQUATORIAL Data'
XFName=Dialog_PickFile(Title=FTtle,Filter='*.*')
OpenR,u,XFName,/Get_Lun
; Samson
If IFmt EQ 0 Then $
Begin
 ReadF,u,Format='(1x,A4,4I5,1x,2F5.1,I5)',$
  XStaL,XYear,XDay,XHour,XMin,XSec,XSInt,XPnts
 XDte=String(XDay,XYear,$
 Format="(I3.2,'/',I4.2)")
end
; Waters Data Format
If IFmt EQ 1 Then $
Begin
 ReadF,u,Format='(1x,A4,5I5,1x,2F5.1,I5)',$
  XStaL,XYear,XMonth,XDay,XHour,XMin,XSec,XSInt,XPnts
 XDte=String(XDay,XMonth,XYear,$
  Format="(I2.2,'/',I2.2,'/',I4.2)")
end
XDat=DblArr(XPnts)
ReadF,u,XDat
Free_Lun,u
FTtle='Select POLEWARD Data'
YFName=Dialog_PickFile(Title=FTtle,Filter='*.*')
OpenR,u,YFName,/Get_Lun
; Samson
If IFmt EQ 0 Then $
Begin
 ReadF,u,Format='(1x,A4,4I5,1x,2F5.1,I5)',$
  YStaL,YYear,YDay,YHour,YMin,YSec,YSInt,YPnts
 Dte=String(YDay,YYear,$
  Format="(I3.2,'/',I4.2)")
end
; Waters
If IFmt EQ 1 Then $
Begin
 ReadF,u,Format='(1x,A4,5I5,1x,2F5.1,I5)',$
  YStaL,YYear,YMonth,YDay,YHour,YMin,YSec,YSInt,YPnts
 YDte=String(YDay,YMonth,YYear,$
  Format="(I2.2,'/',I2.2,'/',I4.2)")
end
YDat=DblArr(YPnts)
ReadF,u,YDat
Free_Lun,u
;
Print,'Reading from Parameter File...'
OpenR,u,'C:\TEMP\WDCSANL.PAR',/Get_Lun
ReadF,u,FFTN,MxF,PntRes,SpW,PltTyp,WndT,Smo,MnPh,MxPh,$
 PShft,CPwRej,CPhRej,CPhCorr,EnhPh,MnPw,MxPw
Free_Lun,u
;
NPnts=XPnts
If YPnts LT XPnts Then NPnts=YPnts
If FFTN GT NPnts Then FFTN=NPnts
If (ABS(XSInt-YSInt) LT 0.01) Then $
Begin
 SInt=XSInt
 NyqF=Fix(1000.0/(2.0*SInt))
 DelF=1000.0/(FFTN*SInt)
 If PntRes LT 5 Then PntRes=5
 NBlocs=Fix((NPnts-FFTN)/PntRes)
 EqStrt=1 & PolStrt=1
 PntPlotChoice
;Print,'Finished PntPlotChoice: EqStrt,PolStrt,PltTyp ',Eqstrt,polstrt,plttyp
 NPnts=NPnts-EqStrt+1
 If (PolStrt GT EqStrt) Then NPnts=NPnts-PolStrt+1
 ParChoice
;Print,'Finished ParChoice: '
;Print,'FFTN,MxF,PntRes,SpW,WndT,Smo ',FFTN,MxF,PntRes,SpW,WndT,Smo
 WndT=Fix(WndT)
 FFTN=Fix(FFTN)
 PntRes=Fix(PntRes)
 NFr=Fix(MxF/DelF)+1
 MxF=(NFr-1)*DelF
 T=LonArr(NBlocs)
 T(0)=Long(XHour)*3600+Long(XMin)*60+Long(XSec)
 T(0)=T(0)+EqStrt-1
 Print,'Start Time = ',Tim(T(0))
 For i=1,NBlocs-1 do $
  T(i)=T(i-1)+Long(PntRes*SInt)
 MnT=Min(T)
 MxT=Max(T)
 DispArr=DblArr(NBlocs,NFr)
 XTsArr=DblArr(FFTN)    ; Time Series Array
 YTsArr=DblArr(FFTN)
 CPow=DblArr(NBlocs,NFr)
 If PltTyp EQ 1 Then TmpCphArr=DblArr(NBlocs,NFr) ; Cross Phase
 For i=0,FFTN-1 do $
 Begin
  XTsArr(i)=XDat(i+EqStrt-1)   ; Load First FFTN of Data
  YTsArr(i)=YDat(i+PolStrt-1)
 End
 Wght=DblArr(NFr)
 For i=0,NFr-1 do Wght(i)=Float(i)^SpW
 Sum1=0.0
 If (WndT EQ 1) Then $
 Begin
  Wnd=DblArr(5*(Smo+1))
  For i=0,4*(Smo+1) do $
  Begin
   Wnd(i)=Exp(-(Float(i-2*(Smo+1))/Float(Smo+1))^2)
   Sum1=Sum1+Wnd(i)
  End
  For i=0,4*(Smo+1) do Wnd(i)=Wnd(i)/Sum1
  iLFr=2*(Smo+1)
  LFr=iLFr*DelF
 end
 If (WndT EQ 0) Then Wnd=Hanning(FFTN)
 PTyp=2
;
; Major Loop Starts Here
;
 Print,'CALCULATING SPECTRUM.... PLEASE WAIT'
 For Bloc=0,NBlocs-1 do $
 Begin
  DTrend,XTsArr,FFTN
  DTrend,YTsArr,FFTN
  If (WndT EQ 0) Then $
  Begin
   For i=0,FFTN-1 do XTsArr(i)=Wnd(i)*XTsArr(i)
   For i=0,FFTN-1 do YTsArr(i)=Wnd(i)*YTsArr(i)
  end
  XTrArr=FFT(XTsArr,1)    ; FFT - BACKWARD so NO 1/N
  YTrArr=FFT(YTsArr,1)
  If (PltTyp EQ 0) Then $  ; Power
  Begin
   CP=YTrArr*Conj(XTrArr)  ; Define CPower Array
   If (WndT EQ 0) Then $  ; Time Domain
   Begin
    If (PTyp EQ 1) Then $ ; Lin. Pow.
     For i=0,NFr-1 do DispArr(Bloc,i)=ABS(CP(i))*Wght(i)/FFTN
    If (PTyp EQ 2) Then $ ; Log10
    Begin
     For i=0,NFr-1 do $
     Begin
      CPw=ABS(CP(i))*Wght(i)/FFTN
      If (CPw GE 1e20) Then CPw=1e20
      If (CPw LT 1e-6) Then CPw=1e-6
      DispArr(Bloc,i)=20*ALog10(CPw)
     end   ; i Loop
    end    ; If Log
   end     ; If Time Wind.
   If (WndT EQ 1) Then $  ; Freq.
   Begin
    For i=0,iLFr-1 do $
    Begin
     DispArr(Bloc,i)=ABS(CP(i))*Wght(i)/FFTN
     If (PTyp EQ 2) Then $
     Begin
      If (DispArr(Bloc,i) LT 1e-6) Then DispArr(Bloc,i)=1e-6
      DispArr(Bloc,i)=20*ALog10(DispArr(Bloc,i))
     end
    end
    For i=iLFr,NFr-1-2*(Smo+1) do $
    Begin
     DispArr(Bloc,i)=0.0
     Js=i-2*(Smo+1)
     Je=i+2*(Smo+1)
     iWn=-1
     For j=Js,Je do $
     Begin
      iWn=iWn+1
      DispArr(Bloc,i)=DispArr(Bloc,i)+Wnd(iWn)*ABS(CP(j))/FFTN
     end    ; end of J loop
     DispArr(Bloc,i)=DispArr(Bloc,i)*Wght(i)
     If (PTyp EQ 2) Then $
     Begin
      If (DispArr(Bloc,i) LT 1e-6) Then DispArr(Bloc,i)=1e-6
      DispArr(Bloc,i)=20*ALog10(DispArr(Bloc,i))
     end    ; If PTyp = 2
    end     ; Freq loop
   end      ; If Freq. Filt.
  end       ; If CPow to be plotted
  If (PltTyp EQ 1) Then $  ; Phase
  Begin
   CP1=YTrArr*Conj(XTrArr); Cross Power
   If (WndT EQ 0) Then $  ; Time Wind.
   Begin
    For kk=0,NFr-1 do $
    Begin
     CPow(Bloc,kk)=20.0*ALog10(ABS(CP1(kk))/FFTN)                         ; CP Array
     Tp=Imaginary(CP1(kk))
     Bt=Double(CP1(kk))
     TmpCPhArr(Bloc,kk)=ATAN(Tp,Bt)*RaDeg    ; XPhase Array
    end
   end
   If (WndT EQ 1) Then $  ; Freq. Wnd.
   Begin
    For i=0,iLFr-1 do TmpCPhArr(Bloc,i)=-200.0
    For i=iLFr,NFr-1 do $
    Begin
     CPw=Complex(0.0,0.0)
     Js=i-2*(Smo+1)
     Je=i+2*(Smo+1)
     iWn=-1
     For j=Js,Je do $
     Begin
      iWn=iWn+1
      CPw=CPw+Wnd(iWn)*CP1(j)
     end
     CPow(Bloc,i)=20.0*ALog10(ABS(CPw)/FFTN)  ; Smoothed Cross Power
     Tp=Imaginary(CPw)
     Bt=Double(CPw)
     TmpCPhArr(Bloc,i)=ATAN(Tp,Bt)*RaDeg     ; Smoothed C. Ph.
    end     ; End Freq Loop
   end      ; If Freq Smoothing
  end       ; If Phase Plot
  PosnE=Long(EqStrt)-Long(1)+Long(Bloc+1)*Long(PntRes)
  PosnP=Long(PolStrt)-Long(1)+Long(Bloc+1)*Long(PntRes)
  For j=Long(0),Long(FFTN-1) do $
  Begin
   XTsArr(j)=XDat(PosnE+j)    ; New Data
   YTsArr(j)=YDat(PosnP+j)
  End
 End          ; End of Bloc Loop
 Wait,0.5
 Print,'Finished Main Loop'
 Set_plot,'WIN'
 Device,decomposed=0
 YRngL=0.0
 Scl=1
 If (PltTyp EQ 0) Then $  ; Cross Power
 Begin
  MnPow=Min(DispArr)
  MxPow=Max(DispArr)
  LoadCT,13
  CPwChoice
 end
 If (PltTyp EQ 1) Then $  ; Cross Phase
 Begin
  MnPow=min(CPow)
  MxPow=Max(CPow)
  CPhChoice
 end
 Print,'Finished'
end
End
