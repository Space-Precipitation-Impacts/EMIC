pro read_basfiles
  
; Read in the CRRES spectrum files produced for BAS.
                                ;Here we are defining the folder the
                                ;data is in, the file that has the
                                ;names of the orbit files, and reading
                                ;in the filenames.
  datafolder = '../../../Volumes/MY_PASSPORT/Russells_data/data/crres/nigel_psd/'
  namefile = strcompress(datafolder + 'powerspecfilenames.txt', /remove_all)
  restore, '../Templates/nigel_psd_names_template.save'
  meep =  read_ascii(namefile, template = template)
                                ;filename = datafolder+'emic1043_8Hz.spc'		; the sample
  indiname = meep.powerspec_name
  spcfile = strarr(n_elements(indiname))
;  power = make_array(356.*24.*60., 800., value = !values.F_NAN)
  bo90 = make_array(365.*24.*60., value = !values.F_NAN) ;this is the background magnetic field
  dB90 = bo90                                            ;the peak wave amplitude
  pfreq90 = bo90                                         ;the peak frequency
  hfreq90 = bo90                                         ;The peak freq in the H band
  hefreq90 = bo90                                        ;the peak freq in the He band
  hout90  = bo90                                         ;the peak freq right before the H band
  heout90 = bo90                                         ;the peak freq right before the He band 
  hdb90 = bo90                                           ;The peak amp. in the H band
  hedb90 = bo90                                          ;The peak amp. in the He band
  houtdb90 = bo90                                        ;the peak amp. just preceding the H band
  heoutdb90 = bo90                                        ;the peak amp. just preceding the He band
  fp90 = bo90                                            ;the proton cyclotron frequency
  fhe90 = bo90                                           ;the helium cyclotron frequency
  fo90 = bo90                                            ;the oxygen cyclotron frequency
  intph90 = bo90                                          ;the integrated power in the H band
  intphe90 = bo90                                         ;the integrated power in the HE band
  bo91 = bo90
  dB91 = bo90
  pfreq91 = bo90
  hfreq91 = bo90
  hefreq91 = bo90
  hout91  = bo90                                         ;the peak freq right before the H band
  heout91 = bo90                                         ;the peak freq right before the He band 
  hdb91 = bo90                                           ;The peak amp. in the H band
  hedb91 = bo90                                          ;The peak amp. in the He band
  houtdb91 = bo90                                        ;the peak amp. just preceding the H band
  heoutdb91 = bo90                                        ;the peak amp. just preceding the He band
  fp91 = bo90
  fhe91 = bo90
  fo91 = bo90
  intph91 = bo90
  intphe91 = bo90
;  stop
                                ;here we are creating the full file names
;  for i = 0l, n_elements(indiname) -1 do 
                                ;filename = datafolder+'emic0827.spc'		; the sample file
                                ;eventtime = '*1991182 01:05*'
                                ;In this loop we are going through,
                                ;reading in the data and processing it
                                ;into min. stuff, so this loops
                                ;through each of the data files we
                                ;have for the power spectrums. 
  for i = 0l, n_elements(indiname) -1 do begin
     spcfile = strcompress(datafolder + indiname(i), /remove_all) 
     openr, datafile, spcfile, /get_lun
     scrap = ' '
     
     readf, datafile, scrap
     readf, datafile, scrap
     readf, datafile, xdim
     
     ydim = 800                 ; the vertical height of the spectrum (frequency)
     
                                ;Here we are creating the dummy
                                ;arrays. 
     powerspec = dblarr(xdim, ydim)
     fileLine = dblarr(5)
     timeList = strarr(xdim)
     backgroundField = dblarr(xdim)
     foo = 0d
     row = 0
                                ;Here we are reading in the data file.     
     while ~ eof(dataFile) do begin
        readf, datafile, scrap 
        timeList[row] = scrap
        readf, dataFile, foo 
        backgroundField[row] = foo
        for line = 0, 159 do begin 
                                ; 800 frequency points / 160 rows of data (5 points wide) in the file
                                ; Read the information into the columns of the data array.           
           readf, dataFile, fileLine           
           powerspec( row, line*5: line*5+4 ) = fileLine
        endfor                  ;This ends the reading in of the lines for the power spectrum 
                                ;at that specificic point in time.  
        row = row + 1        
     endwhile                   ;this ends the readind in of the file and we can now start processing the data
     close, datafile
     free_lun, datafile
                                ;Here we are creating the corrected
                                ;power spectrum, the wave amplitude
                                ;squared, and the wave amplitude.
     powerspec = powerspec / 2. ;the power conservation bug, units are nT^2/Hz here.
     amp2 = powerspec * 10E-3   ;multiply by frequency resolution (10 mHz) to get to nT^2.
     amp = sqrt(amp2)           ;wave amplitude in nT ; <-- comment out this line if you want
                                ;intensity and not amplitude.
                                ;Here we are creating a list that has
                                ;the uniq time steps at a
                                ;min. resolution. this will then be
                                ;used to find the min. averaged power
                                ;spectrums. 
     templist = strarr(n_elements(timelist))
     for j = 0l, n_elements(timelist) -1 do begin ;Here we are looping though and getting all the time fields. 
