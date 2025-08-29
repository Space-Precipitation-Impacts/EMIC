Function XTLab,Axis,Index,Value			;Function to format x axis into hours:minutes:seconds.frac
 mSec=long(Value)
 milsec=long(mSec) Mod 1000
 seci=Long(mSec/1000)
 secf = long(seci) mod 60
 mni=Long(seci)/60
 mnf = long(mni) mod 60
 hr = Long(mni/60)
 Return,String(hr,mnf,secf,$
  Format="(I2.2,':',I2.2,':',i2.2)")
end

PRO testwidg2_event, ev
common cm_crres,state,cm_eph,cm_val
WIDGET_CONTROL, ev.top, get_uvalue=state,/HOURGLASS

 if ev.id EQ state.fil_menu then $
  begin
    if ev.value EQ 'New' then $
     begin
      WIDGET_CONTROL, state.eph_menu, sensitive=0
	  WIDGET_CONTROL, state.Dat_menu, sensitive=0
	  ;WIDGET_CONTROL, state.draw, /destroy
	  WIDGET_CONTROL, state.text,set_value=string('')
	  WIDGET_CONTROL, state.dat_info,SET_VALUE =string(' ')
	  WIDGET_CONTROL, state.ORB_info,SET_VALUE =string(' ')
	  ;WIDGET_CONTROL, state.field,SET_VALUE =string(' ')
	endif
    if ev.value EQ 'Open'then $
     begin
      FName=DIALOG_PICKFILE(title='Select File', FILTER = '*.*',/READ,/NOCONFIRM)
      if strlowcase(strmid(Fname,39,3)) EQ '0ep' then $
       begin
        orb=strmid(Fname,33,3)
        eph_crfiles,orb,orb_binfile,orb_date
        fileph,FName,ephv
        cm_eph=ephv
        print,cm_eph.(0)
        print,tag_names(cm_eph)
        WIDGET_CONTROL, state.eph_menu, sensitive=1
        WIDGET_CONTROL, state.orb_info,SET_VALUE = 'Orbit'+string(orb)+'  '+string(orb_date)
        WIDGET_CONTROL, state.dat_info,SET_VALUE =string(' ')
      endif else $
      if strmid(Fname,42,3) EQ 'val' then $
        begin
		orb=strmid(Fname,33,3)
         eph_crfiles,orb,orb_binfile,orb_date
		 fileph,string(orb_binfile)+'.0ep',ephv
        WIDGET_CONTROL, state.orb_info,SET_VALUE = 'Orbit'+string(orb)+'  '+string(orb_date)
		WIDGET_CONTROL, state.dat_info,SET_VALUE =string(' ')
         fileval,Fname,valv
         cm_eph=ephv
         cm_val=valv
        WIDGET_CONTROL, state.Dat_menu, sensitive=1
        WIDGET_CONTROL, state.eph_menu, sensitive=1
      endif else Result = DIALOG_MESSAGE('File must be *.val or *.0ep')
    endif
    if ev.value EQ 'Save' then Result = DIALOG_MESSAGE('Not yet Implemented')
    if ev.value EQ 'Save As' then Result = DIALOG_MESSAGE('Not yet Implemented')
    if ev.value EQ 'Close' then Result = DIALOG_MESSAGE('Not yet Implemented')
    if ev.value EQ 'Exit' then widget_control,ev.top,/destroy
 endif
end

PRO eph_menu_event, ev
common cm_crres,state,cm_eph,cm_val
WIDGET_CONTROL, ev.top, get_uvalue=state,/HOURGLASS
WIDGET_CONTROL, ev.id,get_uvalue=ff
nname = tag_names(cm_eph)
nname = STRLOWCASE(nname)
ff = STRLOWCASE(ff)
print,ff
for ii=0, n_tags(cm_eph) -1 do $
 if ff EQ nname[ii] then $
 begin
 widget_control,state.text,set_value=string(cm_eph.(ii))
 WIDGET_CONTROL, state.dat_info, SET_VALUE = string(strupcase(nname[ii]))
  IF (ff NE 'ut') and (ff NE 'julian') AND (ff NE 'lshell') then $
    PLOT,cm_eph.(34),cm_eph.(ii),xtitle=string(STRUPCASE(nname(34))),$
    ytitle=string(strupcase(nname[ii])),xticks=3

    ;$XRANGE=[CM_EPH.(8)[0]/CM_EPH.(34)[0],MAX(CM_EPH.(8))]
    ;PLOT,cm_eph.(0),cm_eph.(ii),xtitle='UT',ytitle=string(strupcase(nname[ii])),$
    ;xtickformat='Xtlab',xticks=3
    print,ii
    PRINT,CM_EPH.(8)[0]/CM_EPH.(34)[0]
endif
end

