; Widget code to Adjust Amplitude for WTMSER
;
; C.L. Waters
; SPWG, University of Newcastle
; NSW, Australia
; Feb, 1999
;
Pro ampadj_event,ev
 common widg6,IDABut,AmpBut,IDSw,Amp
 Widget_Control,ev.id,Get_UValue=uval
 Case uval of
 'IDB': Begin
          DmSw=IDSw
          If DmSw EQ 'I' Then $
          Begin
           IDSw='D'
           Widget_Control,ev.id,Set_Value='DECREASE AMP.'
          end
          If DmSw EQ 'D' Then $
          Begin
           IDSw='I'
           Widget_Control,ev.id,Set_Value='INCREASE AMP.'
          end
         end
 'NUM' : Begin
          If IDSw eq 'I' Then amp=amp+1.
          If IDSw eq 'D' Then amp=amp-1.
          If amp lt 0. then amp=0.
          Widget_Control,ev.id,Set_Value=Strtrim(String(amp),2)
         end
 'EX': Begin
          WIDGET_CONTROL,ev.top,/DESTROY
         end
 endcase
END
;
PRO ampadj,base,xp,yp,ampl
 common widg6,IDABut,AmpBut,IDSw,Amp
 base6=WIDGET_BASE(Event_Func='adjamp_event',TITLE='Adjust Amplitude',Group_Leader=Base,$
   XOFFSET=xp,YOFFSET=yp,XSize=150,/COLUMN,/Modal)
 IDABut=WIDGET_BUTTON(base6,VALUE='INCREASE AMP.',UVALUE='IDB')
 IDSw='I' & Amp=ampl
 AmpBut=Widget_Button(base6,Value=Strtrim(string(amp),2),UValue='NUM')
 EXBut=WIDGET_BUTTON(base6,VALUE='Finish',UVALUE='EX')
 WIDGET_CONTROL,base6,/REALIZE
 XMANAGER,'ampadj',base6
 ampl=amp
END
