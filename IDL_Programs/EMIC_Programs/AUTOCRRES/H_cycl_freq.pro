Pro H_cycl_freq ,state,cm_eph,cm_val,Dat5
const=0.0963542
PI=3.14159265359
;LoadCT,13

;window,10,xsize=500,ysize=500
oplot,cm_val.(0),[const*cm_val.(9)]/(2*pi),color=255,thick=2.0;,/noerase,/device;,xtickformat="XTlab",xstyle=1
end
