pro prep_CRRES_part

restore, '../Data/CRRES_Data/crres.save', /ver

 

;Here we are getting rid of the data points where there is bad yrday inputs

yrindex = where(yrday gt 90000.) 
ayrday = yrday(yrindex)
astrtime = strtime(yrindex)
aFCE = FCE(yrindex)
aFUHR = FUHR(yrindex)
aFPE = FPE(yrindex)
aden = den(yrindex)


;Here we are getting rid of the bad points for density. We know that
;there shouldn't be any points below zero. We also know that there
;shouldn't be anything too much higher then 2000, so we'll set the
;limit at 5000, the bad data numbers are much higher. 

denindex = where((aden gt 0) and (aden lt 5000))
byrday = ayrday(denindex)
bstrtime = astrtime(denindex)
bFCE = aFCE(denindex)
bFUHR = aFUHR(denindex)
bFPE = aFPE(denindex)
bden = aden(denindex)

;now we are getting rid of the bad points for the FCE's These
;should also not have anything above 2000, so we'll go with
;5000 as the bad data index. The bad data numbers are much higher

ceindex = where(bFCE lt 5000)
cyrday = byrday(ceindex)
cstrtime = bstrtime(ceindex)
cFCE = bFCE(ceindex)
cFUHR = bFUHR(ceindex)
cFPE = bFPE(ceindex)
cden = bden(ceindex)


;now we are getting rid of the bad data points for the FUHRs, same
;logic as for the FCEs

hrindex = where(cFUHR lt 5000)
dyrday = cyrday(hrindex)
dstrtime = cstrtime(hrindex)
dFCE = cFCE(hrindex)
dFUHR = cFUHR(hrindex)
dFPE = cFPE(hrindex)
dden = cden(hrindex)

;finally for the FPEs, and once again same as for FCEs

peindex = where(dFPE lt 5000)
eyrday = dyrday(peindex)
estrtime = dstrtime(peindex)
eFCE = dFCE(peindex)
eFUHR = dFUHR(peindex)
eFPE = dFPE(peindex)
eden = dden(peindex)

;this would work if we were looking at the bad data, but since we have
;the good data points, then nope.
;tempindex = [peindex, hrindex, ceindex, denindex, yrindex]
;index = uniq(tempindex, sort(tempindex))

;here we are making the hr min and sec arrays. 
ehr = fix(strmid(estrtime, 0,2))
emm = fix(strmid(estrtime, 3,2))
ess = fix(strmid(estrtime, 6,2))

;here we figure out which bits are in 1990 and which bits are in 1991
index90 = where(eyrday lt 91000) 
index91 = where(eyrday gt 91000)

;Here we make the arrays for the year for 1990 and 1991
year90 = make_array(N_elements(index90), value = 1990)
year91 = make_array(N_elements(index91), value = 1991)

;here we are making the doy arrays
edoy90 = eyrday(index90) - 90000
edoy91 = eyrday(index91) - 91000

;now lets find the frac. of min from start of year for all of these
;points.
eyrmin90 = (edoy90*24.*60.) + (ehr(index90)*60.) + emm(index90) + (ess(index90)/60.)
eyrmin91 = (edoy91*24.*60.) + (ehr(index91)*60.) + emm(index91) + (ess(index91)/60.)

;now lets divide up all the other variables into 1990 and 1991

eFCE90 = eFCE(index90)
eFUHR90 = eFUHR(index90)
eFPE90 = eFPE(index90)
eden90 = eden(index90)

eFCE91 = eFCE(index91)
eFUHR91 = eFUHR(index91)
eFPE91 = eFPE(index91)
eden91 = eden(index91)

;now we have gotten to the bit where we need to decide how to make
;this into min. data. Why min data? becuase that is easier to deal
;with, that's what everything else seems to be in... I don't
;know, it's just what I want and there is no one here to ask at
;the moment for a reason as to why not. So there are two ways I could
;try to do this. The first (and easiest), would be to interpolate the
;data, the second, is to average it into min data. I'm going to
;do the first because it is the easiest and again there is no one here
;to tell me why not at the moment. This, I'm guessing will have
;to be changed. this could be bad if my events are near large gaps in
;the data, but I don't believe that they are, so I'm hoping
;that I'm okay with this. This does seem to miss some big
;jumps, but those jumps seem to be on second timescales, and last for
;only one data point. I'm not sure what to make of this.

;INTERPOLATING THE DATA TO MIN. RESOLUTION*************************
;first we need to find the starting data point. 

startdata = round(eyrmin90(0)) ; this is in min. from the start of the year

;now we need to get the correct array so number of mins. in a year -
;the starting data point would give us how many points are left. and
;the offset would be the starting data point.

e90mins = findgen((365.*24.*60.) - startdata) + startdata

;for 1991 it's easier, it's just the last data point in eyrmin91
;(rounded)

enddata = round(eyrmin91(N_elements(eyrmin91)-1)) ; this is in min.

e91mins = findgen(enddata)

;now we can interpolate the rest of the data on to these grids. For
;the 1990 data  we have our original time array (or x in the idl help
;files) is eyrmin90, the original data (or V in the idl help files
;would be like eden90, and the new (or U in the idl help files) is
;e90mins.

;stop
FCE90 = interpol(efce90, eyrmin90, e90mins)
FUHR90 = interpol(efuhr90, eyrmin90, e90mins)
FPE90 = interpol(efpe90, eyrmin90, e90mins)
den90 = interpol(eden90, eyrmin90, e90mins)

FCE91 = interpol(efce91, eyrmin91, e91mins)
FUHR91 = interpol(efuhr91, eyrmin91, e91mins)
FPE91 = interpol(efPe91, eyrmin91, e91mins)
den91 = interpol(eden91, eyrmin91, e91mins)

;here, to make it easy to deal with the other data I will be working
;with, and has the format of arrays for each year with 1 min
;resolution, I'm going to make these also have that same format
restof90 =  Make_array(((365.*24.*60.) - n_elements(e90mins)) , value = !values.F_NAN)
restof91 =  Make_array(((365.*24.*60.) - enddata)+enddata , value = !values.F_NAN)

help, restof90
help, restof91

FCE90 = [restof90, fce90]
FUHR90 = [restof90, fuhr90]
FPE90 = [restof90, fpe90]
den90 = [restof90, den90]

FCE91 = [fce91, restof91]
FUHR91 = [fuhr91, restof91]
FPE91 = [fpe91, restof91]
den91 = [den91, restof91]

help, emins90
help, emins91

help, den90
help, den91 


save, fce90, fuhr90, fpe90, den90, e90mins,  fce91, fuhr91, fpe91, den91, e91mins, filename = '../Data/CRRES_data/CRRES_particle.save'

stop


end
