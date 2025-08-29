;AUTHOR: T. Loto'aniu
;
;TITLE: crres_auto_cal.pro
;
;DATE: June 2001
;
;PURPOSE: Main call program for automated routines.
;
;
;
PRO CRRES_eph_AUTO_CAL
;Beginning of main widget menu events
;**************************************************************************
;Initialization Parameters
;
common init_struct,state2
common init_parameter,idl_path,data_path,eph_path,res_path,eve_path,spl_int,fre_int,log_path
;***********************************************************************************
common orbinfo,orb,orb_binfile,orb_date
;Declared global variables:
;	orb->orbit No.
;	orb_binfile->ephmerius file name.
;	orb_date->orbit date.
;**************************************************************************
common cm_crres,state,cm_eph,cm_val
;Declared global varibles:
;	state->structure holding child widgets and submenus.
;	cm_eph->structure holding ephmerius variables
;	cm_val->sturcture holding telemetry data
;**************************************************************************
common eph_ff, ffeph
;Declared global variable:
;	ffeph->hold ephmerius data
;**************************************************************************
common val_ff, ffval
;Declared global variable:
;	ffval->holds telemetry data
;**************************************************************************
;
common val_header, header
;**************************************************************************
common datafiles, data_files,no_data,para_struct

;**************************************************************************
;Log files
common logs, filename1,filename2
;Begin of loop for each event processing
;
;stop
;**************************************************
;FFT and time resolution for spectral analysis
;
common fre_timres, fft_limit, timres_limit
;
;**************************************************
 ephmerfil=' '
for noi=0, no_data -1 do $
  begin
	cd,eph_path[0]
	openw,lg,filename1,/get_lun,/append
	printf,lg,' '
	printf,lg,'Beginning main data processing...'

	WIDGET_CONTROL, state.text,SET_VALUE ='Beginning main data processing...',/show
	;stop
    ;Option if telemetry *.val file selected
    	;NOTE: Testing with one orbit first
		orb=strtrim(para_struct[noi].orbit,2)
		;stop
 ;Check crfile.shr file for ephemerius file name corresponding to this orbit
 		WIDGET_CONTROL, state.text,SET_VALUE ='Data File: '+string(noi+1),/append,/show
 		WIDGET_CONTROL, state.text,SET_VALUE ='File: '+string(para_struct[noi].filename),/append,/show
 		WIDGET_CONTROL, state.text,SET_VALUE ='Checking file crfiles.shr or ephmerius file',/append,/show
		val_crfiles,orb,orb_binfile,orb_date
		WIDGET_CONTROL, state.text,SET_VALUE ='Ephmerius file found: '+string(orb_binfile),/append,/show
		printf,lg,'Data File '+string(noi+1)
		printf,lg,'File: '+para_struct[noi].filename
		printf,lg,'Ephmerius File: '+orb_binfile
;stop
 		;Opens ephemeruis file and inputs parameters values
		;cd,strmid(path,0,strlen(path)-5)
		;stop
		printf,lg,'Extracting ephmerius information'
		WIDGET_CONTROL, state.text,SET_VALUE ='Extracting ephmerius information',/append,/show
		fileph,string(orb_binfile)+'.0ep',ephv,state
		WIDGET_CONTROL, state.text,SET_VALUE =' ',/append,/show
 ;Intialize required child widgets
        WIDGET_CONTROL, state.orb_info,SET_VALUE = 'Orbit'+string(orb)+'  '+string(orb_date)
		WIDGET_CONTROL, state.dat_info,SET_VALUE =string(' ')


 ;Open *.val file and input data values
 ;stop state.orb=orb
         state.orb_binfile=orb_binfile
         state.orb_date=orb_date
         state.orb=orb
;stop
;*****************************************************************************************
;Removed extraction of telemetry data becuase only require ephemeris data
;
        ; printf,lg,'Extracting Telemetry Data'
   		;WIDGET_CONTROL, state.text,SET_VALUE ='Extracting telemetry data',/append,/show
        ;fileval2,para_struct[noi].filename,valv,state
		;fileval2_test,para_struct[noi].filename,valv,state

