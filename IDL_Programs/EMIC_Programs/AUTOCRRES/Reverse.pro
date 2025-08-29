Pro Reverse,XDat,YDat,LenX
common init_parameter,idl_path,data_path,eph_path,res_path,eve_path,spl_int,fre_int,log_path
common cm_crres,state,cm_eph,cm_val
Print,'Reversing Data...'
WIDGET_CONTROL, state.text,SET_VALUE = 'Reversing Data...',/append
 For i=Long(0),Long(LenX-1) do $
  YDat(i)=XDat(LenX-i-1)
 XDat=YDat
 For i=Long(0),Long(LenX-1) do $
  YDat(i)=0
end
