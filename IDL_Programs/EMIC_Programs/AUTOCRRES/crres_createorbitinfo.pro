;******************************************************************************
;* PROCEDURE:
;* 	crres_createOrbitInfo
;*
;* DESCRIPTION:
;*	for all CRRES-data-files in the directory $CRRES_FILES,
;*	orbit-infos are created and written to the file
;*      $CRRES_WIDGETS/orbits.info
;* 	The 'get_crres_bin'-procedure is used to get the infos.
;*
;* INPUTS:
;*	none
;*
;* OUTPUT:
;*	none
;*
;* CALLING SEQUENCE:
;*	crres_createOrbitInfo
;*
;* MODIFICATION HISTORY:
;*      August 1995, written by A.Keese
;*      October 1997, modified by R.Friedel to read complete ephemeris
;*                                          files
;******************************************************************************
PRO crres_createOrbitInfo

  COMMON CRRES_eph_data, input_header, input_data

; search for the CRRES-data-files ?
  crres_path=papco_getenvpath('CRRES_EPH_DATA')
  files=findfile(crres_path+'*.idl')
  print, '...found', N_ELEMENTS(files), ' orbit-files'

; convert the found orbitfiles to a list of their numbers
  len=strlen(files(0))
  orbits=fix(strmid(files,len-8,4))

; make sure, each orbit appears only once
  orbits=orbits(UNIQ(orbits, SORT(orbits)))
  anzahl=N_ELEMENTS(orbits)
  print, '...these are', anzahl, ' orbits'

; get info for each orbit by calling
  tmp=papco_getOrbitInfoStruct;()	  ; create a CRRES_ORBIT_INFO-structure
  orbitInfo=replicate(tmp, anzahl)	  ; and create an array of those
  FOR i=0, anzahl-1 DO BEGIN
    print, 'reading orbit ',orbits(i), anzahl-i, ' to read---------------'
    xut1=0				        ; read all data
    xut2=0
    r_CRRES_eph, ORBIT=orbits(i)
    orbitInfo(i).number=input_header.orbit      ; save the data in
    orbitInfo(i).day=input_header.doy	 	; the orbitInfo-structure
    orbitInfo(i).year=input_header.year
    orbitInfo(i).xut2=input_data(n_elements(input_data)-1).time
    orbitInfo(i).xut1=input_data(0).time
    orbitInfo(i).xdata=0
    orbitInfo(i).ydata=0
  ENDFOR ;(i=0, anzahl-1)

; write the orbits.info-file
  result=papco_writeOrbitInfo('CRRES', orbitInfo)
  IF result EQ 'OK' THEN print, 'OrbitInfo successfully created.' $
  ELSE  print, result

  RETURN

END; (crres_createOrbitInfo)
