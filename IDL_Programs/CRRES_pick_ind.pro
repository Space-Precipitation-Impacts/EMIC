; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; Dynamic spectrum plotter for crres_widget.pro
;
;	Requires JHUAPL, IDLAstro & David Fannings routines {probably}.
;
;	Uses Martin Schultz's loglevels.pro (included) for logged colorbar 
;	and contour levels.
;
;							Russell Grew,
;							Feb 2008.
;                                             modified 2012 Alexa Halford
;
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 
;powerspec = the power spectrum array? Not sure where to get this. 
;x = It is no where in the program. I think it would normally have
;been the UT time, but that is found using the time arrays. 
;y = I believe this is the y-array or frequency array which matches
;the powerspec array... 
;timeB = I believe this might be the time array which is then used to
;over plot the cyclotron frequencies. This may be the same as other
;times. 
;time = The time array which we will be plotting 
;title =  The title of the plot
;minfreq = the min. freq to plot 
;maxfreq = the max. freq to plot
;omegaH = the porton cyclotron frequency
;orb_select = commented out. 
;ephpath = the path for the ephemaris data
;eph_select = this seems to be part of the ephemaris data path
;dev = this is the type of plot we want to have i.e. 'x', '.ps', 
;comp = which component we are plotting, 'B' or 'E'
;xran = the xrange for the plot
;logfreq = are we plotting the frequency on a log scale? 'Y'? 
;logpow = are we plotting the power on a log scale? 'Y'?
;plotfile = the file name to write the plot to if dev = '.ps'
;wndw_idx = the number for the plotting window if using dev = 'x'
;autopow = This seems to be a bit odd and redundent with logpow. Needs
;to be looked at and cleaned up.  
;minz = If not using the logpow and/or autopow then the minimum z
;value 
;maxz = If not using the logpow and/or autopow then the maximum z

pro crres_pick_ind, powerspec, x, y, timeB, time, title, minfreq, maxfreq, omegaH, orb_select, $
	ephpath, eph_select, dev, comp, xran, logfreq, logpow, plotfile, wndw_idx, $
	autopow, minz, maxz


; include extra 'timeB' variable for cyclotron frequency overplot (when time eq timeE)


; if logpow eq 'Y' then powerspec = 20 * alog10(powerspec)
; if logfreq eq 'Y' then flog = 1 else flog = 0

; ephemeris
fnm =  ephpath + eph_select +'.eph'
ephread_asc, fnm, lshell, radius, UT, loct, mlt, mlat

startpt = max(where(ut le time[0]))
endpt = min(where(ut ge time[n_elements(time)-1]))

utslice = UT[startpt:endpt]
lslice = lshell[startpt:endpt]
ltslice = loct[startpt:endpt]
mltslice = mlt[startpt:endpt]
mlatslice = mlat[startpt:endpt]

; interpolate for improved accuracy
utint = interpol(utslice,  n_elements(powerspec[*, 0]))
lint = interpol(lslice, n_elements(powerspec[*, 0]))
ltint = interpol(ltslice, n_elements(powerspec[*, 0]))
mltint = interpol(mltslice, n_elements(powerspec[*, 0]))
mlatint = interpol(mlatslice, n_elements(powerspec[*, 0]))

; interpolated UT from telemetry (E or B) data
UT_telem_int = interpol(time, n_elements(powerspec[*, 0]))

UT_telem_int = UT_telem_int / 86400. / 1.E3 - 0.5

; Plot

lab_date=label_date(date_format="%H:%I")

; suitable number of major x ticks
if abs(xran[1] - xran[0]) ge 1.9 / 24. then xtickinterval = 30 else xtickinterval = 15
if abs(xran[1] - xran[0]) le 1. / 24. then xtickinterval = 10
if abs(xran[1] - xran[0]) ge 5. / 24. then xtickinterval = 60


; Logged frequency scale?

if logfreq eq 'Y' then begin
	yran = [maxfreq * 0.001, maxfreq] 
	flog = 1
	ymain = 3
	posn = [0.11, 0.17, 0.87, 0.93]
