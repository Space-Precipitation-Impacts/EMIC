pro timeax_j,xlow,xhigh,xticks,xtickv,xtickname,xminor
;
;  J.C. Samson,   February, 1994
;
;  Version 1.02
;
; procedure timeax provides arrays of
; tick values and tick names for a time axis
; given xlow and xhigh in hours
; #hours is calculated by subtracting xhigh-xlow
; xtickv and tickname can be used in the plot procedure
; xtickv and tickname have length "xticks+1"
;-
;

xrng=xhigh-xlow
if xrng Lt 1.0/6.0 then begin
        xminor=4
	xticks=4
	minstep=xrng/float(xticks)
	xtickv=fltarr(xticks+1)
	xtickname=strarr(xticks+1)
	for i=0,xticks do begin
		time=xlow+float(i)*minstep
		xtickv(i)=time
		xtickname(i)=tim(time)
	end
endif else begin
	if xrng Lt 0.5 then begin
	  xminc=[':00',':05',':10',':15',':20',':25',':30', $
	         ':35',':40',':45',':50',':55']
	  minstep=5.0/60.0
	  xminor=5
	endif else begin
	  xminc=[':00',':15',':30',':45']
	  minstep=15.0/60.0
	  xminor=3
	endelse

	xhrc=[' 0',' 1',' 2',' 3',' 4',' 5',' 6', $
	      ' 7',' 8',' 9','10','11','12','13', $
	      '14','15','16','17','18','19','20', $
	      '21','22','23','24']

;
; minstep and xminc should be consistent
;
;
; Determine the ticks and step intervals
;
	n=fix(alog(xrng/(minstep*8))/alog(2))+1
	step=2.0^float(n)*minstep
	if step Gt 0.5 then xminor=4
	xstart=float(fix((xlow-0.001)/step+1))*step
	numticks=fix((xhigh-xstart)/step)+1
	xticks=numticks-1
	xtickname=strarr(numticks)
	xtickv=fltarr(numticks)
	for j=0,xticks do begin
	   xtickv(j)=xstart+float(j)*step
	   kminute=fix((xtickv(j)-fix(xtickv(j)))/minstep+0.0001)
	   khour=fix(xtickv(j))
	   if khour Ge 24 then khour=khour-24
	   xtickname(j)=xhrc(khour)+xminc(kminute)

	end
endelse

END

