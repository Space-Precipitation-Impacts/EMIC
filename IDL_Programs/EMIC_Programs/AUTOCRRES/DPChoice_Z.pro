; Widget controlled dynamic power
; spectrum analysis program
;
; Colin Waters
; SPWG, Uni of Newcastle
; Department of Physics
; Written : Dec-Jan, 1997-8
;
; Modifications :By Paul Manusiu
;
FUNCTION XTLab,axis,index,value
 Ti=value
 Hour=Long(Ti)/3600
 Minute=Long(Ti-3600*Hour)/60
RETURN,String(Hour,Minute,$
       Format="(I2.2,':',I2.2)")
end
;
PRO DPChoice_Z_event, ev
;widget_control,ev.top,get_uvalue=dpchoice_struct
;common Minn,MnT,MxT
common Arrs,DispX,DispY,DispZ,TT
common uvalues, ff,f2,f3,f4,f5,f6,dat5,ser5,fil_info
;Common BLK5,Ttle,XTtle,YTtle,YRngL,MxFr,MnT,MxT,Scl,DispArr
common BLK30, cpchoice_struct
Common cm_crres,state
Common bas,base5
Common BLK4,MnPow,MxPow
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
'MNP' : Begin
          Widget_Control,ev.id,Get_Value=MnPow
          ;widget_control,cpchoice_struct.(1),set_value=
          If MnPow GT MxPow Then $
          Begin
           Msg=Dialog_Message('Min. Power too Large')
           Widget_Control,ev.id,Set_Value=MxPow-10.
          endif
          ;Print,'MnPow',MnPow
          ;Widget_Control,ev.id,Set_Value=
         end
 'MXP' : Begin
          Widget_Control,ev.id,Get_Value=MxPow

          If MxPow LT MnPow Then $
          Begin
           Msg=Dialog_Message('Max. Power too Small')
           Widget_Control,ev.id,Set_Value=MnPow+10.
          end
          ;Print,'MxPow',MxPow
         end

 'SMC' : Widget_Control,ev.id,Get_Value=Smo
 'DNE' :begin
		 Widget_Control,ev.id,Set_Value='Plotting...Please Wait...'
         DOO_PLOT,DispX,DispY,DispZ,TT
		 Widget_Control,ev.id,Set_Value='Plot Again'
         ;, MnPow,MxPw
         ;Widget_Control,ev.id,Set_Value='Plot'
         ;widget_control,cpchoice_struct.(0),sensitive=1
         ;widget_control,cpchoice_struct.(1),sensitive=1

          ;Widget_Control,ev.id,/DESTROY
 end
 end
END

;
;PRO OutF_Event,ev
;Common BLK1,NPnts,SInt,FFTN,DelF,NyqF,MxF,PntRes,NBlocs,NFr
;Common BLK4,MnPow,MxPow
;Common BLK5,Ttle,XTtle,YTtle,YRngL,MxFr,MnT,MxT,Scl,DispArr
;COMMON BLK6,WrF,OutName
; Widget_Control,WrF,Get_Value=OutName
; OpenW,u,OutName(0),/Get_Lun
; PrintF,u,NBlocs,NFr
; PrintF,u,Ttle
; PrintF,u,XTtle
; PrintF,u,YTtle
; PrintF,u,MnT,MxT
; PrintF,u,YRngL,MxFr/1000.0
; PrintF,u,Scl
; PrintF,u,MnPow,MxPow
; PrintF,u,DispArr
; Free_Lun,u
; Widget_Control,ev.top,/DESTROY
;end
;
;PRO OutF
;COMMON BLK6,WrF,OutName
; base2=Widget_Base(Group_Leader=base3)
; WrF=Widget_Text(base2,value='********.PIC',UValue='WFL',$
;  XOFFSET=10,YOFFSET=50,/EDITABLE)
; Widget_Control, base2,/REALIZE
; XMANAGER,'OutF',base2
;end


PRO DPChoice_Z,NPntss
Common cm_crres,state,cm_eph,cm_val
common Arrs,DispX,DispY,DispZ,TT
Common BLK1,NPnts,SInt,FFTN,DelF,NyqF,MxF,PntRes,NBlocs,NFr
Common BLK2,SpW,SpTyp,Smo
Common BLK3,FrRes,TRes,FBlks
Common BLK4,MnPow,MxPow
common BLK30, cpchoice_struct
Common bas,base5
state=state
;print,widget_info(base5,/realize)
;text33=widget_text(state.base4,value='hello',xsize=60,ysize=30,/SCROLL)
;stop
; base5= Widget_Base(sstate.base,/COLUMN,XSize=250,/frame)
; stop
NPnts=NPntss