endif else begin
	yran = [minfreq, maxfreq]
	flog = 0
	ymain = 4
	posn = [0.08, 0.17, 0.87, 0.93]
endelse

if autopow eq 'N' then minz = float(minz) & maxz = float(maxz)

; Logged power scale?
if logpow eq 'Y' then begin
	powerspec = 10. * alog10(powerspec)	; 10, not 20 as we already have 'power'
; 	if comp eq 'E' then zran = [2.*mean(powerspec), max(powerspec)]  ;was 1.6 * mean
; 	if comp eq 'E' and autopow eq 'Y' then zran = [-100, 30] else zran = [minz, maxz]

	if comp eq 'E' then if autopow eq 'Y' then $
	zran = [2. * mean(powerspec), 0.] else zran = [minz, maxz]

	if comp eq 'B' then if autopow eq 'Y' then $
	zran = [1.5 * mean(powerspec), max(powerspec)] else zran = [minz, maxz]
	
	cbartit = 'Absolute Power [dB]'	

	; sort out contour levels
	levels = 25.
	step = (zran[1] - zran[0]) / levels
	userLevels = IndGen(levels) * step + zran[0]

endif else begin
; nT^2 / Hz with log color scale and levels.
	if autopow eq 'Y' then zran = [1.E-6, 1.] else zran = [minz, maxz]
	if comp eq 'B' then cbartit = 'Power [nT!U2!N/Hz]'
	if comp eq 'E' then cbartit = 'Power [mV!U2!N/m!U2!N/Hz]'
	userLevels = loglevels(zran, /fine)

endelse

print, 'Zrange is', zran


; ; time for .eps filename
; tlab = strmid(strtrim(string((xran + 0.5) * 24.), 2), 0, 5)


set_plot, dev


ctab = 33.

loadct, ctab, /silent

if dev eq 'ps' then begin
;     plotfile = plotpath + orb_select + '_' + comp + '_' + tlab[0] + '_' + tlab[1] + '.eps'
    device, filename = plotfile, ysize = 4.2, xsize = 7, /inches
    device, color = 1, bits = 8, /encapsulated
	!x.thick = 3
	!y.thick = 3
	!p.charthick = 2
	!p.color = FSC_color('black')
	!p.charsize = 1

endif else begin    ; plot to screen
    device, decomposed = 0
;     Window, Title=title, XSize=600, YSize=400, wndw_idx
    Window, Title=title, XSize=700, YSize=420, wndw_idx
	!p.color = FSC_color('white')
	!p.charthick = 1
	!x.thick = 1
	!y.thick = 1
	!p.charsize = 1
endelse

; revert to correct background color in .eps plot (not white!)


if logfreq eq 'Y' then begin
	polyfill, [0.11, 0.11, 0.87, 0.87, 0.11], [0.17, 0.93, 0.93, 0.17, 0.17], /normal, $
	color = 0
endif else begin
	polyfill, [0.08, 0.08, 0.87, 0.87, 0.08], [0.17, 0.93, 0.93, 0.17, 0.17], /normal, $
	color = 0
endelse

Contour, powerspec, UT_telem_int, y, position=posn, $
   Levels=userLevels, yrange = yran, xminor = 6, yticks = ymain, $
   zrange = zran, ystyle = 1,  xstyle = 1, xtick_get = xvalsF, $
ytitle = 'Frequency [Hz]', /noerase, yminor = 10, ylog = flog, $
 /fill, xtickunits='minutes', xtickformat='label_date', xrange = xran, $
	xtickinterval = xtickinterval, title = title, background = 0;, max_value = zran[1]


; need to get MLT, MLAT and L at UT = xvalsF times
; there will be 'xmajor' # of ticks (should eq n_elements(xvalsF) - 1)

; mltint = mltint / 24. - 0.5
xmajor = n_elements(xvalsF) - 1

position = strarr(xmajor + 1)
UTax = strarr(xmajor + 1)
MLTax = strarr(xmajor + 1)
MLATax = strarr(xmajor + 1)
Lax = strarr(xmajor + 1)