;         WIDGET_CONTROL, state.text,SET_VALUE =' ',/append,/show
 ;Pass ephemerius and data values to sturctures.

;         cm_val=valv
;*****************************************************************************************
         cm_eph=ephv

 ;STOP
 ;*Auto Functions Begin
 ;*************************************************************************************
 ;Ephmerius Processing
 jj = no_data - 1
 eph_EVENT_VALUES,cm_eph,cm_val,state,jj
end
 stop
   	if 	ephmerfil NE state.orb then $
   	begin
 		WIDGET_CONTROL, state.text,SET_VALUE ='Writing some ephmerius information to file',/append,/show
 		printf,lg,'Writing some ephmerius information to file'
 		eph_data_write,state,cm_eph,cm_val
		WIDGET_CONTROL, state.text,SET_VALUE ='Plotting some ephmerius information to file',/append,/show
		printf,lg,'Writing some ephmerius information to file'
		eph_plot_ps,state,cm_eph,cm_val
	ephmerfil=state.orb
	end else $
	begin
		WIDGET_CONTROL, state.text,SET_VALUE ='Ephmerius information for this orbit',/append,/show
 		WIDGET_CONTROL, state.text,SET_VALUE ='already written to file.',/append,/show
		printf,lg,'Ephmerius information already written to file'
 	end

 ;Telemetry Processing

		;Removing Phase due to spacecraft preprocessing
		;
		WIDGET_CONTROL, state.text,SET_VALUE ='Removing Phase due to spacecraft preprocessing',/show
		printf,lg,'Removing Phase due to spacecraft preprocessing'
		Phase_remove

		;Plotting total B before low pass filtering
		;
		ffval='ALL B FIELDS'
		BB='Ball_nonFA'
		WIDGET_CONTROL, state.text,SET_VALUE ='Plotting total B before low pass filtering',/append,/show
		printf,lg,'Plotting total B before low pass filtering'
		val_plot,state,cm_eph,cm_val,ffval
		WIDGET_CONTROL, state.text,SET_VALUE ='Plotting total B before low pass filtering to file ',/show
		val_plot_ps,state,cm_eph,cm_val,ffval,BB,noi

		WIDGET_CONTROL, state.text,SET_VALUE ='Lowpass filtering total B at 20mHz to remove variational fields ',/append,/show
		printf,lg,'Lowpass filtering total B at 20mHz to remove variational fields'
		;Lowpass filtering total B's at 20mHz to remove variational fields
		fre_low=0.0200
		fieldch=[1,0,0,0]			;B fields
		lowpass,fieldch,fre_low

		;Plotting B fields after low pass filtering
		;
		ffval='ALL B FIELDS'
		BB='Ball_nonFA_20mHzlow'
		WIDGET_CONTROL, state.text,SET_VALUE ='Plotting B fields after low pass filtering',/append,/show
		Printf,lg,'Plotting B fields after low pass filtering'
		val_plot,state,cm_eph,cm_val,ffval

		WIDGET_CONTROL, state.text,SET_VALUE ='Plotting B fields after low pass filtering to file',/show
		Printf,lg,'Plotting B fields after low pass filtering to file'
		val_plot_ps,state,cm_eph,cm_val,ffval,BB,noi

		;Calculate Alpha Angle
		;
		WIDGET_CONTROL, state.text,SET_VALUE ='Calculate Alpha Angle',/append,/show
		Printf,lg,'Calculate Alpha Angle'
		alpha,cm_eph,cm_val,state

		Printf,lg,' '
		Printf,lg,'Starting Time Series Analysis'
		Printf,lg,' '
		;//Calculating Ex assuming dE.dB=0
		;//Ex_cal
		;
		;Calculating Ex assuming dE.dB=0 && alpha angle set to 70deg
		Printf,lg,'Calculating Ex assuming dE.dB=0 && alpha angle set to 70deg'
		cut=70.0
		WIDGET_CONTROL, state.text,SET_VALUE ='Calculating Ex assuming dE.dB=0 && alpha angle set to 70deg',/append,/show
		Ex_calcul,cm_eph,cm_val,state,cut

		Print,lg,'Rotate Crres data into field aligned coordinates'
		WIDGET_CONTROL, state.text,SET_VALUE ='Rotate Crres data into field aligned coordinates',/append,/show
		;Rotate Crres data into field aligned coordinates
		;
		RotateCrres,cm_eph,cm_val,state


		WIDGET_CONTROL, state.text,SET_VALUE ='Despiking data....',/append,/show
		BB=[1,6]
		Despike,cm_eph,cm_val,state,BB,noi
		Free_lun,lg

