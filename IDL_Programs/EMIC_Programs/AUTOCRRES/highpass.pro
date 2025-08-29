pro highpass, highgroup
common cm_crres,state,cm_eph,cm_val
common orbinfo,orb,orb_binfile,orb_date
common highchoice ,filtords,fieldch,cut

;********************************************************************************
;Run moving average to calculate B field main.
;
sam=freq_32
print,'Running smoothing function over B+dB to remove dB'

cuts=opt/(sam/1000.)
print,format='(A32,f9.6,A3)','The cuttoff you have entered is ',1./opt,'Hz'
BXMAINn = smooth(Bx,cuts,/EDGE_TRUNCATE)
BYMAINn = smooth(By,cuts,/EDGE_TRUNCATE)
BZMAINn = smooth(Bz,cuts,/EDGE_TRUNCATE)

;Removing edge effects
;
ww = count0 mod cuts
BXMAIN = BXMAINn[fix(ww/2.):count0-fix(ww/2.)-1]
BYMAIN = BYMAINn[fix(ww/2.):count0-fix(ww/2.)-1]
BZMAIN = BZMAINn[fix(ww/2.):count0-fix(ww/2.)-1]
dBx = dBx[fix(ww/2.):count0-fix(ww/2.)-1]
dBy = dBy[fix(ww/2.):count0-fix(ww/2.)-1]
dBz = dBz[fix(ww/2.):count0-fix(ww/2.)-1]
Ey = Ey[fix(ww/2.):count0-fix(ww/2.)-1]
Ez = Ez[fix(ww/2.):count0-fix(ww/2.)-1]
Etime = Etime[fix(ww/2.):count0-fix(ww/2.)-1]
count0 = n_elements(BXMAIN)
;
;
;*********************************************************************************
end