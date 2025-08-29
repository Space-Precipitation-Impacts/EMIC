;Programm to drav 2D graphs as image with possibility to stire them as PostScript
;file of a reasonable size
Function XTLab,Axis,Index,Value			;Function to format x axis into hours:minutes:seconds.frac
 mSec=long(Value)
 milsec=long(mSec) Mod 1000
 seci=Long(mSec/1000)
 secf = long(seci) mod 60
 mni=Long(seci)/60
 mnf = long(mni) mod 60
 hr = Long(mni/60)
 Return,String(hr,mnf,$
  Format="(I2.2,':',I2.2)")
end


pro ps_contour, arg1, x, y, tit = tit,$
 xtit = xtit, ytit = ytit,$
 nlevel = nlevel,$
 xticks = xticks,$
 scale =scale,$
 units = units,$
 xrange = xrange, yrange = yrange, zrange = zrange,$
 irregular = irregular,$
 file = file,$
 col = col,$
 SM=sm,$
 ylog = ylog,$
 xlog =xlog,$
 zlog = zlog,$
 n_win=n_win,$ ;Windows number
 PS=ps, ctab = ctab,txt = txt,$
 xtickformat=xtickformat

;common cm_crres,state,cm_eph,cm_val
device, decomposed=0

if keyword_set(n_win) then n_win=n_win else n_win=1

;Checking the size of the array
m=size(arg1)
print,'m',m
arg=arg1

;Resizing original array to 2D one if it is not so.
if m(0) eq 3 then begin
arg=fltarr(m(2),m(3))
arg(*,*)=arg1(0,*,*)
endif

arg1=arg

;tit - title
;xtit - X axis title
;ytit - Y axis title
;arg1 - 2D array to be drawn
;x - horizontal axis coordinates
;y - vertical axis
;cl - colour table
;
;Keywords:
;;SM - smoothing
;PS - writing a PostScript file


!p.font=0
DEVICE, SET_FONT='Times', /TT_FONT
!x.thick=2
!y.thick=2

;Text



;Output filename
file_name='c:\paul\phd\crres_eph_idl\eph\ps.ps'

if keyword_set(file) then file_name=file


;number of levels


nlev=20
if keyword_set(nlevel) then nlev=nlevel


;Irregular grid
irreg=0
if keyword_set(irregular) then irreg=1


if keyword_set(xtickformat) then xtickformat=xtickformat

;number of tiks in the color map

xtick=5
if keyword_set(xticks) then xtick=xticks
;Color map
cl=0

if keyword_set(ctab) then cl=ctab

;if ctab eq -1 then cl=0


;Smoothing


if keyword_set(sm) then arg1=smooth(arg1,sm)

xran=[min(x), max(x)]

yran=[min(y), max(y)]
;yran=[0,MxF]
zran=[min(arg1), max(arg1)]
if keyword_set(xrange) then xran=xrange
if keyword_set(yrange) then yran=yrange
if keyword_set(zrange) then zran=zrange

xlog_=0
ylog_=0
zlog_=0

if keyword_set(xlog) then xlog_=1
if keyword_set(ylog) then ylog_=1
if keyword_set(zlog) then zlog_=1



;Units for a color map
 unit=''
if keyword_set(units) then unit=units

scal=1.

if keyword_set(scale) then scal=scale

;Establishing scales and sizes for the screen picture


;Preparing the window for drawing
!p.multi=0

loadct,cl


chsiz=1.5/scal

!p.charsize=chsiz

;Size of the image in centimeters on A4 page
;Left corner of the main image
xin=3.
yin=5.
;Horizontal and vertical size of the main image
xlength=16/scal
ylength=10/scal
;Left corner of the colour scheme image
xin1=xin+4/scal;8.5
yin1=yin-3./scal;2.
;Size of the color scale image
xlength1=8./scal
ylength1=0.5/scal


WINDOW, n_win, ySIZE=594+149, xSIZE=420+105, TITLE=tit


