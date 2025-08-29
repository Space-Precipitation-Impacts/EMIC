; Widget controlled dynamic power
; spectrum analysis program
;
; FFT Routine: Colin Waters
; Written : Dec-Jan, 1997-8
; Modifications :By Paul Manusiu 2000
;
;FUNCTION XTLab,axis,index,value
; Ti=value
; Hour=Long(Ti)/3600
; Minute=Long(Ti-3600*Hour)/60
;RETURN,String(Hour,Minute,$
;       Format="(I2.2,':',I2.2)")
;end
;
PRO DPChoice3_multi_event, ev
;Common BLK5,Ttle,XTtle,YTtle,YRngL,MxFr,MnT,MxT,Scl,DispArr
common cm_crres,state,cm_eph,cm_val
Common BLK4,MnPow,MxPow
Common BLK2,SpW,SpTyp,Smo
Common BLK3,FrRes,TRes,FBlks
;common BLK50,TmRes
Common BLK1,NPnts,SInt,FFTN,DelF,NyqF,MxF,PntRes,NBlocs,NFr
common BLK51,Dat5a
common ptext,plottext
plottext=' '
Widget_Control,ev.id,Get_UValue=UVal;,/hourglass
Case UVal of
 'FSL' : Begin
          Widget_Control,ev.id,Get_Value=FFTN
          DelF=1.0/(FFTN*SInt)
          Widget_Control,FrRes,Set_Value='Delta F : '+$
           StrTrim(String(DelF),2)+' Hz'
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


'MNP1' :begin
		Widget_Control,ev.id,Get_Value=MnPow0
			MnPow[0]=MnPow0
			end
 'MXP1' :begin
 			Widget_Control,ev.id,Get_Value=MxPow0
			MxPow[0]=MxPow0
			end
'MNP2' :begin
			Widget_Control,ev.id,Get_Value=MnPow1
			MnPow[1]=MnPow1
			end
 'MXP2' :begin
 			Widget_Control,ev.id,Get_Value=MxPow1
			MxPow[1]=MxPow1
			end
 'MNP3' :begin
 			Widget_Control,ev.id,Get_Value=MnPow2
			MnPow[2]=MnPow2
			end
 'MXP3' :begin
 			Widget_Control,ev.id,Get_Value=MxPow2
			MxPow[2]=MxPow2
			end
 'SMC' : Widget_Control,ev.id,Get_Value=Smo
 'DNE' :begin
		Widget_Control,ev.id,Set_Value='Plotting...Please Wait...',/hourglass
		plottext=' '

		if Dat5a EQ 'CROSSPOWER' then $
		dpcrosspower_again else $
		IF Dat5a EQ 'ALL DB FIELDS' OR Dat5a EQ 'ALL E FIELDS' THEN $
		DPOWN_AGAIN_MULTI ELSE $
		DPOWN_AGAIN

        Widget_Control,ev.id,Set_Value='Plot Again'
	    plottext='Plot Again'

 		end
 end
END




PRO DPChoice3_multi,Dat5
common cm_crres,state,cm_eph,cm_val
Common BLK1,NPnts,SInt,FFTN,DelF,NyqF,MxF,PntRes,NBlocs,NFr
;stop
Common BLK2,SpW,SpTyp,Smo
Common BLK3,FrRes,TRes,FBlks
Common BLK4,MnPow,MxPow
Common BLK51, Dat5a
;common BLK50,TmRes
Dat5a=Dat5
;stop
base5=widget_base(/column,title='Spectral Widget',/ALIGN_TOP)
;FFTN=600
;stop
 ;FFTSL  = Widget_Slider(base5);,value=FFTN,UValue='FSL',$
          ;Minimum=10,Maximum=1200,Title='FFT Length [Points]')
 FFTSL  = Widget_Slider(base5,value=FFTN,UValue='FSL',$
          Minimum=10,Maximum=5000,Title='FFT Length [Points]')
;stop
 ;DelF=1000.0/(FFTN*SInt)
 FrRes  = Widget_Text(base5,value='Delta F : '+ $
           StrTrim(String(DelF),2)+' Hz',UValue='FRR')
;stop
 MFSL   = Widget_Slider(base5,value=MxF,UValue='MFS',Maximum=NyqF,$
           Title='Max. Freq. [Hz] Nyquist = '+StrTrim(String(NyqF),2)+' Hz')
;stop
 PRes   = Widget_Slider(base5,value=PntRes,UValue='PRS',Maximum=FFTN,$
          Minimum=1,Title='FFT Step [Points]')
          TmRes=PntRes*SInt
;stop
 TRes   = Widget_Text(base5,value='Time Res. '+StrTrim(String(TmRes),2)+' Sec.',UValue='TRS')
