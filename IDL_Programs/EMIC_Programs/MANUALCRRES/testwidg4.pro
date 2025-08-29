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

PRO testwidg4_event, ev
common cm_crres,state,cm_eph,cm_val
WIDGET_CONTROL, ev.top, get_uvalue=state,/HOURGLASS

 if ev.id EQ state.fil_menu then $
  begin
    if ev.value EQ 'New' then $
     begin
      WIDGET_CONTROL, state.eph_menu, sensitive=0
	  WIDGET_CONTROL, state.Dat_menu, sensitive=0
	  WIDGET_CONTROL, state.text,set_value=string('')
	  WIDGET_CONTROL, state.dat_info,SET_VALUE =string(' ')
	  WIDGET_CONTROL, state.ORB_info,SET_VALUE =string(' ')

	endif
    if ev.value EQ 'Open'then $
     begin
      FName=DIALOG_PICKFILE(title='Select File', FILTER = '*.*',/READ,/NOCONFIRM)

      if strlowcase(strmid(Fname,39,3)) EQ '0ep' then $
       begin
        orb_binfile=strmid(Fname,30,8)
        eph_crfiles,orb,orb_binfile,orb_date
        fileph,FName,ephv,state
        cm_eph=ephv
        print,cm_eph.(0)
        print,tag_names(cm_eph)
        WIDGET_CONTROL, state.eph_menu, sensitive=1
        WIDGET_CONTROL, state.orb_info,SET_VALUE = 'Orbit'+string(orb)+'  '+string(orb_date)
        WIDGET_CONTROL, state.dat_info,SET_VALUE =string(' ')
        WIDGET_CONTROL, state.file_info,SET_VALUE =string(' ')

      endif else $
      if strmid(Fname,42,3) EQ 'val' then $
        begin
		orb=strmid(Fname,33,3)
         val_crfiles,orb,orb_binfile,orb_date
		 fileph,string(orb_binfile)+'.0ep',ephv,state
        WIDGET_CONTROL, state.orb_info,SET_VALUE = 'Orbit'+string(orb)+'  '+string(orb_date)
		WIDGET_CONTROL, state.dat_info,SET_VALUE =string(' ')
         fileval,Fname,valv,state
         cm_eph=ephv
         cm_val=valv
        WIDGET_CONTROL, state.Dat_menu, sensitive=1
        WIDGET_CONTROL, state.eph_menu, sensitive=1
        WIDGET_CONTROL, state.file_info,SET_VALUE =string(' ')
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
eph_plot,state,cm_eph,cm_val,ff
end

PRO Dat_menu_event, ev
common cm_crres,state,cm_eph,cm_val
WIDGET_CONTROL, ev.top, get_uvalue=state,/HOURGLASS
WIDGET_CONTROL, ev.id,get_uvalue=Dat5
print,dat5
val_plot,state,cm_eph,cm_val,Dat5
end

PRO Dat_menu_Poynt_event, ev
common cm_crres,state,cm_eph,cm_val
WIDGET_CONTROL, ev.top, get_uvalue=state,/HOURGLASS
WIDGET_CONTROL, ev.id,get_uvalue=Dat5
print,dat5
DPFlux2,state,cm_val,cm_eph,Dat5
end

pro testwidg4
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
Series_menu=WIDGET_BUTTON(bar, VALUE='Series', /MENU)
Help_menu=WIDGET_BUTTON(bar, VALUE='Help', /MENU)

;**************************************************
file_info = WIDGET_LABEL(base3,value=' ',/DYNAMIC_RESIZE)
orb_info = WIDGET_LABEL(base2,value='WELCOME',/DYNAMIC_RESIZE)
dat_info= WIDGET_LABEL(base2,value='SPACE PHYSICS',/DYNAMIC_RESIZE)
text=widget_text(base2,xsize=20,ysize=20,/SCROLL)
;****************************************************************************
eph_res,epph,filp,Edp,datp,serp
eph_desc=epph
fil_desc=filp
Ed_desc=Edp
dat_desc=datp
ser_desc=serp
;*****************************************************************************
eph_menu = CW_PDMENU(Ephermius_menu, eph_desc,IDS='ff', uvalue='f2', /RETURN_NAME,/mbar)
fil_menu = CW_PDMENU(file_menu, fil_desc,uvalue='f3', /RETURN_NAME,/mbar)
Ed_menu = CW_PDMENU(Edit_menu, ed_desc,uvalue='f4', /RETURN_NAME,/mbar)
Dat_menu = CW_PDMENU(Data_menu, dat_desc,uvalue='f5',IDS='Dat5', /RETURN_NAME,/mbar)
Ser_menu = CW_PDMENU(Series_menu, ser_desc,uvalue='f6', /RETURN_NAME,/mbar)
dom1_menu =  CW_PDMENU(base2, ser_desc,uvalue='f7', /RETURN_NAME)


;*****************************************************************************
draw = WIDGET_DRAW(base3,YSIZE=300,XSIZE=350,uvalue='drawID', /FRAME)
dom2_menu =  CW_FIELD(base3, TITLE='Enter the Spectral Weighting, n [f^n] : ',uvalue='f8')
;*****************************************************************************
eeph=strarr(1)
state={fil_menu:fil_menu,$
        Ed_menu:Ed_menu,$
        eph_menu:eph_menu,$
        Dat_menu:Dat_menu,$
        ser_menu:ser_menu,$
        text:text,epph:epph,$
        ephss:0L,draw:draw,$
        orb_info:orb_info,$
        dat_info:dat_info,$
        file_info:file_info}

;**************************************************
WIDGET_CONTROL, base, /REALIZE
WIDGET_CONTROL, base,set_uvalue=state
WIDGET_CONTROL, state.eph_menu, sensitive=0
WIDGET_CONTROL, state.Dat_menu, sensitive=0
XMANAGER, 'testwidg4', base,/no_block
end