;Setting the PS image format
if keyword_set(ps) then begin
   	set_plot, 'ps'
   	device,filename=file_name,/portrait,/color, xoffset=0.,yoffset=0,xsize=21.0,ysize=29.7
endif

	cimage = bytscl(indgen(nlev)); # replicate(1,20));, top = !d.n_colors)	;Color scale






;PS format







;Conversion of the sizes into NORMAL coordinates
;necessary to draw the axes properly (PLOT procedure does not allow /CENTIMETERS!)
xin=xin/21.0
yin=yin/29.7
xlength=xlength/21.
ylength=ylength/29.7

xin1=xin1/21.0
yin1=yin1/29.7
xlength1=xlength1/21.
ylength1=ylength1/29.7
loadct,0

lev=findgen(nlev)*(max(zran)-min(zran))/nlev+min(zran)


contour, arg1,x,y, /fill,/xstyle,/ystyle,/ZSTYLE,$;/overplot,$
xrange=xran, yrange=yran,nlevel=nlev,$
zrange = zran,$
levels=lev,$
/nodata,$
irregular=irreg,$
xlog=xlog_,$
ylog=ylog_,$
zlog=zlog_,$
pos=[xin,yin,xin+xlength,yin+ylength],/normal, background=255

loadct,cl
contour, arg1, x, y, /fill,/xstyle,/ystyle,$
levels=lev,$
irregular=irreg,$
nlevel=nlev,/overplot,zrange = zran, /ZSTYLE;, LEVELS=FINDGEN(20)*(zran(*,0)-zran(0,*))/20.+zran(0,*);,$

;Mapping the stations

if keyword_set(txt) then begin
	col_=255
	if keyword_set(col) then col_=col
	xyouts,x,y,txt, color=col_, alignment=0.5, charsize=1
endif






;xrange=[min(x),max(x)], yrange=[min(y),max(y)],$
;zrange=zran,$
;pos=[xin,yin,xin+xlength,yin+ylength],/normal



loadct, cl


;xin1=xin1*29.7
;yin1=yin1*21.
;xlength1=xlength1*29.7
;ylength1=ylength1*21.


cc=fltarr(nlev,2)
cc(*,0)=findgen(nlev)
cc(*,1)=findgen(nlev)

;tvscl, cimage,xin1*29.7,yin1*21.,xsize=xlength1*29.7,ysize=ylength1*21.,/centimeters;;;;;;;;;;;;;;
contour, cc,pos=[xin1,yin1,xin1+xlength1,yin1+ylength1],/xstyle,/ystyle,/normal, /nodata, /noerase,tick=0.0001, thick=0.001,charsize=0.001
contour, cc, /fill, nlevels=nlev, levels=findgen(nlev)*(nlev-1.)/nlev,/normal,/overplot, /xstyle,/ystyle, /noerase




;device, decomposed=0
;Colour scheme (B&W) for the axes anf d titles

;loadct,0

;xin1=xin1/29.7
;yin1=yin1/21.
;xlength1=xlength1/29.7
;ylength1=ylength1/21.


;Plotting axes and title for the PS format


loadct,0

;stop

plot,[0,1],[0,1],xstyle=1,ystyle=1,xrange=xran, $
    	yrange=yran,$;XTickFormat='XTLab', $
    	/noerase,/normal,/nodata,xtitle=xtit,ytitle=ytit,$
		pos=[xin,yin,xin+xlength,yin+ylength],charsize=chsiz,ticklen=1.,$
		title=tit, color=0,$
		xlog=xlog_,$
		ylog=ylog_

plot,zran,[0,0],xstyle=1,ystyle=1,/noerase,position=[xin1,yin1,$
		xin1+xlength1,yin1+ylength1],xticklen=1.,yticklen=0.001,xticks=xtick,yticks=0,charsize=chsiz,$
		ycharsize=0.01,xtitle = unit,$
		/normal, color=0
if keyword_set(ps) then begin
device, /close
set_plot,'win'
endif
;loadct,0
end