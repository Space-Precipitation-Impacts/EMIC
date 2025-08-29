;AUTHOR: T. Loto'aniu
;DATE: June 2001
;PURPOSE: Initialization Widget Control
;
Pro init_crres_widget_event,ev
common despike_para,des_limit,grad_limit
common init_struct,state2
common init_parameter,idl_path,data_path,eph_path,res_path,eve_path,spl_int,fre_int,log_path
common fre_timres, fft_limit, timres_limit
WIDGET_CONTROL, ev.top, get_uvalue=state2,/HOURGLASS
WIDGET_CONTROL, ev.id, get_uvalue=uval
WIDGET_CONTROL, state2.init1_menu, get_value=idl_path
WIDGET_CONTROL, state2.init2_menu, get_value=data_path
WIDGET_CONTROL, state2.init3_menu, get_value=eph_path
WIDGET_CONTROL, state2.init4_menu, get_value=res_path
WIDGET_CONTROL, state2.init5_menu, get_value=eve_path
WIDGET_CONTROL, state2.init6_menu, get_value=spl_int
WIDGET_CONTROL, state2.init7_menu, get_value=fre_int
WIDGET_CONTROL, state2.init8_menu, get_value=log_path
WIDGET_CONTROL, state2.init11_menu, get_value=des_limit
WIDGET_CONTROL, state2.init12_menu, get_value=grad_limit
WIDGET_CONTROL, state2.init21_menu, get_value=fft_limit
WIDGET_CONTROL, state2.init22_menu, get_value=timres_limit
fft_limit = fix(fft_limit[0])
timres_limit = fix(timres_limit[0])

CASE uval OF
'initcanc' :widget_control, ev.top,/destroy
'initdone' :Begin
			widget_control, ev.top,/destroy

			Init_Crres_Parameters
			CRRES_WIDGET_AUTO
			end
ENDCASE

end


Pro init_crres_widget
common init_struct,state2
base5=widget_base(/column,title='Spacecraft Data Initialization Parameters',/ALIGN_TOP)
base7=widget_base(base5,/COLUMN,/ALIGN_TOP)
base6=widget_base(base5,/ROW,/ALIGN_CENTER)


;*****************************************************************************
;base5 Widget Base for Initialization of Parameters
;
init1_menu =  CW_FIELD(base7,XSIZE=30, TITLE=string('IDL Codes Directory:',format='(A33)'),$
uvalue='f20',$
value='c:\paul\phd\crres\autocrres')
init2_menu =  CW_FIELD(base7,XSIZE=30, TITLE=string('Telemetry Directory:',format='(A34)'),$
uvalue='f8',$
value='c:\paul\phd\crres\data')
init3_menu =  CW_FIELD(base7,XSIZE=30, TITLE=string('Ephemeris Directory:',format='(A33)'),$
uvalue='f9',$
value='c:\paul\phd\crres\eph')
init4_menu =  CW_FIELD(base7,XSIZE=30, TITLE=string('Results Directory:',format='(A36)'),$
uvalue='f10',$
value='c:\paul\phd\crres\results')
init5_menu =  CW_FIELD(base7,XSIZE=30, TITLE=string('Events Paramters Directory:',format='(A29)'),$
uvalue='f11',$
value='c:\paul\phd\crres\events')
init8_menu =  CW_FIELD(base7,XSIZE=30, TITLE=string('Logs Directory:',format='(A37)'),$
uvalue='f14',$
value='c:\paul\phd\crres\log')
init7_menu =  CW_FIELD(base7,XSIZE=10, TITLE=string('Frequency to Remove Spacecraft Phasing (Hz):',format='(A54)'),uvalue='f13',$
value='6.0')
init21_menu =  CW_FIELD(base7,XSIZE=10, TITLE=string('FFT length (points):',format='(A75)'),uvalue='f21',$
value='800')
init22_menu =  CW_FIELD(base7,XSIZE=10, TITLE=string('Time Resolution length (points):',format='(A68)'),uvalue='f22',$
value='80')
init6_menu =  CW_FIELD(base7,XSIZE=10, TITLE=string('Spline Sigma (Cubic=0,Poly=10):',format='(A65)'),uvalue='f12',$
value='0.1',/return_event,/string)
init11_menu =  CW_FIELD(base7,XSIZE=10, TITLE=string('Despiking Limit (Points):',format='(A73)'),uvalue='f20',$
value='40.0',/return_event,/string)
init12_menu =  CW_FIELD(base7,XSIZE=10, TITLE=string('Despiking Limit (Normalized Gradient):',format='(A64)'),uvalue='f21',$
value='1.0',/return_event,/string)
init9_menu =  WIDGET_BUTTON(base6,XSIZE=100,$
value='Done',uvalue='initdone')
init10_menu =  WIDGET_BUTTON(base6,XSIZE=100,$
value='Cancel',uvalue='initcanc')

;*****************************************************************************************
		state2={base5:base5,$
		base6:base6,$
		init1_menu:init1_menu,$
		init2_menu:init2_menu,init3_menu:init3_menu,init4_menu:init4_menu,$
		init5_menu:init5_menu,init6_menu:init6_menu,init7_menu:init7_menu,$
		init8_menu:init8_menu,init9_menu:init9_menu,init10_menu:init10_menu,$
		init11_menu:init11_menu,init12_menu:init12_menu,init21_menu:init21_menu,$
		init22_menu:init22_menu}

geo= widget_info( base5, /geo )
  x= 600- geo.xsize/2
  y= 300- geo.ysize/2
 ;**************************************************
 widget_control, base5, xoffset=x, yoffset=y

WIDGET_CONTROL, base5, /REALIZE,update=1
WIDGET_CONTROL, base5,set_uvalue=state2
XMANAGER, 'INIT_CRRES_WIDGET', base5,/no_block
end