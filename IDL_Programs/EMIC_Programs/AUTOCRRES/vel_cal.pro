
Pro vel_cal_event,ev
common cm_crres,state,cm_eph,cm_val
widget_control,ev.id,set_value='Calculating...'

widget_control, ev.top,get_uvalue=group,/hourglass
widget_control,group.texts,set_value='                    '
widget_control,group.cuttoff,get_value=cut
widget_control,group.cuttoff1,get_value=cut1
widget_control,group.cuttoff2,get_value=cut2
widget_control,group.cuttoff3,get_value=cut3

cut=float(cut[0])
cut1=float(cut1[0])
cut2=float(cut2[0])
cut3=float(cut3[0])
if cut+cut1+cut2 NE float(1.0) then	$
begin
print,'Ratios must add to 1.0'
widget_control,group.texts,set_value='Error! Change Ratios'
widget_control,state.text,set_value='Error! Change Ratios. '+$
'The ratios must add up to 1.0'
widget_control,ev.id,set_value='Calculate Velocity'
end else $
begin
Dat5='ALFVEN VELOCITY'
widget_control,state.text,set_value='Calculating Alfven and Phase Velocities....'
alfven_velocity,cm_eph,cm_val,state,group,Dat5
;Ex_calcul,cm_eph,cm_val,state,cut
widget_control,state.text,set_value='Done!'
widget_control,group.texts,set_value='                    '
widget_control,ev.id,set_value='Calculate Again'
end
end

Pro vel_cal,path
common cm_crres,state,cm_eph,cm_val
common orbinfo,orb,orb_binfile,orb_date
PI=3.14159265359

base=widget_base(/column,title='Velocity Calc')

texts1=widget_label(base,value='Heavy Ion Ratio')
cuttoff=cw_field(base,title='H+         ',value=0.8,$
uvalue='cut',/row,/return_event,/string)

cuttoff1=cw_field(base,title='He+       ',value=0.15,$
uvalue='cut1',/row,/return_event,/string)

cuttoff2=cw_field(base,title='O+         ',value=0.05,$
uvalue='cut2',/row,/return_event,/string)

cuttoff3=cw_field(base,title='Freq(Hz) ',value=1.0,$
uvalue='cut3',/row,/return_event,/string)

texts=widget_label(base,value='ratios must add up to 1.0')

vel_butt=widget_button(base,value='Calculate Velocity',uvalue='Ex_butt')

group={base:base,cuttoff1:cuttoff1,$
		cuttoff2:cuttoff2,cuttoff3:cuttoff3,$
		cuttoff:cuttoff,vel_butt:vel_butt,texts:texts}

widget_control,base,/realize
widget_control,base,set_uvalue=group
Xmanager,'Vel_cal', base,/no_block
end