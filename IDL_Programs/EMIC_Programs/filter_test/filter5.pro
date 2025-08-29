pro filter5

a=0.2116457
b=0.4232914
c=0.2116457
d=0.3462655
e=-0.1928483
minomega=0.0
maxomega=8.0
omega=minomega
no_pt=100
delomega=(maxomega-minomega)/float(no_pt)
res=complexarr(no_pt)
xax=dblarr(no_pt)
for i=0,no_pt-1 do $
begin
z= complex(cos(omega),sin(omega))
res[i] = (a+b*z+c*z^2)/(1.0-d*z-e*z^2)
xax[i]=omega/(2.*!pi)
omega=omega+delomega
endfor
;y[j] = a*x[j]+b*x[j-1]+c*x[j-2]+d*y[j-1]+e*y[j-2]
set_plot,'win'
window,0, xsize=400,ysize=350
plot,xax,abs(res)
window,1, xsize=400,ysize=350
plot,xax,atan(imaginary(res),double(res))
end