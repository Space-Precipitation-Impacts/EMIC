;**************************************************************************
;PROGRAM: CRRES_WIDGET.pro
;
;AUTHOR: PAUL MANUSIU
;
;DATE: DECEMBER 2000
;
;PURPOSE: Main CRRES Widget control for user interaction with data and ephmerius files
;
;INPUT FILES:
;crfiles.shr:
;	File has no header or index section. It consists entirely of 75 characters records in the
;	following format:
;			characters	description
;			0-4			Orbit Number
;			6-24		Date/Time when data for the orbit begins
;			26-44		Date/Time when data for the orbit ends
;			46-57		File Name
;			59-70		Identification of the optical disk (redundant for this program)
;			72-74		Obsolete code
;
;Ephmerius File:
;	FileName:
;	Ephmerius file is of form c#.0ep which is 12 charcters long and # is a seven digit number.
;	char 0: lower case c
;	char 1-2: last two digits of year ( e.g. 90 for 1990)
;	char 3-5: day number with January 1 as day 1.
;	char 6-7: Hour of the day
;	Note: chars 1-5 correspond to the start date/Time in crfiles.shr file.
;		  chars 6-7 is hour value of Start date/Time in crfiles.shr file.
;		  minutes and seconds are ignored in *.0ep filename.
; 	Data Section Format:
;		Data is in ASCII binary format.
;		Consists of multiple data groups in chronological order. Each group is 240 bytes long
;		and consists of 60 4-byte integers.
;		No header index for file.
;		No negative integers in ephemerius file.
;		Binary values stored in Big-endian sequence.
;		Each data group consists of 59 ephemerius parameters with last three parameters vacant.
;
;Telemetry File:
;	General:
;	The file is post fiche formatted. The binary telemetry file is not used here since we are
;	only interested in E and B fields. The binary telemetry file is inputted into fiche and the
;	resultant output is the input telemetry file for this program.
;	FileName:
;	Orb*.val format
;	* consists of upto five string groups:
;	(i) Orbit number (e.g. 75 or 200)
;	(ii) May also give highpass filter value from fiche preprocessing.
;	(iii) May also give lowpass filter value from fiche preprocessing.
;	(iv) may also give file start time (hhmm format)
;	(iv) may also give file end time (hhmm format)
;	(v) may also give date of file creation as fiche preprocessing date (ddmmyy eg 161100 which is
;	day 16 of November 2000).
;	Example of full name: Orb75_2000_2010_Low1.0Hz_High3.0Hz_161100.val
;						  Note: Only the first five and/or six characters
;						  will never change order and file name may not
;						  include all string groups. However the program
;						  only requires the first five and/or six
;						  characters run.
;	Data Section Format:
;		General:
;		File is in ASCII text and consists of a header and 8 data
;		quantities in total. The E fields are usually 32Hz sample rate
;		and the B fields always 16Hz. The E fields may sometimes be 16Hz
;		and this is a legacy of the fiche preprocessing and cannot be
;		controlled.
;
;		The 8 data quantities are:
;			 2 E-fields	(mV/m)				 6 B-fields (nT)
;		(0 E-field12 is Ey in MGSE)		(2   BX is dBx in MGSE)
;	 	(1 E-field34 is Ez in MGSE)		(3   BY is dBy in MGSE)
;										(4   BZ is dBz in MGSE)
;										(5   BX is Bx+dBx in MGSE)
;										(6   BY is By+dBy in MGSE)
;										(7   BZ is Bz+dBz in MGSE)
;
;
;		Example Header:
;				CRRES Orbit 75, Day 237 (Aug 25) 1990, 23:41:00.000 to 23:52:39.999
;				File:  c9023715.0tm
;				NumberQuantities  8
;				INDEX  NAME                      UNITS         NUMBER_COMPONENTS
;				0   E-Field12                 mV/m          1
;				1   E-Field34                 mV/m          1
;				2   BX- MGSE\n(scaled & offs  nTelsa        1
;	 			3   BY- MGSE\n(scaled & offs  nTelsa        1
;				4   BZ- MGSE\n(scaled & offs  nTelsa        1
;				5   BX- MGSE\n(scaled & offs  nTelsa        1
;				6   BY- MGSE\n(scaled & offs  nTelsa        1
;				7   BZ- MGSE\n(scaled & offs  nTelsa        1
;
;		Example Data Section:
;			  TIME   INDEX    COMPONENTS
;			 85275003  7   4.345876E+02
;				:	   :		:
;				:	   :		:
;		Note: The first character of each line corresponds to the position along each
;			  line of the first character on the TIME tag long integer. In the above
;			  example this would be position of 8 in 85275003.
;
;			  Each line of data consists of three values and every new line usually
;			  indexes sequencually up or down but not always.
;
;		Values:
;			TIME: Long integer
;			INDEX: Integer which corresponds to the index on header section.
;			COMPONENTS: Double and/or Float is actual value of for the indexed
;  						component.
;
;WARNING ABOUT POST FICHE FILES:
;		  Fiche usually appends to the telemetry ascii text files a few
;		  empty lines at the end of the file. The last line in the file
;		  must correspond to last data section line. So delete empty lines
;		  at bottom of all *.val files before inputting to program. The
;		  *.val files should not allow the cursor to move pass the last
;		  character in the data section. The "backspace" key will usually
;		  do this for you in any GUI text editor than don't forget to save
;		  file afterwards.
;
;DEPENDENTS/SUBROUTINES:
;			PARENT WIDGET MENU:
;					File->New:
;					Desensitizes Widget Menu options "Ephmerius","Data" & "Series"
;					However does not destroy data or ephmerius structures.

;					File->Open:
;					eph_crfiles->opens crfiles.shr, returns orbit No. and orbit date.
;					val_crfiles->opens crfiles.shr, returns ephmerius filename and orbit date.
;					fileph->opens ephmerius file, extracts ephmerius parameter values for orbit.
;							Looks in current directory and if not found
;							prompts for option to search in d:\ (cdrom) drive.
;					fileval2->opens data file, extracts telemetry data for E and B fields.
;
;					File->Save:
;					eph_data_write->Write current ephemerius data to file
;					eph_plot_ps->Plots to postscript current ephemerius plot in graphics window.
;					val_plot_ps->Plots to postscript current data plot in graphics window.
;
;**************************************************************************
;Formats x axis into hours:minutes
Function XTLab,Axis,Index,Value
 mSec=long(Value)
 milsec=long(mSec) Mod 1000
 seci=Long(mSec/1000)
 secf = long(seci) mod 60
 mni=Long(seci)/60
 mnf = long(mni) mod 60
 hr = Long(mni/60)
 Return,String(hr,mnf,$
  Format="(I2.2,':',I2.2)")
end
;
;**************************************************************************
PRO CRRES_WIDGET_AUTO_event, ev
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
;
WIDGET_CONTROL, ev.top, get_uvalue=state,/HOURGLASS
if ev.id EQ state.fil_menu then $
  begin
    CASE ev.value OF
    'New': begin
    			WIDGET_CONTROL, state.orb_info,SET_VALUE = 'New'
				WIDGET_CONTROL, state.dat_info,SET_VALUE =' '
				CRRES_AUTO_CAL
			end
	'Save': begin
 ;*Auto Functions Begin
 ;*************************************************************************************
; stop
;noi=9
;Phase_remove
;fre_low=0.0200
;fieldch=[1,0,0,0]
;lowpass,fieldch,fre_low
;alpha,cm_eph,cm_val,state
;cut=70.0
;Ex_calcul,cm_eph,cm_val,state,cut
;RotateCrres,cm_eph,cm_val,state
;ffval='ALL E FIELDS'
;val_plot,state,cm_eph,cm_val,ffval
;ffval='ALL DB FIELDS'
;val_plot,state,cm_eph,cm_val,ffval
;Poynt,cm_eph,cm_val,state
;ffval='ALL FIELDS'
;Printf,lg,'Plotting S fields to file'
;BB='Sall'
WIDGET_CONTROL, state.text,SET_VALUE ='Plotting Sz field',/show
;val_plot,state,cm_eph,cm_val,ffval
;WIDGET_CONTROL, state.text,SET_VALUE ='Calculating CrossPower',/show
;Printf,lg,'Calculating CrossPower'
noi=0
;dat5='CROSSPOWER'
;dpcrosspower,cm_eph,cm_val,state,Dat5,noi
;BB='BXYdp'
;stop
dat5='SZ'
DPpoynt,cm_eph,cm_val,state,Dat5,noi
stop


;ffval='ALL FIELDS'
;		BB='Sall'
;		val_plot,state,cm_eph,cm_val,ffval
;stop

;		dat5='SZ'
;		DPpoynt,cm_eph,cm_val,state,Dat5,noi
;stop
;noi=4
;		BB='Ball_nonFA'
;		FFVAL='ALL B FIELDS'
;		val_plot,state,cm_eph,cm_val,ffval
;		stop
;			val_plot_ps,state,cm_eph,cm_val,FFVAL,BB,noi
;
	;	Despike_test,cm_eph,cm_val,state,BB,noiw
;	stop

	;ffval='Z FIELDS'
	;	BB='Zall_despiked_'+string(para_struct[noi].event_freq+0.5,format='(F3.1)')+'Hzlow'
	;	;Printf,lg,'Plotting despiked Z fields to file'
	;	WIDGET_CONTROL, state.text,SET_VALUE ='Plotting Z fields',/append,/show
	;	val_plot,state,cm_eph,cm_val,ffval
	;	WIDGET_CONTROL, state.text,SET_VALUE =' ',/append,/show
	;	val_plot_ps,state,cm_eph,cm_val,ffval,BB,noi
	;	stop
 	;WIDGET_CONTROL, state.text,SET_VALUE ='Calculating Poynting Flux for Sz',/show
	;	Printf,lg,'Calculating Poynting Flux for Sz'
	;	dat5='SZ'
	;	DPpoynt,cm_eph,cm_val,state,Dat5,noi
	;	BB='SZdptesta'
	;	WIDGET_CONTROL, state.text,SET_VALUE ='Plotting Poynting Flux for Sz to file',/append,/show
	;	printf,lg,'Plotting Poynting Flux for Sz to file'
	;	spectralpoyntps,cm_eph,cm_val,state,Dat5,BB,noi
	;	BB='POYNT'

	;	Despike_spectral,cm_eph,cm_val,state,BB,noi
;
;		BB='SZdptestb'
;		WIDGET_CONTROL, state.text,SET_VALUE ='Plotting Poynting Flux for Sz to file',/append,/show
	;	printf,lg,'Plotting Poynting Flux for Sz to file'
;		spectralpoyntps,cm_eph,cm_val,state,Dat5,BB,noi
;stop
 ;Ephmerius Processing
		;eph_data_write,state,cm_eph,cm_val
		;eph_plot_ps,state,cm_eph,cm_val

 ;Telemetry Processing

		;Removing Phase due to spacecraft preprocessing
		;
		;Phase_remove

		;Plotting total B before low pass filtering
		;
		;noi=0
		;ffval='ALL B FIELDS'
		;BB='Ball_nonFA'
		;val_plot,state,cm_eph,cm_val,ffval
		;val_plot_ps,state,cm_eph,cm_val,ffval,BB,noi

		;Lowpass filtering total B's at 20mHz to remove variational fields
		;
		;fre_low=0.0200
		;fieldch=[1,0,0,0]
		;lowpass,fieldch,fre_low

		;Plotting B fields after low pass filtering
		;
		;noi=0
		;ffval='ALL B FIELDS'
		;BB='Ball_nonFA_20mHzlow'
		;val_plot,state,cm_eph,cm_val,ffval
		;val_plot_ps,state,cm_eph,cm_val,ffval,BB,noi

		;Calculate Alpha Angle
		;
		;alpha, cm_eph,cm_val,state

		;Calculating Ex assuming dE.dB=0
		;Ex_cal

		;cut=70.0
		;Ex_calcul,cm_eph,cm_val,state,cut

		;Despikng Data
		;
		;Despiking EX Data
		;


		;Rotate Crres data into field aligned coordinates
		;
		;RotateCrres,cm_eph,cm_val,state

		;Calculate Poynting Vector in time domain
		;
		;Poynt,cm_eph,cm_val,state
		;
		;Calculate PhetaSB
		;PhetaSB,cm_eph,cm_val,state


		;Plotting fields in time domain
		;
		;Noi=0
		;ffval='ALL FIELDS'
		;BB='Sall'
		;val_plot,state,cm_eph,cm_val,ffval
		;val_plot_ps,state,cm_eph,cm_val,ffval,BB,noi

		;noi=3
		;BB=[11,13]
		;Despike,cm_eph,cm_val,state,BB,noi

		;noi=0
		;ffval='ALL E FIELDS'
		;BB='Eall_despiked'
		;val_plot,state,cm_eph,cm_val,ffval
		;val_plot_ps,state,cm_eph,cm_val,ffval,BB,noi
		;
		;noi=0
		;ffval='ALL DB FIELDS'
		;BB='dBall_despiked'
		;val_plot,state,cm_eph,cm_val,ffval
		;val_plot_ps,state,cm_eph,cm_val,ffval,BB,noi
		;
		;noi=0
		;BB=[11,13]
		;Despike,cm_eph,cm_val,state,BB,noi

		;Noi=0
		;ffval='ALL FIELDS'
		;BB='Sall_despiked'
		;val_plot,state,cm_eph,cm_val,ffval
		;val_plot_ps,state,cm_eph,cm_val,ffval,BB,noi

		;noi=0
		;ffval='Z FIELDS'
		;BB='Zall_despiked'
		;val_plot,state,cm_eph,cm_val,ffval
		;val_plot_ps,state,cm_eph,cm_val,ffval,BB,noi

		;Lowpass filtering S fields to para_struct.event_freq +0.5
		;
		;noi=0
		;if float(para_struct[noi].event_freq+0.5) LT 4.0 then $
		;begin
		;fre_low=float(para_struct[noi].event_freq+0.5)
		;fieldch=[0,0,0,1]				;S FIELDS ONLY
		;WIDGET_CONTROL, state.text,SET_VALUE ='Lowpass filtering S fields',/append,/show
		;WIDGET_CONTROL, state.text,SET_VALUE =string(para_struct[noi].event_freq+0.5)+'Hz lowpass',/append,/show

		;lowpass,fieldch,fre_low

		;ffval='ALL FIELDS'
		;BB='Sall_'+string(para_struct[noi].event_freq+0.5,format='(F3.1)')+'Hzlow'
		;val_plot,state,cm_eph,cm_val,ffval
		;val_plot_ps,state,cm_eph,cm_val,ffval,BB,noi

		;END
		;
		;noi=0
		;ffval='Z FIELDS'
		;BB='Zall'
		;val_plot,state,cm_eph,cm_val,ffval
		;val_plot_ps,state,cm_eph,cm_val,ffval,BB,noi
		;noi=0
		 WIDGET_CONTROL, state.text,SET_VALUE ='Calculating S fields in spectral',/show
		 ;dat5='ALL FIELDS'
		 ;openw,lg,filename1[0],/get_lun,/append
		 ;printf,lg,' '
;noi=0
;dat5='ALL Z FIELDS'
;		 bb='Zalldptest2'
;		spectra_tim_Zps4,cm_eph,cm_val,state,Dat5,BB,noi
;	stop
;		noi=0
;		dat5='ALL DB FIELDS'
;		 DPOWN4_multi,cm_eph,cm_val,state,Dat5,noi
;		 BB='BalldpTEST'
;		 spectralps4_multi,cm_eph,cm_val,state,Dat5,BB,noi
		 ;STOP
		noi=0
		dat5='ALL FIELDS'
		 ;Printf,lg,'Calculating S fields in spectral'
		 DPpoynt_multi4,cm_eph,cm_val,state,Dat5,noi
		 BB='SdpTEST'
		 spectralpoyntps_multi4,cm_eph,cm_val,state,Dat5,BB,noi
		BB='POYNT'
		Despike_spectral,cm_eph,cm_val,state,BB,noi

		 BB='SdpTEST2'
		 spectralpoyntps_multi4b,cm_eph,cm_val,state,Dat5,BB,noi
		stop
		;*************************************************************************************
		  widget_control,state.text,$
			set_value=' ',/show
		WIDGET_CONTROL, state.orb_info,SET_VALUE =string(header[0])
		WIDGET_CONTROL, state.text,SET_VALUE ='Time Series analysis completed',/show
		;Print,lg,'Time Series analysis completed'
		;Print,lg,'Starting Spectral Analysis'

		widget_control,state.dat_info,$
		set_value='Starting Spectral Analysis',/show

		WIDGET_CONTROL, state.text,SET_VALUE ='Starting Spectral Analysis',/append,/show

		widget_control,state.filE_info,$
		set_value='SPECTRAL DOMAIN',/show
		wait,1.0
		;Spectral Analysis
		;
		;CrossPower calculations
		;
		;WIDGET_CONTROL, state.text,SET_VALUE ='Calculating CrossPower',/show
		;dat5='CROSSPOWER'
		;noi=3
		;dpcrosspower,cm_eph,cm_val,state,Dat5,noi
		;BB='BXYdp'
		;WIDGET_CONTROL, state.text,SET_VALUE ='Plotting CrossPower to file',/append,/show
		;spectralps,cm_eph,cm_val,state,Dat5,BB,noi

		;Ponyting Vector for Sz in spectral domain
		;
		 openw,lg,filename1[0],/get_lun,/append
		 printf,lg,' '

		;BB='SZdp2'
		;spectralpoyntps,cm_eph,cm_val,state,Dat5,BB,noi
		;BB='POYNT'
		;Despike_spectral,cm_eph,cm_val,state,BB,noi

		;BB='SZdp3'
		;spectralpoyntps,cm_eph,cm_val,state,Dat5,BB,noi
		bb='Zalldptest2'
		spectra_tim_Zps4,cm_eph,cm_val,state,Dat5,BB,noi
		;Power Spectra for E and B fields
		;

		 ;WIDGET_CONTROL, state.text,SET_VALUE ='Calculating E field power ',/show
		 ;dat5='ALL E FIELDS'
		 ;noi=5
		 ;DPOWN4_multi,cm_eph,cm_val,state,Dat5,noi
		 ;BB='Ealldp'
		 ;spectralps4_multi,cm_eph,cm_val,state,Dat5,BB,noi

 ;*************************************************************************************
 ;*Auto Functions End
            end
endcase
end

end

PRO eph_menu_event, ev
common eph_ff, ffeph
common orbinfo,orb,orb_binfile,orb_date
common cm_crres,state,cm_eph,cm_val
WIDGET_CONTROL, ev.top, get_uvalue=state,/HOURGLASS
WIDGET_CONTROL, ev.id,get_uvalue=ff
ffeph=ff
eph_plot,state,cm_eph,cm_val,ff
WIDGET_CONTROL, STATE.FILE_INFO,Set_value='TIME DOMAIN'
end

pro tim_event, ev
common orbinfo,orb,orb_binfile,orb_date
common cm_crres,state,cm_eph,cm_val
WIDGET_CONTROL, ev.top, get_uvalue=state,/HOURGLASS
WIDGET_CONTROL, ev.id,get_uvalue=f6
WIDGET_CONTROL, state.Dat_menu, sensitive=1
WIDGET_CONTROL, state.dat_info,$
        SET_VALUE ='Select data to view from Data menu'
WIDGET_CONTROL, state.file_info,SET_VALUE =string(strupcase(f6))
end


PRO Dat_menu_event, ev
common val_ff, ffval
Common bas,base5
common orbinfo,orb,orb_binfile,orb_date
common cm_crres,state,cm_eph,cm_val
common uvalues, ff,f2,f3,f4,f5,f6,dat5,ser5,fil_info
WIDGET_CONTROL, ev.top, get_uvalue=state,/HOURGLASS
WIDGET_CONTROL, ev.id,get_uvalue=Dat5
ffval=Dat5
;WIDGET_CONTROL, STATE.FILE_INFO,Set_value='TIME DOMAIN'
WIDGET_CONTROL, state.file_info,get_value=fil_info
print,fil_info
if fil_info EQ 'TIME DOMAIN' then $
	 if dat5 EQ 'CROSSPOWER' THEN $
	  Result = DIALOG_MESSAGE('Cross-power not available in time domain') else $
if dat5 EQ 'ALFVEN VELOCITY' THEN $
VEL_CAL ELSE $
val_plot,state,cm_eph,cm_val,Dat5 else $
if fil_info EQ 'SPECTRAL DOMAIN' then $
	begin

		IF DAT5 EQ 'ALL B FIELDS' or dat5 eq 'Alpha Angle'$
		THEN $
		Result = DIALOG_MESSAGE('Not yet implemented for multiple spectra !') $
		else $
		IF dat5 eq 'Z FIELDS' THEN $
		Z_FIELDS, state,cm_eph,cm_val,Dat5 $
		ELSE $
		if Dat5 EQ 'ALL DB FIELDS' OR DAT5 EQ 'ALL E FIELDS' THEN $
		DPOWN3_multi,cm_eph,cm_val,state,Dat5 $
		ELSE $
		IF DAT5 EQ 'ALL FIELDS' THEN $
		 DPpoynt_multi,cm_eph,cm_val,state,Dat5 $
		 ELSE $
		if dat5 eq 'SX' or dat5 eq 'SY' or dat5 eq 'SZ' then $
		;DPOWN3,cm_eph,cm_val,state,Dat5
		DPpoynt,cm_eph,cm_val,state,Dat5 $
		;DPFluxnewc,cm_eph,cm_val,state,dat5 $
        else $
        if dat5 EQ 'CROSSPOWER' THEN $
        dpcrosspower,cm_eph,cm_val,state,Dat5 $
		else $
		if dat5 EQ 'VG' THEN $
        group_velocity,cm_eph,cm_val,state,Dat5 $
        ELSE $
        	if dat5 EQ 'ALFVEN VELOCITY' THEN $
        ;alfven_velocity,cm_eph,cm_val,state,Dat5 $
		vel_cal,path $

        ELSE $
		DPOWN3,cm_eph,cm_val,state,Dat5
		;WDPow2,cm_eph,cm_val,state,Dat5
endif else $
Result = DIALOG_MESSAGE('Please select domain first from Series menu')
end


pro CRRES_WIDGET_AUTO
Common bas,base5
common cm_crres,state,cm_eph,cm_val
common uvalues, ff,f2,f3,f4,f5,f6,dat5,ser5,fil_info
common init_struct,state2
common init_parameter,data_path,eph_path,res_path,eve_path,spl_int,fre_int,log_path
base = WIDGET_BASE(title='UniNew SPG CRRES Spacecraft Data Handling',$
/base_align_top,/row,/FRAME,mbar=bar)
base2=widget_base(base,/COLUMN,/ALIGN_TOP)
base3=widget_base(base,/column,/ALIGN_TOP)
base4=widget_base(base,/column,/ALIGN_TOP,map=1)

;**************************************************
file_menu=WIDGET_BUTTON(bar, VALUE='File', /MENU)
;Edit_menu=WIDGET_BUTTON(bar, VALUE='Edit', /MENU)
Ephermius_menu=WIDGET_BUTTON(bar,uvalue='ephm',VALUE='Ephermius', /MENU)
Data_menu=WIDGET_BUTTON(bar, VALUE='Data', /MENU)
Series_menu=WIDGET_BUTTON(bar, VALUE='Series', /MENU)
Process_menu=WIDGET_BUTTON(bar, VALUE='Processing', /MENU)
;Help_menu=WIDGET_BUTTON(bar, VALUE='Help', /MENU)

eph_res,epph,filp,Edp,datp,serp,prosp
eph_desc=epph
fil_desc=filp
Ed_desc=Edp
dat_desc=datp
ser_desc=serp
pros_desc=prosp
;*****************************************************************************
eph_menu = CW_PDMENU(Ephermius_menu, eph_desc,IDS='ff', uvalue='f2', /RETURN_NAME,/mbar)
fil_menu = CW_PDMENU(file_menu, fil_desc,uvalue='f3', /RETURN_NAME,/mbar)
;Ed_menu = CW_PDMENU(Edit_menu, ed_desc,uvalue='f4', /RETURN_NAME,/mbar)
Dat_menu = CW_PDMENU(Data_menu, dat_desc,uvalue='f5',IDS='Dat5', /RETURN_NAME,/mbar)
Ser_menu = CW_PDMENU(Series_menu, ser_desc,uvalue='f6',IDS='ser5', /RETURN_NAME,/mbar)
;dom1_menu =  CW_PDMENU(base2, ser_desc,uvalue='f7', /RETURN_NAME)
pros_menu = CW_PDMENU(process_menu, pros_desc,uvalue='f7',IDS='pros5', /RETURN_NAME,/mbar)
;*****************************************************************************

;**************************************************
orb_info = WIDGET_LABEL(base2,YSIZE=30,value='Automated Routines',/DYNAMIC_RESIZE)
dat_info= WIDGET_LABEL(base2,value='Starting Data Input....',/DYNAMIC_RESIZE)
val_info = WIDGET_LABEL(base2,value=' ',/DYNAMIC_RESIZE)
text=widget_text(base2,xsize=60,ysize=20,/SCROLL,/EDITABLE)
file_info = WIDGET_LABEL(base2,value=' ',uvalue='fil_info',/DYNAMIC_RESIZE)
;****************************************************************************

eeph=strarr(1)
state={fil_menu:fil_menu,$
        eph_menu:eph_menu,$
        Dat_menu:Dat_menu,$
        ser_menu:ser_menu,$
        pros_menu:pros_menu,$
text:text,$
        orb_info:orb_info,$
        dat_info:dat_info,$
        file_info:file_info,$
        val_info:val_info,$
        base:base,$
        base2:base2,$
        base3:base3,$
        base4:base4,$
        orb:strarr(1),$
        orb_binfile:strarr(1),$
        orb_date:strarr(1)}
;***********************************************************************************
 geo= widget_info( base, /geo )
  x= 600- geo.xsize/2
  y= 300- geo.ysize/2
 ;**************************************************
 widget_control, base, xoffset=x, yoffset=y

WIDGET_CONTROL, base, /REALIZE,update=1

WIDGET_CONTROL, base,set_uvalue=state

XMANAGER, 'CRRES_WIDGET_AUTO', base,/no_block
CRRES_AUTO_CAL
end



