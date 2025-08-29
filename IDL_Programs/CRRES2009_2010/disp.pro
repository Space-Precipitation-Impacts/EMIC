function disp, coldden, warmden, Tperp, Tpar, A, npts, bo
;this program creates the plot seen in Fraser et al 1989, kozyra et
;al 1984 and Gomberoff and Neira 1983 using the table for values in
;Fraser et al 1989 given as the following 
; partiles    H+            He+   O+
;cold cm ^-3  196           22    2
;warm cm^-3   5.1           0.05  0.13
;T_{v,l} kev  30            10    10
;A_{l}        075, 1, 1.5   1     1
;This version solves for S using the simplfied fraction given in
;Koyzra. 

;  A = [1.5,1.,1.]
;  tperpj =  [30.0d, 10.0d, 10.0d]*10.^3.*1.6d*10.^(-19.) ;here we first convert to joules
;  Tperp = [30.0d, 10.0d, 10.0d]*10.^3.     ;the array is in keV, I've kept it in keV because Tperp isn't 
                                ;used anywhere else in the program,
                                ;and since we tend to measure things
                                ;in keV it seemed easiest to keep it
                                ;in those units.
;  Tpar = (Tperp/(A + 1.0d))*1.6d*10.^(-19.) ; the array is still in keV then converted to Joules
;  tparj =  (Tperpj/(A + 1.0d))              ;this is where we use the tperp which was first converted to joules and then found Tpar.   



  npts = 1000
  s = make_array(npts)


                                ;the densities of particles
  denc = [.9,.09,.01]*100.^3.*Coldden    ;[100.0d, 20.0d, 8.0d ]*100.^3. ; in units of m^-3
  denw = [.94,.002,.058]*100.^3.*warmden ;[5.250d, 0.01d, 0.030d]*100.^3. ; in units of m^-3
                                ;speed of light 
                                ;c = double(2.9979*10^8.) *10^2. ;cm/s 
  c = double(2.9979*10^8.)      ;m/s
  
  
                                ;mass of particles
                                ;me = 9.1d*10^(-31.)*10^3. ;g this is the mass of the electron
  me = 9.1d*10^(-31.)           ;Kg this is the mass of the electron
                                ;mp = 1836.0d*9.1d*10^(-31.)*10^3. ;g this is the mass of the proton
  mp = 1836.0d*9.1d*10^(-31.)   ;Kg this is the mass of the proton
  
                                ;equatorial magnetic field 
                                ;bo = 300.d * 10^(-9.) * 10^(4.) ;gauss
;  bo = 300.d * 10^(-9.)         ;0.35d * 10^(-4.) ;tesla
  
                                ;charge
                                ;q = 1.61d*10^(-19.)*3.d*10^9. ;statcolumbs
  q = 1.61d*10^(-19.)           ;columbs
  
                                ;permittivity of free space
                                ;epso = 1. ;
  epso = 8.8542d*10^(-12.)      ;F/m
  
                                ;permeability of free space
                                ;epso = 1. ;
  muo = 4.d*!pi*10^(-7.)        ;F/m

                                ;Boltzmann constant
                                ;kb = 1.3807d*10^(-16.) ;erg/k
  kb = 1.3807d*10^(-23.)        ;j/K
  
                                ;proton cyclotron frequency 
  omegap = q*bo/(mp)
  omegaf = q*bo/(2.d*!pi*mp)
;  help, bo
;  print,omegaf
                                ;proton plasma frequency warm and then cold
                                ;wppw = (denc(0)*q^2./(mp))^.5   ;C^2/(m^2*kg*F)
  wppw = (denw(0)*q^2./(mp*epso))^.5 ;C^2/(m^2*kg*F)
                                ;wppc = (denw(0)*q^2./(mp))^.5    ;C^2/(m^2*kg*F)
  wppc = (denc(0)*q^2./(mp*epso))^.5 ;C^2/(m^2*kg*F)


                                ;delta (ratio of the cold to warm proton plasma frequencies. )
  delta2 = wppc^2./wppw^2.       ;unitless def. from Kozyra et al 1984.
  delta = denc(0)/denw(0)       ;this is what Steve says, but what I had reduces to that.
  ;print, 'delta used = ', delta ; they give you the same thing. 
  ;print, 'my delta = ', delta2



                                ;the atomic mass of the particles
  mj = [1.0d, 4.0d, 16.0d]      ;in atomic mass units
  
                                  ;particle plasma frequency 
                                ;wpw = (denc*q^2./(mj*mp))^.5  ;C^2/(m^2*kg*F)
  wpw = (denw*q^2./(mj*mp*epso))^.5 ;C^2/(m^2*kg*F)
                                ;wpc = (denw*q^2./(mj*mp))^.5 ;C^2/(m^2*kg*F)
  wpc = (denc*q^2./(mj*mp*epso))^.5 ;C^2/(m^2*kg*F)