;stop
		openw,lg,filename1,/get_lun,/append
		printf,lg,' '
		;
		WIDGET_CONTROL, state.text,SET_VALUE ='Plotting fields in time domain',/append,/show
		Printf,lg,'Plotting fields in time domain'
		;Plotting fields in time domain

		ffval='ALL E FIELDS'
		Printf,lg,'Plotting E fields to file'

		BB='Eall'
		WIDGET_CONTROL, state.text,SET_VALUE ='Plotting E fields',/append,/show
		val_plot,state,cm_eph,cm_val,ffval
		WIDGET_CONTROL, state.text,SET_VALUE =' ',/append,/show
		val_plot_ps,state,cm_eph,cm_val,ffval,BB,noi

		ffval='ALL DB FIELDS'
		Printf,lg,'Plotting DB fields to file'
		BB='dBall'
		WIDGET_CONTROL, state.text,SET_VALUE ='Plotting DB fields',/append,/show
		val_plot,state,cm_eph,cm_val,ffval
		WIDGET_CONTROL, state.text,SET_VALUE =' ',/append,/show
		val_plot_ps,state,cm_eph,cm_val,ffval,BB,noi
		;
		WIDGET_CONTROL, state.text,SET_VALUE ='Calculate Poynting Vector in time domain',/append,/show
		Printf,lg,'Calculate Poynting Vector in time domain'
		;Calculate Poynting Vector in time domain
		;
		Poynt,cm_eph,cm_val,state

		ffval='ALL FIELDS'
		Printf,lg,'Plotting S fields to file'
		BB='Sall'
		WIDGET_CONTROL, state.text,SET_VALUE ='Plotting S fields',/append,/show
		val_plot,state,cm_eph,cm_val,ffval
		WIDGET_CONTROL, state.text,SET_VALUE =' ',/append,/show
		val_plot_ps,state,cm_eph,cm_val,ffval,BB,noi
		;
