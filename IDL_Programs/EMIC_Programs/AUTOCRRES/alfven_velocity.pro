Function XXTLab,Value			;Function to format x axis into hours:minutes:seconds.frac
 mSec=long(Value)
 milsec=long(mSec) Mod 1000
 seci=Long(mSec/1000)
 secf = long(seci) mod 60
 mni=Long(seci)/60
 mnf = long(mni) mod 60
 hr = Long(mni/60)
 Return,String(hr,mnf,secf,$
  Format="(I2.2,':',I2.2,':',I2.2)")
end

Function XXTLab3,Axis,Index,Value			;Function to format x axis into hours:minutes:seconds.frac
 mSec=long(Value)
 milsec=long(mSec) Mod 1000
 seci=Long(mSec/1000)
 secf = long(seci) mod 60
 mni=Long(seci)/60
 mnf = long(mni) mod 60
 hr = Long(mni/60)
 Return,String(hr,mnf,secf,$
  Format="(I2.2,':',I2.2,':',I2.2)")
end

Function XXTLab2,Value			;Function to format x axis into hours:minutes:seconds.frac
 hr=long(strmid(Value,0,2))
 mnf=long(strmid(Value,3,2))
 secf=long(strmid(Value,6,2))
 hr=hr*3600.
 mnf=mnf*60.
 Return,long((hr+mnf+secf)*1000.)
end

;Pro alfven_velocity,cm_eph,cm_val,state,Dat5
Pro alfven_velocity,cm_eph,cm_val,state,group,Dat5
common dens,val_inter_dens
COMMON DENS_ALF_PHA, alf_vel,phase_vel
common orbinfo,orb,orb_binfile,orb_date
PI=3.14159265359
constu=6.32455532034
u = 4*PI

widget_control,group.cuttoff,get_value=cut
widget_control,group.cuttoff1,get_value=cut1
widget_control,group.cuttoff2,get_value=cut2
widget_control,group.cuttoff3,get_value=cut3

cut=float(cut[0])
cut1=float(cut1[0])
cut2=float(cut2[0])
cut3=float(cut3[0])
print,cut
print,cut1
print,cut2
print,cut3
;stop
;Print,'hello'
path='C:\paul\Phd\crres\orbit1043\'
orb='1043'
if orb NE '1043' then $
Result = DIALOG_MESSAGE('Alfven Velocity Currently only implemented for Orbit 1043') $
else $
begin

count=0L
cd,strmid(path,0,strlen(path)-strlen(orb)-6)+'density\'
Openr,uden,'Orb1043a.den',/get_lun
text=''
readf,uden,text
readf,uden,text
While not eof(uden) do $
Begin
 ReadF,uden,text
;stop
count=count+1
endwhile
Point_Lun,uden,0
;stop
readf,uden,text
readf,uden,text
elden=fltarr(count-1)
eltim=strarr(count-1)
for i=0,count-2 do $
begin
 ReadF,uden,text
; stop
 eltim[i] = strmid(text(0),15,8)
 elden[i] = float(strmid(text(0),55,8))
 end
free_lun,uden
cd,strmid(path,0,strlen(path)-strlen(orb)-6)
;plot,elden
;*************************************************************
;
timstr1=XXTlab(cm_val.(0)[0])
timstr2=XXTlab(cm_val.(0)[n_elements(cm_val.(0))-1])


eltimlon=lonarr(n_elements(eltim))
;*************************************************************
for i=0,n_elements(eltim)-1 do $
if fix(strmid(eltim(i),0,2)) GE 0 and fix(strmid(eltim(i),0,2)) LT 10 then $
begin
		addtim='24:00:00'
		addtimlon=XXTLab2(addtim)
		eltimlon[i]=long(XXTLab2(eltim[i])+addtimlon)
