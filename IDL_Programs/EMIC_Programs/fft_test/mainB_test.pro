;TITLE:mainB_test.pro
;AUTHOR:Paul Manusiu
;DATE:04/10/00
;PURPOSE:Test interpolation to remove varionational field
;from main B field.
;INPUT - test signal random noise plus main field
;in nanoTelsa.
;CALCULATION - Use IDL SMOOTH function.
;OUTPUT - B main without dB components.
;MODIFICATIONS: 04/10/00
;				Originally used POLY function with polynomial fit
;				09/10/00
;				Found that SMOOTH function worked better
;				slowly varying. Added option to change the
;				cuttoff for SMOOTH. Wish to retain Pc5 character
;				in main B field.
;
FUNCTION Alpha,B_x,B_y,B_z
    if(B_x EQ 0.0) then alph = 3.14159265359/2.0 else $
      begin
        alph = Atan(sqrt(B_y*B_y+B_z*B_z)/abs(B_x))
    endelse
    return,alph
END
;
FUNCTION E_x,E_y,E_z,B_x,B_y,B_z
    Exx = -(E_y*B_y + E_z*B_z)/B_x
  return,Exx
END

FUNCTION Poyntz,E_x,E_y,E_z,B_x,B_y,B_z
 piI = 3.1415926535898
 u = 4*PiI*1E-7
    S_z = (1.0/u)*(E_x*B_y - B_x*E_y)
 return,S_z
END

FUNCTION Poyntx,E_x,E_y,E_z,B_x,B_y,B_z
 piI = 3.1415926535898
 u = 4*PiI*1E-7
    S_x = (1.0/u)*(E_y*B_z - B_y*E_z)
 return,S_x
END

FUNCTION Poynty,E_x,E_y,E_z,B_x,B_y,B_z
 piI = 3.1415926535898
 u = 4*PiI*1E-7
     S_y = (1.0/u)*(E_z*B_x - B_z*E_x)
 return,S_y
END
;
Function Tim,mSec
 milsec=mSec Mod 1000
 seci=fix(Long(mSec)/1000)
 secf = seci mod 60
 mni=fix(Long(seci)/60)
 mnf = mni mod 60
 hr = fix(Long(mni)/60)
 Return,String(hr,mnf,secf,milsec,$
  Format="(I2.2,':',I2.2,':',i2.2,'.',i3.3)")
end
;
Function XTLab,Axis,Index,Value
 mSec=long(Value)
 milsec=long(mSec) Mod 1000
 seci=Long(mSec/1000)
 secf = long(seci) mod 60
 mni=Long(seci)/60
 mnf = long(mni) mod 60
 hr = Long(mni/60)
 Return,String(hr,mnf,secf,milsec,$
  Format="(I2.2,':',I2.2,':',i2.2,'.',i3.3)")
end
;
Pro mainB_test
pi= 3.14159265359
ct=10000
index=INDGEN(8)
Bx = fltarr(ct)
data = fltarr(ct)
data2 = fltarr(101)
data3 = fltarr(ct)
tims=lonarr(ct)
tims2=lonarr(101)
cts=long(0)
cnt=long(0)
cc=randomn(seed,ct)
for i=long(0),ct-1 do $
    begin
    tims[i] = long(10000000) + long(32)*i
	data[i]=sin(0.003*i)
	data3[i]=100.0+i*0.001+data[i]+cc[i]
    if data[i] GE 0.999999 then $
	begin
	print,data[i]
	data2[cnt]=data[i]
	tims2[cnt]=tims[i]
	cnt=cnt+long(1)

	endif
endfor
print,1/[(tims2[1]-tims2[0])/1000.]
ran=randomn(5,ct)
Bx=ran*data
By=data
Bz=0.0*data
Ey=data
Ez=0.0*data
Bxx=data3
Byy=data3
Bzz=data3
rt=findgen(ct)
;****************************************************************************
;Run moving average to calculate B field main.
freq_32=1000.0/(tims[1]-tims[0])
print,freq_32
sam=freq_32
print,'Running smoothing function over B+dB to remove dB'
print,'Please enter cuttoff frequency (mHz):'
read,opt
cuts=opt/(sam/1000.)
print,format='(A32,I0,A3)','The cuttoff you have entered is ',opt,'mHz'
BX1MAIN = smooth(Bxx,cuts,/EDGE_TRUNCATE)
;****************************************************************************
;
!P.MULTI = [0, 1,2]
set_plot,'WIN'
window,3,xsize=500,ysize=500,title='Main B fields only'
plot,tims,Bxx,yrange=[min(Bxx),max(Bxx)],XStyle=1,Xticks =3,$
XTickFormat='XTLab',xtitle ='Time (UT)',ytitle='Bx+dBx (nT)'
plot,tims,BX1MAIN,yrange=[min(BX1MAIN),max(BX1MAIN)],$
XStyle=1,Xticks =3,XTickFormat='XTLab',$
xtitle ='Time (UT)',ytitle='Bx(nT)'
end
