;Programm to drav 2D graphs as image with possibility to stire them as PostScript
;file of a reasonable size


pro ps_contour, arg1, x, y, $

;arg1 - 2D array to be drawn
;x - horizontal axis coordinates
;y - vertical axis

 ;Optional parameters
 tit = tit,$					;Main title
 xtit = xtit, ytit = ytit,$ 	;X and Y titles
 nlevel = nlevel,$ 				;Number of contours
 xticks = xticks,$				;Number of ticks in the color table
 scale =scale,$					;Scaling factor (<1 - decrease, >1 - increase picture size)
 units = units,$				;Units in the color map
 xrange = xrange, yrange = yrange, zrange = zrange,$	;Ranges
 irregular = irregular,$								;Set it up for the irregularly gridded data
 file = file,$					;Output filename for the Post Script plot
 SM=sm,$						;Smoothing factor
 ylog = ylog,xlog =xlog,zlog = zlog,$	;Logarithmic sale
 n_win=n_win,$ 					;Window's number if you want to plot different graphs to different windows
 PS=ps, $						;Printing to PS file
 ctab = ctab,$					;Colour table number (default is B&W)
 txt = txt,$					;Overplotted text (convenient for the irregularly spaced data)
 col = col,$					;Overplotted text colour
 bottom = bottom				;Position of the color map


;Setting number of colours
device, decomposed=0

;Window's number
if keyword_set(n_win) then n_win=n_win else n_win=1

;Checking the size of the array
m=size(arg1)
print,'m',m
arg=arg1

;Resizing original array to 2D one if it is not so (necessary for smoothing).
if m(0) eq 3 then begin
arg=fltarr(m(2),m(3))
arg(*,*)=arg1(0,*,*)
endif

arg1=arg


;Setting font type and size

!p.font=0
DEVICE, SET_FONT='Times', /TT_FONT
!x.thick=2
!y.thick=2








;Output filename
file_name='c:/ps.ps'

if keyword_set(file) then file_name=file


;number of levels
nlev=20
if keyword_set(nlevel) then nlev=nlevel


;Irregular grid
irreg=0
if keyword_set(irregular) then irreg=1



;number of tiks in the color map
xtick=5
if keyword_set(xticks) then xtick=xticks

;Color map
cl=0 	;Default

if keyword_set(ctab) then cl=ctab


;Smoothing


if keyword_set(sm) then arg1=smooth(arg1,sm)

xran=[min(x), max(x)]
yran=[min(y), max(y)]
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

;Horizontal and vertical size of the main image
xlength=14/scal
ylength=10/scal
;Left corner of the main image
xin=3.
yin=29.7-3.-ylength

;Left corner of the colour scheme image
xin1=xin+3./scal;8.5
yin1=yin-3./scal;2.
;Size of the color scale image
xlength1=8./scal
ylength1=0.5/scal




;Left corner of the colour scheme image
xin1_=xin+xlength+2./scal;8.5
yin1_=yin+1./scal;2.
;Size of the color scale image
ylength1_=8./scal
xlength1_=0.5/scal







WINDOW, n_win, ySIZE=594+149, xSIZE=420+105, TITLE=tit


;Setting the PS image format
if keyword_set(ps) then begin
   	set_plot, 'ps'
   	device,filename=file_name,/portrait,/color, xoffset=0.,yoffset=0,xsize=21.0,ysize=29.7
endif

	cimage = bytscl(indgen(nlev)); # replicate(1,20));, top = !d.n_colors)	;Color scale
	cimage_ = bytscl(indgen(1,nlev))





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


xin1_=xin1_/21.0
yin1_=yin1_/29.7
xlength1_=xlength1_/21.
ylength1_=ylength1_/29.7



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



loadct, cl


cc=fltarr(nlev,2)
cc(*,0)=findgen(nlev)
cc(*,1)=findgen(nlev)



cc_=fltarr(2,nlev)
cc_(0,*)=findgen(nlev)
cc_(1,*)=findgen(nlev)

if keyword_set(bottom) then begin
contour, cc,pos=[xin1,yin1,xin1+xlength1,yin1+ylength1],/xstyle,/ystyle,/normal, /nodata, /noerase,tick=0.0001, thick=0.001,charsize=0.001
contour, cc, /fill, nlevels=nlev, levels=findgen(nlev)*(nlev-1.)/nlev,/normal,/overplot, /xstyle,/ystyle, /noerase
endif else begin
contour, cc_,pos=[xin1_,yin1_,xin1_+xlength1_,yin1_+ylength1_],/xstyle,/ystyle,/normal, /nodata, /noerase,tick=0.0001, thick=0.001,charsize=0.001
contour, cc_, /fill, nlevels=nlev, levels=findgen(nlev)*(nlev-1.)/nlev,/normal,/overplot, /xstyle,/ystyle, /noerase
endelse
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


if keyword_set(bottom) then begin
plot,zran,[0,0],xstyle=1,ystyle=1,/noerase,position=[xin1,yin1,$
		xin1+xlength1,yin1+ylength1],xticklen=1.,yticklen=0.001,xticks=xtick,yticks=0,charsize=chsiz*2./3.,$
		ycharsize=0.01,xtitle = unit,$
		/normal, color=0
endif else begin
plot,[0,0], zran,xstyle=1,ystyle=1,/noerase,position=[xin1_,yin1_,$
		xin1_+xlength1_,yin1_+ylength1_],yticklen=1.,xticklen=0.001,yticks=xtick,xticks=0,charsize=chsiz*2./3.,$
		xcharsize=0.01,title = unit,$
		/normal, color=0
endelse


if keyword_set(ps) then begin
device, /close
set_plot,'win'
endif
loadct,0
end