end else $
eltimlon[i]=XXTLab2(eltim[i])
;stop
ttt=cm_val.(0)
UT=eltimlon
;
;
;*************************************************************
;**********************************************************************************
;Beginning of Ephermius interpolation routines
;Data in *val files >> data in *0ep files
;
;**********************************************************************************
;**********************************************************************************
;Search through *0ep and count i for which (val.time[0] <= eph.time <= val.time[max])
;
i=long(0)
for kk=0, n_elements(UT)-1 do $
  if (UT[kk] GE ttt[0]) AND (UT[kk] LE ttt[n_elements(ttt)-1]) then $
     begin
      i=i+1
  endif

new_dens=fltarr(i)
new_tims=lonarr(i)

i=long(0)
for kk=0, n_elements(UT)-1 do $
  if (UT[kk] GE ttt[0]) AND (UT[kk] LE ttt[n_elements(ttt)-1]) then $
     begin
      new_dens[i]=elden[kk]
      new_tims[i]=UT[kk]
      i=i+1
  endif
  print,'event begin time: ',timstr1
print,'event end time: ',timstr2
print,'density begin time: ',eltim[0]
print,'density end time: ',eltim[n_elements(eltim)-1]
print,'new begin time: ',XXTLab(new_tims[0])
print,'new end time: ',XXTLab(new_tims[i-1])
val_inter_dens=interpol(new_dens,new_tims,ttt)
;plot,eltimlon,elden,xstyle=1,title='Orbit Densities',yrange=[0,50],xtickformat='XXTLab3',$
;ytitle='Electron Densities (cm!U2!n)',xrange=[eltimlon[000],eltimlon[1200]],xtitle='UT'
!P.multi=[0,1,2]
window,0,xsize=500,ysize=500

plot,cm_val.(0),val_inter_dens,xstyle=5,xtickformat='XTLab',title='Densities',$
ytitle='Number Density (cm!U3!n)';,xtitle='UT'

;*************************************************************************
;Alfven velocity calc

hyd_mass=1.673*10.0^(-27)				;Hydrogen mass (kg)

denval=val_inter_dens*1000000.*hyd_mass	;Convert densities to (kg/metres^3)


alf_vel=(cm_val.(9)*10.^(-9))/((4.0*PI*0.0000001*denval)^(0.5)) ;Alfven Velocity (m/s)
;
;*************************************************************************
;Phase Velocity Calc
;Heavy ion ratios (H+:He+) = (0.75:0.25)
;
cycconst=0.0963542
freq_ev=cut3								;Set event freq to 1.5Hz
;stop
;e_ch=1.6*10.0^(-19)						;Electronic charge

;hyd_mass=1.673*10.0^(-27)					;Hydrogen mass

freq_hyd=[cycconst*cm_val.(9)]/(2.*PI)				;Hydrogen cyclotron frequency

vel_c=300000000.0							;Light speed (m/s)

Hel_Hyd_mass=4.00260

sum_hyd=[cut*denval/hyd_mass*vel_c^2.0]/[alf_vel^2.0*(1.0-freq_ev/freq_hyd)]
sum_hel=[cut1*denval/hyd_mass*vel_c^2.0]/[alf_vel^2.0*(1.0/(Hel_Hyd_mass-freq_ev/freq_hyd))]
;stop
phase_vel= vel_c/([1.+sum_hyd+sum_hel]^(0.5))
;stop

plot,cm_val.(0),phase_vel,xstyle=9,ytitle='Va & Vp (km/s)',xtickformat='XTLab',$
ymargin=[10.5,-4],yrange=[0,2000.],YSTYLE=1,xticks=3,title='Velocities';,XMARGIN=1.0

oplot,cm_val.(0),alf_vel/1000.;,xstyle=9,ytitle='Va (km/s)',xtickformat='XTLab',title='Alfven Velocity',$
ymargin=[10.5,-4];,xrange=[cm_val.(0)[0],max(cm_val.(0))],YSTYLE=1,xticks=3;,XMARGIN=1.0
;*************************************************************************
eph_inter_win,cm_eph,cm_val,state,Dat5
!P.multi=0
;stop
;*************************************************************************
endelse
end