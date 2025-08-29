Pro INVSPLINE,n,t,tt,aa
;DATE: 14/09/00
;AUTHOR: Paul Manusiu
;APPLICATION: Inverse spline filter
;PARAMETERS:
;			n= No. of points in series
;			t= original abssica values
;			tt= new abssica values
;			aa= ordinates
;
dumm =fltarr(n)
Reverse,aa,dumm,n
aa = SPLINE(t,aa, tt)
dumm =fltarr(n)
Reverse,aa,dumm,n

end