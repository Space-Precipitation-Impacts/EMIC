
Pro Ex_cal_event,ev
common cm_crres,state,cm_eph,cm_val
widget_control, ev.top,get_uvalue=Exgroup,/hourglass
widget_control,Exgroup.cuttoff,get_value=cut
print,cut
cut=float(cut[0])
Ex_calcul,cm_eph,cm_val,state,cut
widget_control,ev.id,set_value='Calculate Again'
end

Pro Ex_cal
common cm_crres,state,cm_eph,cm_val
;common lowchoice ,filtords,fieldch,cut
;SSInt=ABS(cm_val.(0)[1] - cm_val.(0)[0])
;stop
 PI=3.14159265359
;SSSInt=SSINt/1000.0
;stop
;cut=float(6.0)
;SFreq=1./SSSINt
;NyF=SFreq/2.
base=widget_base(/column,title='Ex Calc')
cuttoff=cw_field(base,title='CuttOff in degrees',value=70.0,$
uvalue='cut',/column,/return_event,/string)
texts=widget_text(base,value='Minimum Alpha angle:'$
+string(mIN(cm_val.(10))/PI*180.0,format='(F0)'))
texts2=widget_text(base,value='Maximum Alpha angle:'$
+string(mAX(cm_val.(10))/PI*180.0,format='(F0)'))
Ex_butt=widget_button(base,value='Calculate Ex',uvalue='Ex_butt')
Exgroup={base:base,cuttoff:cuttoff,Ex_butt:Ex_butt}

widget_control,base,/realize
widget_control,base,set_uvalue=Exgroup
Xmanager,'Ex_cal', base,/no_block
end