PRO Dat_menu_event, ev
common cm_crres,state,cm_eph,cm_val
WIDGET_CONTROL, ev.top, get_uvalue=state,/HOURGLASS
WIDGET_CONTROL, ev.id,get_uvalue=Dat5
nname = tag_names(cm_val)
!P.Multi=0
for ii=1,3 do $
  if dat5 EQ nname(ii) then $
	begin

        plot,cm_val.(0),cm_val.(ii),xtitle='UT',ytitle='Amplitude',xtickformat='Xtlab',xticks=3,$
        title=string(nname(ii))+'mV/m'
         widget_control,state.text,set_value=string(cm_val.(ii)[0:500])
         ;WIDGET_CONTROL, state.field, SET_VALUE = string(strupcase(nname[ii]))
         WIDGET_CONTROL, state.dat_info, SET_VALUE = string(strupcase(nname[ii]))
  endif
for ii=4,9 do $
  if dat5 EQ nname(ii) then $
	begin
        plot,cm_val.(0),cm_val.(ii),xtitle='UT',ytitle='Amplitude',xtickformat='Xtlab',xticks=3,$
        title=string(nname(ii))+'(nT)'
        widget_control,state.text,set_value=string(cm_val.(ii)[0:500])
        ;WIDGET_CONTROL, state.field, SET_VALUE = string(strupcase(nname[ii]))
         WIDGET_CONTROL, state.dat_info, SET_VALUE = string(strupcase(nname[ii]))
  endif
   print,Dat5
end

pro testwidg3
common cm_crres,state,cm_eph,cm_val
base = WIDGET_BASE(title='UniNew SPG CRRES spacecraft data handling',$
/base_align_top,/row,/FRAME,mbar=bar)
base2=widget_base(base,/COLUMN,/ALIGN_TOP)
base3=widget_base(base,/column,/ALIGN_TOP)
;**************************************************

file_menu=WIDGET_BUTTON(bar, VALUE='File', /MENU)
Edit_menu=WIDGET_BUTTON(bar, VALUE='Edit', /MENU)
Ephermius_menu=WIDGET_BUTTON(bar,uvalue='ephm',VALUE='Ephermius', /MENU)
Data_menu=WIDGET_BUTTON(bar, VALUE='Data', /MENU)
Help_menu=WIDGET_BUTTON(bar, VALUE='Help', /MENU)

;**************************************************
orb_info = WIDGET_LABEL(base2,value='WELCOME',/DYNAMIC_RESIZE)
dat_info= WIDGET_LABEL(base2,value='SPACE PHYSICS',/DYNAMIC_RESIZE)
text=widget_text(base2,xsize=20,ysize=20,/SCROLL,/WRAP)
;****************************************************************************
eph_res,epph
eph_desc=strarr(n_elements(epph))
for ii=0,n_elements(eph_desc) -1 do $
 eph_desc[ii] = '0\'+epph[ii]+'\eph_menu_event'

fil_desc=['0\New','0\Open','0\Save','0\Save As','0\Close','0\Exit']
Ed_desc=['0\Undo','0\Cut','0\Copy','0\Paste','0\Delete']
dat_desc=['0\EX\Dat_menu_event','0\EY\Dat_menu_event','0\EZ\Dat_menu_event',$
'0\BX\Dat_menu_event','0\BY\Dat_menu_event','0\BZ\Dat_menu_event']
;*****************************************************************************
eph_menu = CW_PDMENU(Ephermius_menu, eph_desc,IDS='ff', uvalue='f2', /RETURN_NAME,/mbar)
fil_menu = CW_PDMENU(file_menu, fil_desc,uvalue='f3', /RETURN_NAME,/mbar)
Ed_menu = CW_PDMENU(Edit_menu, ed_desc,uvalue='f4', /RETURN_NAME,/mbar)
Dat_menu = CW_PDMENU(Data_menu, dat_desc,uvalue='f5',IDS='Dat5', /RETURN_NAME,/mbar)

;*****************************************************************************
draw = WIDGET_DRAW(base3,YSIZE=300,XSIZE=350,uvalue='drawID', /FRAME)

;*****************************************************************************
eeph=strarr(1)
 state={fil_menu:fil_menu,$
        Ed_menu:Ed_menu,$
        eph_menu:eph_menu,$
        Dat_menu:Dat_menu,$
        text:text,epph:epph,$
        ephss:0L,draw:draw,$
        orb_info:orb_info,$
        dat_info:dat_info}

;**************************************************
;WIDGET_CONTROL, state.draw, /REALIZE
WIDGET_CONTROL, base, /REALIZE
WIDGET_CONTROL, base,set_uvalue=state
WIDGET_CONTROL, state.eph_menu, sensitive=0
WIDGET_CONTROL, state.Dat_menu, sensitive=0
XMANAGER, 'testwidg2', base,/no_block
end