Print,'Reading from Parameter File...'
OpenR,u,'WDPOW.PAR',/Get_Lun
ReadF,u,FFTN,MxF,PntRes,SpW,SpTyp,Smo
Free_Lun,u
Print,'FFTN,MxF,PntRes,SpW,SpTyp,Smo',FFTN,MxF,PntRes,SpW,SpTyp,Smo
;Print,'NPnts,SInt,FFTN,DelF,NyqF,MxF,PntRes,NBlocs,NFr',$
;NPnts,SInt,FFTN,DelF,NyqF,MxF,PntRes,NBlocs,NFr
SSInt=ABS(cm_val.(0)[1] - cm_val.(0)[0])
SSSInt=SSINt/1000.0
SInt=SSSINt
;stop
NyqF=Fix(1000.0/(2.0*SInt))
If FFTN GT NPnts Then FFTN=NPnts
DelF=1000.0/(FFTN*SInt)
If PntRes LT 5 Then PntRes=5
NBlocs=Fix((NPnts-FFTN)/PntRes)
MxPow=0
MnPow=-150
base5=widget_base(/column,/ALIGN_TOP)
;FFTN=600

 ;FFTSL  = Widget_Slider(base5);,value=FFTN,UValue='FSL',$
          ;Minimum=10,Maximum=1200,Title='FFT Length [Points]')
 FFTSL  = Widget_Slider(base5,value=FFTN,UValue='FSL',$
          Minimum=10,Maximum=1200,Title='FFT Length [Points]')

 DelF=1000.0/(FFTN*SInt)
 FrRes  = Widget_Text(base5,value='Delta F : '+ $
           StrTrim(String(DelF),2)+' mHz',UValue='FRR')
 MFSL   = Widget_Slider(base5,value=MxF,UValue='MFS',Maximum=NyqF,$
           Title='Max. Freq. [mHz] Nyquist = '+StrTrim(String(NyqF),2)+' mHz')
 PRes   = Widget_Slider(base5,value=PntRes,UValue='PRS',Maximum=FFTN,$
          Minimum=1,Title='FFT Step [Points]')
          TmRes=PntRes*SInt
 TRes   = Widget_Text(base5,value='Time Res. '+StrTrim(String(TmRes),2)+' Sec.',UValue='TRS')
 FBlks  = Widget_Text(base5,value='No of FFTs '+StrTrim(String(NBlocs),2),UValue='FBL')
 SpWgt  = CW_FSlider(base5,value=SpW,UValue='SPW',format='(F3.1)',$
          Maximum=5.0,Title='Spectral Weighting',/drag,/Frame)
 FTArr=StrArr(2) & FTArr[0]='Time' & FTArr[1]='Frequency'
 FrTm   = CW_BGroup(base5,FTArr,UValue='TFR',$
           Label_top='Smoothing Domain',Set_Value=1,/row,/Exclusive)

 SmArr=StrArr(5)
 For i=0,4 do SmArr(i)=StrTrim(String(i+1),2)
 SmVal  = CW_BGroup(base5,SmArr,UValue='SMC',$
           Label_top='Amount of Smoothing',Set_Value=1,/row,/Exclusive)
;Mxpww=float(max(DispX))
;Mpww=float(min(DispX))
;,DispY,DispZ,TT

 MnPBut= Widget_Slider(base5,value=MnPow,UValue='MNP',$
          Minimum=-150,Maximum=MxPow,Title='Min. Power')
 MxPBut= Widget_Slider(base5,value=MxPow,UValue='MXP',$
          Minimum=-150,Maximum=MxPow,Title='Max. Power')
 DneBut = Widget_Button(base5,value='Plot',UValue='DNE')
 ;PAgBut= Widget_Button(base5,value='Plot Again',UValue='PAG')
 cpchoice_struct = {MxPBut:MxPBut,$
                    MnPBut:MnPBut,$
                    DneBut:DneBut,$
                    SmVal:SmVal,$
                     FrTm: FrTm,$
                    SpWgt:SpWgt }
 WIDGET_CONTROL, base5, /REALIZE,update=1
widget_control,cpchoice_struct.(0),sensitive=1
 widget_control,cpchoice_struct.(1),sensitive=1
 widget_control,cpchoice_struct.(2),sensitive=1
 XMANAGER, 'DPChoice',base5
END