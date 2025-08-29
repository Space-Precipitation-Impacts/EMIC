Pro higa_event,ev
common orbinfo,orb,orb_binfile,orb_date
common cm_crres,state,cm_eph,cm_val
common lowchoice ,filtords,fieldch,cut
widget_control, ev.top,get_uvalue=lowgroup
widget_control,lowgroup.cuttoff,get_value=cut
;widget_control,lowgroup.field_choice,get_uvalue=fch
widget_control,lowgroup.filt_ord,get_value=filtords
widget_control,lowgroup.field_choice,get_value=fieldch
 widget_control,lowgroup.low_filt,get_value=filter
print,filter
print,fieldch
print,filtords
print,cut
widget_control,ev.id,get_uvalue=vval
if vval EQ 'filter' then $
   begin
  widget_control,ev.id,set_value='Filtering...'
  lowpass,lowgroup
  endif
end

Pro higha,Pros5
common cm_crres,state,cm_eph,cm_val
common highchoice ,filtords,fieldch,cut
SSInt=ABS(cm_val.(0)[1] - cm_val.(0)[0])
;stop
SSSInt=SSINt/1000.0
;stop
cut=6.0
SFreq=1./SSSINt
NyF=SFreq/2.
Npts=n_elements(cm_val.(0))
base=widget_base(/column,title='HighPass Filter')
cuttoff=cw_field(base,title='Highpass CuttOff (mHz)',value=32.0,$
uvalue='cut',/column,/return_event,/string)
texts=widget_text(base,value='Nyquist Freq:'+string(NyF,format='(F0)')+'Hz')
textss=widget_text(base,value='No. Points in each:'+string(Npts,format='(I0)'))
field=['dB Fields','Bmain Fields','E fields']
orders=['1','2']
filt=['Forward','Backward','Normal']
field_choice  = CW_BGroup(base,field,UValue='fieldch',ids='fieldids',$
      Label_top='Fields to Highpass',Set_Value=1,/row,/nonExclusive)

Filt_type  = CW_BGroup(base,filt,UValue='filttype',ids='filtids',$
      Label_top='Filter Type',Set_Value=1,/row,/Exclusive)
low_filt=widget_button(base,value='Filter',uvalue='filter')
lowgroup={base:base,cuttoff:cuttoff,field:field,$
			field_choice:field_choice,low_filt:low_filt,$
			texts:texts}

widget_control,base,/realize
widget_control,base,set_uvalue=lowgroup
Xmanager,'lowa', base,/no_block
end