;stop
		WIDGET_CONTROL, state.text,SET_VALUE ='Calculate PhetaSB',/append,/show
		Printf,lg,'Calculate PhetaSB'
		;Calculate PhetaSB
		PhetaSB,cm_eph,cm_val,state

		;Despiking data
		BB=[1,13]
		Despike,cm_eph,cm_val,state,BB,noi

		openw,lg,filename1[0],/get_lun,/append
		printf,lg,' '
		;


		ffval='ALL E FIELDS'
		Printf,lg,'Plotting despiked E fields to file'

		BB='Eall_despiked'
		WIDGET_CONTROL, state.text,SET_VALUE ='Plotting E fields',/append,/show
		val_plot,state,cm_eph,cm_val,ffval
		WIDGET_CONTROL, state.text,SET_VALUE =' ',/append,/show
		val_plot_ps,state,cm_eph,cm_val,ffval,BB,noi

		ffval='ALL DB FIELDS'
		Printf,lg,'Plotting despiked DB fields to file'
		BB='dBall_despiked'
		WIDGET_CONTROL, state.text,SET_VALUE ='Plotting DB fields',/append,/show
		val_plot,state,cm_eph,cm_val,ffval
		WIDGET_CONTROL, state.text,SET_VALUE =' ',/append,/show
		val_plot_ps,state,cm_eph,cm_val,ffval,BB,noi
		;
		ffval='ALL FIELDS'
		Printf,lg,'Plotting despiked S fields to file'
		BB='Sall_despiked'
		WIDGET_CONTROL, state.text,SET_VALUE ='Plotting despiked S fields',/append,/show
		val_plot,state,cm_eph,cm_val,ffval
		WIDGET_CONTROL, state.text,SET_VALUE =' ',/append,/show
		val_plot_ps,state,cm_eph,cm_val,ffval,BB,noi
		;
		ffval='Z FIELDS'
		BB='Zall_despiked'
		Printf,lg,'Plotting despiked Z fields to file'
		WIDGET_CONTROL, state.text,SET_VALUE ='Plotting Z fields',/append,/show
		val_plot,state,cm_eph,cm_val,ffval
		WIDGET_CONTROL, state.text,SET_VALUE =' ',/append,/show
		val_plot_ps,state,cm_eph,cm_val,ffval,BB,noi

	;	if float(para_struct[noi].event_freq+0.5) LT 4.0 then $
	;	begin
		Printf,lg,'Low pass filtering S fields at '+string(para_struct[noi].event_freq+0.5,format='(F3.1)')
		fre_low=float(para_struct[noi].event_freq+0.5)
		fieldch=[0,0,0,1]				;S FIELDS ONLY
		WIDGET_CONTROL, state.text,SET_VALUE ='Lowpass filtering S fields',/append,/show
		WIDGET_CONTROL, state.text,SET_VALUE =string(para_struct[noi].event_freq+0.5)+'Hz lowpass',/append,/show
