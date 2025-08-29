; Code to draw a colour bar
;
Pro cbar

 XSz=400
 YSz=350

  Set_Plot,'WIN'
  Device,decomposed=0
  window,0,XSize=XSz,YSize=YSz


 range=[-200,200.]
 LoadCT,17
 max_color=255
TVLCT,r,g,b,/get
FOR I=0,127 do $
begin
;b(127+i)=255-i/2
r(255-i)=128+i
;g(127+i*0.01)=255-i/2
end
;FOR I=41,80 do $
;begin
;g(i)=i/4
;r(255-i)=128+i
;r(i)=255-i
;end

;b(i)=220+i/50
;end
r(127)=255
g(127)=255
b(127)=255
r(128)=255
g(128)=255
b(128)=255

TVlct,r,g,b
;stretch,4,/chop
;     draw color scale
 s0=float(range(0))
 s1=float(range(1))
 rng=alog10(s1-s0)
 ;rng=s1-s0

 if rng lt 0. then pt=fix(alog10(s1-s0)-.5) else pt=fix(alog10(s1-s0)+.5)
 inc=10.^pt
 tst=[.05,.1,.2,.5,1.,2.,5.,10]
 ii=where((s1-s0)/(inc*tst) le 16)
 inc=inc*tst(ii(0))
 x1=50       ; Horiz position of bar
 y1=50       ; Vert position of bar
 ysize=200   ; Height of bar
;
 charsize=1
 max_color=254 ;!d.n_colors-1
 amin=min(range)
 amax=max(range)
 s0=float(amin)
 s1=float(amax)
 s0=fix(s0/inc)*inc     & if s0 lt amin then s0=s0+inc
 s1=fix(s1/inc)*inc     & if s1 gt amax then s1=s1-inc
;
 frmt='(e9.2)'
 nzs=fix(alog10(inc*1.01))
 if nzs lt 0 and nzs gt -4 then begin
  frmt='(f8.'+string(form='(i1)',-nzs+1)+')'  ; used on scale
 endif
 if nzs ge 0 and nzs le 3 then frmt='(f8.1)'
 mg=6
 smax=string(amax,form=frmt)
 smax=strcompress(smax,/remove_all)
 smin=string(amin,form=frmt)
 smin=strcompress(smin,/remove_all)
 lablen=strlen(smax) > strlen(smin)
 ;if !d.name eq 'X' then $
 ;begin
 ; dx=20                       ; width of color bar
 ; x2=x1+dx
 ; x3=x2+2
 ; mg=6                        ; black out margin
 ; dy=ysize                 ; height of color bar
 ; y2=y1+dy
 ; bw=dx+2*mg+charsize*lablen*!d.x_ch_size
 ; bh=dy+2*mg+charsize*!d.y_ch_size
  ;tv,replicate(0,bw,bh),x1-mg,y1-mg,/device   ;  black out background
  ;tv,bytscl(replicate(1,dx) # indgen(y2-y1),top=max_color),x1,y1,/device
 ;endif else $
; begin
  xs=!d.x_vsize/700.         ; about 100 pixels per inch on screen
  ys=!d.y_vsize/700.
  dx=42*xs                    ; width of color bar
  x2=x1+dx
  x3=x2+2*xs
  mg=6*xs                     ; black out margin
  dy=ysize                    ; height of color bar
  y2=y1+dy
;  bw=dx+2*mg+charsize*lablen*!d.x_ch_size
;  bh=dy+2*mg+charsize*!d.y_ch_size
;  tv,replicate(0,2,2),x1-mg,y1-mg,xsize=bw,ysize=bh   ;  black out background

 ;endelse
;

i=0L
 boxx=[x1,x2,x2,x1,x1]
 boxy=[y1,y1,y2,y2,y1]
 ;plots,boxx,boxy,/device
 denom=amax-amin
 nval=fix((s1-s0)/inc+.1)
 for ival=0,nval do begin
  val=s0+inc*float(ival)
  ss=(val-amin)/denom
 if ss ge 0 and ss le 1 then begin
    yval=y1+(y2-y1)*ss
    sval=string(val,form=frmt)
    sval=strcompress(sval,/remove_all)

     ;print,yval
	 ;print,i
	;if sval EQ '0.0' then $
    ;begin
    ;r(30*I)=255
    ;g(30*I)=255
    ;b(30*I)=255

    ;end
    i=i+1
    ;plots,[x1,x2],[yval,yval],/device
    xyouts,x3,yval,sval,/device,charsize=charsize
   ; stop

  endif
 endfor
  n1=Fix(dx)
  tv,bytscl(replicate(1,n1) # indgen(y2*1.0-y1),top=max_color), $
     x1,y1,xsize=17,ysize=dy  ;xsize=dx
 ;stop
;
 ;If PSPrint eq 1 Then $
 ;Begin
 ; Device,/Close
 ; Print,'Output File = ',PSName
 ;end
 !P.Multi=0
 Print,'Finished'
end