;  A = (Tperp/Tpar) -1.d   
  alpha = (2.0d*Tpar/(mj*mp))^.5 ;I removed the boltzman constant 
   
 
                                ;normalized mass density ratio of the ion mass to the mass of the
                                ;proton over the atomic number. The second array (all ones) is the z
                                ;varible which is the ion charge. In this case we are assuming that it
                                ;is always 1.
  m = mj
                                ;The ratio of the real part of the complex dispersion relation
                                ;to the proton cyclotron frequency. This is a normalized thing so as
                                ;that goes from about 0 - 1 so that's what I'm going to try for now.
  x = dindgen(npts)/npts + .00001 ;this should be unitless. The + .00001 is to get rid of 
                                ;the problem of when x = .5
                                ;when I had x = findgen(50)/50.d then I got something closer to what
                                ;the paper had. 


                                ;normalized ratio of warm to cold plasma frequencies*********** IS
                                ;In Kozyra et al 1984 it's the
                                ;ratio of the warm or cold plasma
                                ;frequency to the warm proton plasma
                                ;frequency times what ever M is.  **********
;  nuw = (M)*(wpw/wppw)^2.         ;unitless; this is from Kozyra et al 1984
;  nuc = (M)*(wpc/wppw)^2.         ;unitless; this is from Kozyra et al 1984
  nuc = (denc/denw(0)) ; * (M/mj)         ;reduces to the above
  nuw = (denw/denw(0)) ;*(M/mj)           ;reduces to the above

                                ;beta = (8.d*!pi*nuw*kb*Tpar)/Bo ;this
                                ;might need to be multiplied by 1.6.d*10^(-19.) to convert to jules
  beta = (denw*Tpar)/(Bo^2./(2.d*muo)) ;this might need to be multiplied by 1.6.d*10^(-19.) to convert to jules


                                ;these are the bits that form the group velocity and mu which is the
                                ;ratio of the dispersion relation to the proton cyclotron
                                ;frequency. This is done just because it's easier then writting
                                ;the same thing over and over again. 
  expon = make_array(n_elements(m), n_elements(x))
  expnum = expon
  expdenom = make_array(n_elements(x))
  sum1 = expdenom
  sum2 = expdenom
  sum3 = expdenom
  insum1 = expon
  insum2 = expon
  insum3 = expon
  frac1 = expon
                                ;frac4 = expon
  brack1 = expon
                                ;brack2 = expon


                                ;here we find the inside of the sum in the exponent in S
  for i = 0l, (n_elements(m)-1) do insum2(i,*) = ((nuw(i) + nuc(i)) * M(i)) / (1.0d - M(i) * x) 
                                ;here we sum the sum in the exponent
                                ;in S which is for only the heavy ions
                                ;Helium and oxygen which in this case
                                ;are in spots array([Hydrogen, helium, oxygen])
  for ii = 0l, n_elements(x) -1 do sum2(ii) = insum2(1,ii)+insum2(2,ii)
                                ;here we find the denominator in the exponent (it has the same array
                                ;demensions as x)
                                ;expdenom = ((1.d+delta)/(1.d - x))+sum2
  expdenom = ((1.d + delta)/(1.d - x)) + sum2
                                ;here we find the numerator in the exponent, and then find the
                                ;exponent for that array value of M, then we also find the array
                                ;values of M in the first part of the first sum in S
  for j = 0l, n_elements(m)-1 do begin 
     expnum(j,*) = (-1.d*nuw(j)/m(j))*((M(j)*x-1.d)^2./(beta(j)*X^2.))   
     expon(j,*) = expnum(j,*)/expdenom
                                ;   frac1(j,*) = ((nuw(j)*sqrt(!pi))/(m(j)^2.*alpha(j)))*((A(j) + 1.d)*(1.d-M(j)*X)-1.d)
     frac1(j,*) = ((nuw(j)*sqrt(!pi))/(m(j)^2.*alpha(j)))*((A(j) + 1.0)*(1.0-m(j)*x)-1.0)
  endfor

                                ;here we find the entire inside of that first sum in S
  for jj = 0l, n_elements(m)-1 do insum1(jj,*) = frac1(jj,*)*exp(expon(jj,*))
                                ;here we go through and sum that first sum at every x point.
  for jjj = 0l, n_elements(x)-1 do sum1(jjj) = total(insum1(*,jjj))

                                ;now on to the second squiggly brackets in S
                                ;for ij = 0l, n_elements(m)-1 do insum3(ij,*) = (nuw(ij)+nuc(ij))*(m(ij)/(1.d-m(ij)*x))
  for ij = 0l, n_elements(m) -1 do insum3(ij,*) = (nuw(ij)+nuc(ij))*(m(ij)/(1.0 - m(ij)*x))
                                ;Again this sum is only done over the
                                ;heavy ions just as in the sum in the
                                ;exponent. 
  for iij = 0l, n_elements(x)-1 do sum3(iij) = insum3(1,iij) + insum3(2,iij)
  frac3 = (1.d + delta)/(1.d - x)
  brack2 = ((2.d*x^2.)*(frac3 + sum3))




                                ;now finally we can calculate S
  S = sum1/brack2

;  set_plot, 'x'
;  !P.Multi = [0,1,1]
;     plot, x*omegaf,s*10^9., xrange = [0,3], yrange = [0,100], psym = 2, $
;                          xtitle = 'normalized frequency', ytitle = 'growth rate *10^9', symsize = .5  

return, s
end