;        meep = strpos(timelist(j), '.')
        templist(j) = strmid(timelist(j),0,14)        
        templist(j) = '*'+templist(j)+'*'
     endfor                     ;Here we end the loop for creating the time arrays. 
     uniqlist = templist(uniq(templist, sort(templist)))
     tempyear = make_array(n_elements(uniqlist))
     tempyday = tempyear 
     temphour = tempyear
     tempmin = tempyear
     
                                ;Here we go through min by min to
                                ;create the averaged power spectrums.
     for j=0l, n_elements(uniqlist) -1 do begin        ; Here we start foing through and creating 
                                ;the min. resolution data
        inds = where(strmatch(timeList, uniqlist(j)) ) ; I know there is an EMIC around day 274 at
                                ;18:34 UT in 1991. Find it in the data.
        tempyear = fix(strmid(uniqlist(j),1,4))       
        tempyday = fix(strmid(uniqlist(j),5,3))
        temphour =  fix(strmid(uniqlist(j),9,2))        
        tempmin =  fix(strmid(uniqlist(j),12,2))
        print, uniqlist(j)
                                ; if you are in linux shell you can do something like
                                ;	  cat emic1043_8Hz.spc | grep
                                ;	  '1991274 18:33:51' -C200
                                ; to see the contents to the file. The
                                ; grep looks for the string in the
                                ; file. The -C dictatates the number
                                ; of lines surrounding the match to show.
        ;print, timeList[inds]	; check the times
                                ;print, backgroundField[inds]	; nT     
        tempbo = mean(backgroundfield(inds))
        fcp = (1.602E-19*tempbo*1E-9)/ (1.67E-27* 2.*!Pi)
        fche =  (1.602E-19*tempbo*1E-9)/ (4.*1.67E-27* 2.*!Pi)
        freqAxis = findgen(800) / (1600 * 0.0625)
        freqstep = freqAxis(1) - freqAxis(0)
        indexHband = where((freqAxis ge (.4*fcp)) and (freqAxis le fcp))
        indexHeband = where((freqAxis ge (.4*fcHE)) and (freqAxis le fcHE))
        temppower = make_array(n_elements(powerspec(0,*)), value = 0.)
        tempamp2 = temppower
        tempamp = temppower
        for k = 0l, n_elements(inds) -1. do begin 
           temppower = temppower + powerspec(inds(k), *)
           tempamp2 = tempamp2 + amp2(inds(k), *)
           tempamp = tempamp + amp(inds(k), *)
        endfor

        temppowerspec = temppower/n_elements(inds)
        tempwaveintensity = tempamp2/n_elements(inds)
        tempwaveamp = tempamp/n_elements(inds)
                                ;Here we are finding the integrated
                                ;wave intensity over the H+ and He+
                                ;bands. We will decide later which one
                                ;we want to use. 
                                ;Now we also want to know what the
                                ;peak frequency is in the H and He
                                ;bands and in the areas preceding
                                ;those regions. If the peak in a
                                ;preceding region is greater than the
                                ;peak frequency in the band then we
                                ;would prefer to throw out the
                                ;data... but that can be done in other
                                ;programs. At the moment we just want
                                ;to get the peak frequencies and their
                                ;power. 
        if indexhband(0) ne -1 then begin 
           Hband = total(tempwaveintensity(indexHband))
           hdb = max(tempwaveamp(indexhband), /NAN)
           temp = where(tempwaveamp eq hdb)
           if temp(0) ne -1 then hfreq = mean(freqAxis(temp), /nan) else hfreq = !values.F_NAN
           houtdb =  max(tempwaveamp(indexhband(0)-2.:indexhband(0)-1.), /NAN)
           temp = where(tempwaveamp eq houtdb)
           if temp(0) ne -1 then houtfreq = mean(freqAxis(temp), /nan) else houtfreq = !values.F_NAN
           ;print, 'hdb - houtdb', hdb - houtdb
        endif else begin
           Hband = !values.F_NAN
           ;print, 'on loop ', i, 'no data'
           hdb = !values.F_NAN
           hfreq = !values.F_NAN
           houtdb = !values.F_NAN
           houtfreq = !values.F_NAN
        endelse
        if indexheband(0) ne -1 then begin 
           Heband = total(tempwaveintensity(indexHEband)) 
           hedb = max(tempwaveamp(indexheband), /NAN)
           temp = where(tempwaveamp eq hedb)
           if temp(0) ne -1 then hefreq = mean(freqAxis(temp), /nan) else hefreq = !values.F_NAN
           heoutdb =  max(tempwaveamp(indexheband(0)-2.:indexheband(0) -1.), /NAN)        
           temp = where(tempwaveamp eq heoutdb)
           if temp(0) ne -1 then heoutfreq = mean(freqAxis(temp), /nan) else heoutfreq = !values.F_NAN
        endif else begin 
           ;print, 'no data in HE either' 
           heband = !values.F_NAN
           hedb = !values.F_NAN
           hefreq = !values.F_NAN
           heoutdb = !values.F_NAN
           heoutfreq = !values.F_NAN
        endelse
                                ;Now we want to find the peak wave
                                ;amplitude in the EMIC region and what
                                ;frequency it is at. 
        emicindex = where((freqAxis ge .1) and (freqAxis le 5))
        maxdeltaB = max(tempwaveamp(emicindex), /NAN)
        maxindex = where(tempwaveamp eq maxdeltaB)
        if maxindex(0) ne -1 then peakfreq = mean(freqAxis(maxindex), /nan) else peakfreq = !values.F_NAN
                                ;Here we are going to find the index
                                ;for the year long arrays 
