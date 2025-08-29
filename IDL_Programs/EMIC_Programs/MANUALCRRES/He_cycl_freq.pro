Pro He_cycl_freq ,state,cm_eph,cm_val,Dat5
const=0.0240729021
consto=0.0009578308725
PI=3.14159265359
;LoadCT,13

;window,10,xsize=500,ysize=500
oplot,cm_val.(0),[const*cm_val.(9)]/(2*pi),color=255,thick=2.0;,/noerase,/device;,xtickformat="XTlab",xstyle=1
oplot,cm_val.(0),consto*cm_val.(9),color=255,thick=2.0;,/noerase,/device;,xtickformat="XTlab",xstyle=1
end
