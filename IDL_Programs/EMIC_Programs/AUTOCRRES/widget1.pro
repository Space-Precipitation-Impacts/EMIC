; This program is used as an example in the "Widgets"
; chapter of the _Using IDL_ manual.
;
;WIDGET_CONTROL, ev.top, GET_UVALUE=drawID
Function Tim,mSec						;Function to determine hours,minutes,seconds from time tag
 milsec=mSec Mod 1000
 seci=fix(Long(mSec)/1000)
 secf = seci mod 60
 mni=fix(Long(seci)/60)
 mnf = mni mod 60
 hr = fix(Long(mni)/60)
 Return,String(hr,mnf,secf,milsec,$
  Format="(I2.2,':',I2.2,':',i2.2,'.',i3.3)")
end

Function XTLab,Axis,Index,Value			;Function to format x axis into hours:minutes:seconds.frac
 mSec=long(Value)
 milsec=long(mSec) Mod 1000
 seci=Long(mSec/1000)
 secf = long(seci) mod 60
 mni=Long(seci)/60
 mnf = long(mni) mod 60
 hr = Long(mni/60)
 Return,String(hr,mnf,secf,milsec,$
  Format="(I2.2,':',I2.2,':',i2.2,'.',i3.3)")
end


PRO widget1_event, ev
WIDGET_CONTROL, ev.top, get_uvalue=state
if(ev.id eq state.file_bttn2) then $
  begin
        FName=DIALOG_PICKFILE(title='Select File', FILTER = '*.val')
        timme=lonarr(100)
        ;Ex=fltarr(200)
        Ey=fltarr(200)
		Ez=fltarr(200)
        yy=indgen(100)
        tt=' '
        Openr,unit,FName,/get_lun
        readf,unit,tt
        for i=0, 199 do $
          begin
            readf,unit,tt
            state.timm[i]=Long(strmid(tt,0,8))
            state.Ex[i] = float(strmid(tt,10,8))
            Ey[i] = float(strmid(tt,20,8))
            Ez[i] = float(strmid(tt,30,8))
        endfor
        WIDGET_CONTROL,state.text,set_value='Data for file: '+string(FName),/HOURGLASS
        free_lun,unit
        !P.multi=[0,1,3]
        plot,state.timm,state.Ex,xtitle='UT',ytitle='Amplitude',xtickformat='Xtlab',xticks=4,$
        title='Ex(mV/m)'
        plot,state.timm,Ey,xtitle='UT',ytitle='Amplitude',xtickformat='Xtlab',xticks=4,$
        title='Ey(mV/m)'
        plot,state.timm,Ez,xtitle='UT',ytitle='Amplitude',xtickformat='Xtlab',xticks=4,$
        title='Ez(mV/m)'
        WIDGET_CONTROL, state.Plot_bttn1, sensitive=1
        ;WIDGET_CONTROL, state.timm,set_uvalue=state.timm
          !P.multi=0
 endif
   WIDGET_CONTROL, ev.top, get_uvalue=state
if(ev.id eq state.file_bttn1) then $
  begin
  WIDGET_CONTROL,state.text,set_value=' '
 ; WIDGET_CONTROL,state.draw1,set_value=1
  WIDGET_CONTROL, state.Plot_bttn1, sensitive=0
endif
  WIDGET_CONTROL, ev.top, get_uvalue=state

if(ev.id eq state.Plot_bttn1) then $
  begin
  ;yy=indgen(100)
  ;WIDGET_CONTROL,state.Ex,get_value=state.Ex
  ;WIDGET_CONTROL,state.Plot_bttn1,set_value=string(state.timm)
  plot,state.timm,state.Ex,xtitle='UT',ytitle='Amplitude',xtickformat='Xtlab',xticks=2
endif

  WIDGET_CONTROL, ev.top, get_uvalue=state;,/NO_COPY
;ENDcase
end


PRO widget1
base = WIDGET_BASE(title='SPG UNiNew CRRES Poynting Flux', /row,mbar=bar)
;**************************************************

file_menu = WIDGET_BUTTON(bar, VALUE='File', /MENU)
edit_menu = WIDGET_BUTTON(bar, VALUE='Edit', /MENU)
Plot_menu=  WIDGET_BUTTON(bar, VALUE='Plot',uval='plt', /MENU)
help_menu = WIDGET_BUTTON(bar, VALUE='Help', /MENU)

;**************************************************

file_bttn1=WIDGET_BUTTON(file_menu, VALUE='New',$
                        UVAL='file1')
file_bttn2=WIDGET_BUTTON(file_menu, VALUE='Open',$
                        UVAL='file2')
Plot_bttn1=WIDGET_BUTTON(Plot_menu, VALUE='Ex',$
                        UVAL='Plot1')
Plot_bttn2=WIDGET_BUTTON(Plot_menu, VALUE='Ey',$
                        UVAL='Plot2')
Plot_bttn3=WIDGET_BUTTON(Plot_menu, VALUE='Ez',$
                        UVAL='Plot3')
Plot_bttn4=WIDGET_BUTTON(Plot_menu, VALUE='Bx',$
                        UVAL='Plot4')
Plot_bttn5=WIDGET_BUTTON(Plot_menu, VALUE='By',$
                        UVAL='Plot5')
Plot_bttn6=WIDGET_BUTTON(Plot_menu, VALUE='Bz',$
                        uVAL='Plot6')

;**************************************************
text = WIDGET_TEXT(base, value='Start', XSIZE=30,ysize=20,uval='tex',/editable,/scroll,/wrap)
draw1 = WIDGET_DRAW(base,uval='drawID',xsize=400,ysize=400)
;**************************************************
state={file_bttn1:file_bttn1,$
       file_bttn2:file_bttn2,$
       draw1:draw1,$
        text:text,$
        Plot_bttn1:Plot_bttn1,$
        Plot_bttn2:Plot_bttn2,$
        Plot_bttn3:Plot_bttn3,$
        Plot_bttn4:Plot_bttn4,$
        Plot_bttn5:Plot_bttn5,$
        Plot_bttn6:Plot_bttn6,$
        timm:lonarr(200),Ex:fltarr(200)}
WIDGET_CONTROL, state.Plot_bttn1, sensitive=0
WIDGET_CONTROL, state.Plot_bttn2, sensitive=0
WIDGET_CONTROL, state.Plot_bttn3, sensitive=0
WIDGET_CONTROL, state.Plot_bttn4, sensitive=0
WIDGET_CONTROL, state.Plot_bttn5, sensitive=0
WIDGET_CONTROL, state.Plot_bttn6, sensitive=0
WIDGET_CONTROL, base, /REALIZE
WIDGET_CONTROL, base,set_uvalue=state

XMANAGER, 'Widget1', base,/no_block

END
