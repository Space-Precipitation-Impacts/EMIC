pro meep

theta = findgen(1000)/1000. *2.*!pi
phi = findgen(1000)/1000. *2.*!pi

for i = 0, n_elements(theta)-1 do begin


n1 = cos(.5*!pi*cos(theta(i)))
dem1 = sin(theta(i))
n2 = sin(6.*!pi*cos(phi))
dem2 = sin(.5*!pi*cos(phi))

f = (1./12.)*(n1*n2/(dem1*dem2))

plot, f
endfor


end 