minutes = fltarr(xmajor + 1)


for ff = 0, xmajor do position[ff] = max(where(UT_telem_int le xvalsF[ff]))

; catch rounding errors
if position[0] eq -1 then position[0] = 0
if position[n_elements(position) - 1] eq -1 then position[n_elements(position) - 1] = $
	n_elements(position) - 1


for tt = 0, xmajor do begin

    minutes[tt] = (mltint[position[tt]] - floor(mltint[position[tt]])) / 1. * 60.

if round(minutes[tt]) eq 60. then minutes[tt] = minutes[tt] - 1.	; damn timing

if minutes[tt] lt 10 then MLTax[tt] = strtrim(string(floor(mltint[position[tt]])), 2) + ':0' + $
        strtrim(string(round(minutes[tt])), 2) $
        else $
    MLTax[tt] = strtrim(string(floor(mltint[position[tt]])), 2) + ':' + $
        strtrim(string(floor(minutes[tt])), 2)
; changed strtrim(string(round(minutes[tt])), 2) 	
; to floor, was getting eg: orb 991, 16:15 - 16:45 UT, MLT=17:60

endfor


for tt = 0, xmajor do Lax[tt] = string(lint[position[tt]], format = '(f4.2)')
for tt = 0, xmajor do MLATax[tt] = string(mlatint[position[tt]], format = '(f6.2)')

axis,  0, 0.14, xaxis = 0, /normal, xticks = xmajor, xstyle = 1 , xtickv = xvalsF, $
 xtickname = MLTax, xticklayout = 1


axis,  0, 0.11, xaxis = 0, /normal, xticks = xmajor, xstyle = 1 , xtickv = xvalsF, $
 xtickname = MLATax, xticklayout = 1

axis,  0, 0.08, xaxis = 0, /normal, xticks = xmajor, xstyle = 1 , xtickv = xvalsF, $
xtickname = Lax, xticklayout = 1


xyouts, 0, 0.119, 'UT', /normal
xyouts, 0, 0.089, 'MLT', /normal
xyouts, 0, 0.059, 'MLAT', /normal
xyouts, 0, 0.029, 'L', /normal


plot, timeB,  omegaH, color = FSC_color('white'), position = posn, $
    xstyle = 5, ystyle = 5, /noerase, yrange = yran, ylog = flog, $
	 xrange = [timeB[0],timeB[n_elements(timeB) - 1]], thick = 1.2

plot, timeB,  omegaH / 4., color = FSC_color('white'), position = posn, $
    xstyle = 5, ystyle = 5, /noerase, yrange = yran, ylog = flog, $ 
	xrange = [timeB[0], timeB[n_elements(timeB) - 1]], thick = 1.2

plot, timeB,  omegaH / 16., color = FSC_color('white'), position = posn, $
    xstyle = 5, ystyle = 5, /noerase, yrange = yran, ylog = flog, $
	xrange = [timeB[0], timeB[n_elements(timeB) - 1]], thick = 1.2


loadct, ctab, /silent

!x.minor = 0

if dev eq 'x' or dev eq 'win' then cbarcol = 'white' else cbarcol = 'black'

if logpow eq 'Y' then begin
	; dB with linear colorbar
	colorbar, title = cbartit, range=zran, vertical = 1, $
	position = [0.88, 0.17, 0.90, 0.93], right = 1, ncolors = 256, $
	divisions = 5., annotatecolor = cbarcol
endif else begin
	; logged levels
	colorbar, title = cbartit, range=zran, vertical = 1, $
	position = [0.88, 0.17, 0.90, 0.93], right = 1, ncolors = 256, $
	divisions = 5., annotatecolor = cbarcol, yticks = 0, /ylog, $
	ticknames = ['10!E-6!N', '10!E-5!N', '10!E-4!N', '10!E-3!N', $
	'10!E-2!N', '10!E-1!N', '10!E0!N']
endelse

if dev eq 'ps' then device, /close

print, 'Plot done'

end