;        print, 'yday is ', tempyday, ' hour is ', temphour, ' min is ', tempmin
        yindex = (tempyday -1.)*24.*60. + temphour*60. + tempmin
;        print, 'which makes the yindex', yindex
;        print, 'and the year is ', tempyear
       if tempyear eq 1990. then begin 
           bo90(yindex) = tempbo
           ;power90(yindex, *) = temppowerspec
           fp90(yindex) = fcp
           fHe90(yindex) = fche
           fo90(yindex) =  (1.602E-19*tempbo*1E-9)/(16.*1.67E-27* 2.*!Pi)
           intpH90(yindex) = hband ;We don't need to multiply because that is what Russel Did when we first went to nT^2.*freqstep
           intpHE90(yindex) = heband ;See above*freqstep
           pfreq90(yindex) = peakfreq
           db90(yindex) = maxdeltaB
           hfreq90(yindex) = hfreq
           hefreq90(yindex) = hefreq
           hout90(yindex) = houtfreq
           heout90(yindex) = heoutfreq
           hdb90(yindex) = hdb
           hedb90(yindex) = hedb
           houtdb90(yindex) = houtdb
           heoutdb90(yindex) = heoutdb
        endif 
        if tempyear eq 1991. then begin 
           bo91(yindex) = tempbo
           ;power91(yindex, *) = temppowerspec
           fp91(yindex) = fcp
           fHe91(yindex) = fche
           fo91(yindex) =  (1.602E-19*tempbo*1E-9)/(16.*1.67E-27* 2.*!Pi)
           intpH91(yindex) = hband ;See note in 1990 *freqstep
           intpHE91(yindex) = heband ;See above. *freqstep
           pfreq91(yindex) = peakfreq
           db91(yindex) = maxdeltaB
           hfreq91(yindex) = hfreq
           hefreq91(yindex) = hefreq
           hout91(yindex) = houtfreq
           heout91(yindex) = heoutfreq
           hdb91(yindex) = hdb
           hedb91(yindex) = hedb
           houtdb91(yindex) = houtdb
           heoutdb91(yindex) = heoutdb
        endif 
        ;plot, freqAxis, temppowerspec, /ylog, xtitle = 'Frequency [Hz]', ytitle = 'Wave amplitude [nT]',  xrange = [0.1,4], xstyle = 1
                                ;oplot, freqAxis, powerspec[inds(0),*], color = 8678678432342 ;
;        print,'H cyclotron freqyency', $
;              1.602E-19 / 1.67E-27 * backgroundField[445] * 1E-9 / 2 / !Pi                           ; H cyclotron frequency
     endfor                                                                                          ; this ends the loop for creating the min. time resolutions 
  endfor                                                                                             ;this ends the loop which cycles through the list of file names. 
  save, bo90, bo91, fp90, fp91, fHe90, fHe91, fo90, fo91, intpH90, intph91, intpHE90, intphe91, $
        pfreq90, pfreq91, db90, db91, freqAxis, hfreq90, hefreq90, hout90, heout90, hdb90, hedb90, houtdb90, $
        heoutdb90, hfreq91, hefreq91, hout91, heout90, hdb91, hedb91, houtdb91,$
        heoutdb91, filename = '../../../Volumes/iDisk/CORRECTED_CRRES_powerspec_1min.save';'../Data/CRRES_powerspec_1min.save'
  stop
  
end
