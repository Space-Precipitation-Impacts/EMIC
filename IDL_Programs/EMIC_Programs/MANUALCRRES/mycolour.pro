; colour code
; by me
Pro mycolour
 Set_Plot,'WIN'
 Device,decomposed=0
 r=intarr(256)
 g=r
 b=r
 loadct,4
 tvlct,r,g,b,/get
 r1=r
 g1=g
 b1=b
 ;For ii=0,127 do $
 ;begin
 ; r1(ii)=r(ii+127)
 ; g1(ii)=g(ii+127)
 ; b1(ii)=b(ii+127)
 ;end
 ;For ii=128,255 do $
 ;begin
 ; r1(ii)=r(ii-128)
 ; g1(ii)=g(ii-128)
 ; b1(ii)=b(ii-128)
 ;end
 tvlct,r1,g1,b1
 Z = FLTARR(200, 200)
 ;Z = EXP(-(Z/10)^2)
 disp=randomn(seed,200)

 fft_disp=fft(disp,1)
 x=findgen(1000)
for i=0,199 do $
 Z[*,i]=fft_disp[i]
for i=0,199 do $
 Z[i,*]=x[i]

;plot_3dbox,x,y,fft_disp,/solid_walls
shade_surf,z;FFT_DISP
;surface,fft_disp,x;/T3D
 ;window,2
 ;tv,dd
end