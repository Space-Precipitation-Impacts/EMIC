Pro xy_plots2
ct =long(0)
ct2 =long(0)
mlat =fltarr(6)
poynt =fltarr(6)
text=' '
openr,u,'lshell_ut.txt',/get_lun
readf,u,text
while not eof(u) do $
begin
readf,u,mlats,poynts
 ;if abs(text) LT 10.0 then $
 ;begin
 ;print,text
mlat[ct]=mlats
poynt[ct]=poynts

 ct = ct + 1
 ;stop
 ;end
 ;if text GT 10.0 then $
 ;ct2 =ct2 + 1
end
close,u
;Y = [0, 1, 0, -1, 0]
;X = [-1, 0, 1, 0, -1]

;USERSYM, X, Y,/fill
FName=DIALOG_PICKFILE(title='Select File', FILTER = '*.*',/WRITE,/NOCONFIRM)
set_plot,'ps'
device,filename=FName,yoffset=3, ysize=13
!P.charsize=1.0
!Y.style=3
!P.ticklen=0.02

day=['1-2','2-3','3-4','4-5','5-6','6-7']
XVAL = FINDGEN(6)/6. + .085
YVAL = [poynt[0], poynt[1], poynt[2], poynt[3], poynt[4], poynt[5]]
plot,xval,yval, XTICKV = XVAL,xrange=[0,1],XTICKS = 5,XTICKNAME = day,/nodata,/YNOZERO,$
xtitle='L Shell',ytitle='Time (hours)',title='CRRES L Shell Coverage Orbit 3 - 1067'
;AXIS, XAXIS=0,XTICKn=DAY
FOR I = 0, 5 DO BOX, XVAL[I] - .08, !Y.CRANGE[0], $
     XVAL[I] + 0.08, YVAL[I], 0
;xrange=[xval[0]-xval[0]/2+0.013,1]
!P.charsize=1.0
!Y.style=3
!P.ticklen=0.04
device,/close
end