;stop
 FBlks  = Widget_Text(base5,value='No of FFTs '+StrTrim(String(NBlocs),2),UValue='FBL')
;stop
 SpWgt  = CW_FSlider(base5,value=SpW,UValue='SPW',format='(F3.1)',$
          Maximum=5.0,Title='Spectral Weighting',/drag,/Frame)
;stop
 FTArr=StrArr(2) & FTArr[0]='Time' & FTArr[1]='Frequency'
 FrTm   = CW_BGroup(base5,FTArr,UValue='TFR',$
           Label_top='Smoothing Domain',Set_Value=1,/row,/Exclusive)
;stop
 SmArr=StrArr(5)
 For i=0,4 do SmArr(i)=StrTrim(String(i+1),2)
 SmVal  = CW_BGroup(base5,SmArr,UValue='SMC',$
           Label_top='Amount of Smoothing',Set_Value=1,/row,/Exclusive)

;****************************************************************************
if MxPow[0] GE MxPow[1] and MxPow[0] GE MxPow[2] then $
maxpow=MxPow[0] $
else $
if MxPow[1] GE MxPow[0] and MxPow[1] GE MxPow[2] then $
maxpow=MxPow[1] $
else $
maxpow=MxPow[2]
;****************************************************************************

MnPBut1= Widget_Slider(base5,value=MnPow[0],UValue='MNP1',$
          Minimum=MnPow[0]-10,Maximum=MaxPow+1,Title='Min. Power')
;stop
 MxPBut1= Widget_Slider(base5,value=MxPow[0],UValue='MXP1',$
          Minimum=MnPow[0]-10,Maximum=MaxPow+1,Title='Max. Power')

MnPBut2= Widget_Slider(base5,value=MnPow[1],UValue='MNP2',$
          Minimum=MnPow[1]-10,Maximum=MaxPow+1,Title='Min. Power')
;s
 MxPBut2= Widget_Slider(base5,value=MxPow[1],UValue='MXP2',$
          Minimum=MnPow[1]-10,Maximum=MaxPow+1,Title='Max. Power')

MnPBut3= Widget_Slider(base5,value=MnPow[2],UValue='MNP3',$
          Minimum=MnPow[2]-10,Maximum=MaxPow+1,Title='Min. Power')
 MxPBut3= Widget_Slider(base5,value=MxPow[2],UValue='MXP3',$
          Minimum=MnPow[2]-10,Maximum=MaxPow+1,Title='Max. Power')
;****************************************************************************

 ;MnPBut1= Widget_Slider(base5,value=MnPow[0],UValue='MNP1',$
 ;         Minimum=MnPow[0]-10,Maximum=MxPow[0]+10,Title='Min. Power')
;stop
 ;MxPBut1= Widget_Slider(base5,value=MxPow[0],UValue='MXP1',$
 ;         Minimum=MnPow[0]-10,Maximum=MxPow[0]+10,Title='Max. Power')

;MnPBut2= Widget_Slider(base5,value=MnPow[1],UValue='MNP2',$
 ;         Minimum=MnPow[1]-10,Maximum=MxPow[1]+10,Title='Min. Power')
;s
 ;MxPBut2= Widget_Slider(base5,value=MxPow[1],UValue='MXP2',$
 ;         Minimum=MnPow[1]-10,Maximum=MxPow[1]+10,Title='Max. Power')

;MnPBut3= Widget_Slider(base5,value=MnPow[2],UValue='MNP3',$
 ;         Minimum=MnPow[2]-10,Maximum=MxPow[2]+10,Title='Min. Power')
 ;MxPBut3= Widget_Slider(base5,value=MxPow[2],UValue='MXP3',$
 ;         Minimum=MnPow[2]-10,Maximum=MxPow[2]+10,Title='Max. Power')
DneBut = Widget_Button(base5,value='Plot',UValue='DNE')
 cpchoice_struct = {MxPBut1:MxPBut1,$
 					MxPBut2:MxPBut2,$
 					MxPBut3:MxPBut3,$
                    MnPBut1:MnPBut1,$
                    MnPBut2:MnPBut2,$
                    MnPBut3:MnPBut3,$
                    DneBut:DneBut,$
                    SmVal:SmVal,$
                     FrTm: FrTm,$
                    SpWgt:SpWgt }
 WIDGET_CONTROL, base5, /REALIZE,update=1
widget_control,cpchoice_struct.(0),sensitive=1
 widget_control,cpchoice_struct.(1),sensitive=1
 widget_control,cpchoice_struct.(2),sensitive=1
;print,Spw
;print,SpTyp
;print,PnTres
 XMANAGER, 'DPChoice3_multi',base5
END