;
		lowpass,fieldch,fre_low

		ffval='ALL FIELDS'
		BB='Sall_despiked'+string(para_struct[noi].event_freq+0.5,format='(F3.1)')+'Hzlow'
		val_plot,state,cm_eph,cm_val,ffval
		val_plot_ps,state,cm_eph,cm_val,ffval,BB,noi
	;	end

		ffval='Z FIELDS'
		BB='Zall_despiked_'+string(para_struct[noi].event_freq+0.5,format='(F3.1)')+'Hzlow'
		Printf,lg,'Plotting despiked and lowpassed Z fields to file'
		WIDGET_CONTROL, state.text,SET_VALUE ='Plotting lowpassed and despiked Z fields',/append,/show
		val_plot,state,cm_eph,cm_val,ffval
		WIDGET_CONTROL, state.text,SET_VALUE =' ',/append,/show
		val_plot_ps,state,cm_eph,cm_val,ffval,BB,noi


		Printf,lg,'Time Series Analysis Complete'
		Printf,lg,' '
		Free_lun,lg
		close,/all
		openw,lg,filename1[0],/get_lun,/append
		;Spectral Analysis
		;
		Printf,lg,'Starting Spectral Analysis'
		Printf,lg,' '
		;CrossPower calculations
		;
		WIDGET_CONTROL, state.text,SET_VALUE ='Calculating CrossPower',/show
		Printf,lg,'Calculating CrossPower'
		dat5='CROSSPOWER'
		dpcrosspower,cm_eph,cm_val,state,Dat5,noi
		BB='BXYdp'
		WIDGET_CONTROL, state.text,SET_VALUE ='Plotting CrossPower to file',/append,/show
		Printf,lg,'Plotting CrossPower to file'
		spectralps,cm_eph,cm_val,state,Dat5,BB,noi

		;Ponyting Vector for Sz in spectral domain
		;
		WIDGET_CONTROL, state.text,SET_VALUE ='Calculating Poynting Flux for Sz',/show
		Printf,lg,'Calculating Poynting Flux for Sz'
		dat5='SZ'
		DPpoynt,cm_eph,cm_val,state,Dat5,noi
		BB='SZdp'
		WIDGET_CONTROL, state.text,SET_VALUE ='Plotting Poynting Flux for Sz to file',/append,/show
		printf,lg,'Plotting Poynting Flux for Sz to file'
		spectralpoyntps,cm_eph,cm_val,state,Dat5,BB,noi

		Free_lun,lg
		BB='POYNT'
		Despike_spectral,cm_eph,cm_val,state,BB,noi
		openw,lg,filename1[0],/get_lun,/append
		printf,lg,' '
		printf,lg,'Plotting Poynting Flux for Sz to file'
		BB='SZdp_despiked'

		spectralpoyntps,cm_eph,cm_val,state,Dat5,BB,noi

		 ;Power Spectra for E and B fields
		 ;

		 WIDGET_CONTROL, state.text,SET_VALUE ='Calculating E field power ',/show
		 dat5='ALL E FIELDS'
		 ;noi=0
		 printf,lg,'Calculating E field power  '
		 DPOWN4_multi,cm_eph,cm_val,state,Dat5,noi
		 BB='Ealldp'
		 spectralps4_multi,cm_eph,cm_val,state,Dat5,BB,noi

		 WIDGET_CONTROL, state.text,SET_VALUE ='Calculating dB field power ',/show
		 dat5='ALL DB FIELDS'
		 ;noi=5
		 printf,lg,'Calculating dB field power '
		 DPOWN4_multi,cm_eph,cm_val,state,Dat5,noi
		 BB='dBalldp'
		 spectralps4_multi,cm_eph,cm_val,state,Dat5,BB,noi

		 ;Poynting Flux in spectral for all components
		 ;
		 WIDGET_CONTROL, state.text,SET_VALUE ='Calculating S fields in spectral',/show
		 dat5='ALL FIELDS'
		 Printf,lg,'Calculating S fields in spectral'
		 DPpoynt_multi4,cm_eph,cm_val,state,Dat5,noi
		 BB='Salldp'
		 spectralpoyntps_multi4,cm_eph,cm_val,state,Dat5,BB,noi

		 ;Despiking S fields
		 ;
		 Free_lun,lg
         WIDGET_CONTROL, state.text,SET_VALUE ='Despiking S fields in spectral',/show
		 BB='POYNT'
		 Despike_spectral_multi,cm_eph,cm_val,state,BB,noi
		 openw,lg,filename1[0],/get_lun,/append
		 printf,lg,' '
		 dat5='ALL FIELDS'
		 BB='Salldp_despiked'
		 spectralpoyntps_multi4b,cm_eph,cm_val,state,Dat5,BB,noi
         ;Plotting Z fields
         ;
		 bb='Zalldp'
		 Printf,lg,'Plotting Z fields'
		 spectra_tim_Zps4,cm_eph,cm_val,state,Dat5,BB,noi
		 Printf,lg,'Spectral analysis complete'

		;End of spectral analysis




 ;*************************************************************************************
 ;*Auto Functions End

        ;WIDGET_CONTROL, state.file_info,SET_VALUE =string(' ')
       ;WIDGET_CONTROL, state.dat_info,$
        ;SET_VALUE ='Analyzing next file'
 ;Pass orbit info to state structure
        ;state.orb=orb
        ;state.orb_binfile=orb_binfile
        ;state.orb_date=orb_date
 ;Default error message
 ;*************************************************************************************
 ;Menu File->Save options
 ;
    	;	eph_data_write,state,cm_eph,cm_val,ffeph
         ;   print,ffeph
          ;  stop
           ; eph_plot_ps,state,cm_eph,cm_val,ffeph
		;	print,ffval
		;	stop
    	;	val_plot_ps,state,cm_eph,cm_val,ffval

		;	stop
		Free_lun,lg
		close,/all
	  end ;End of loop for data processing
	  WIDGET_CONTROL, state.orb_info,SET_VALUE = ' '
	  WIDGET_CONTROL, state.file_info,SET_VALUE =' '
        WIDGET_CONTROL, state.dat_info,$
        SET_VALUE ='Finished'
	 WIDGET_CONTROL, state.text,SET_VALUE ='Finished'
	 	openw,lg,filename1[0],/get_lun,/append
		Printf,lg,systime(0)
		Printf,lg,'Finshed'
		Free_lun,lg
		close,/all
end
