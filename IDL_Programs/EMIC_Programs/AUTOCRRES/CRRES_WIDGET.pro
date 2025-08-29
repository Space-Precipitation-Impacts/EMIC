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
PRO CRRES_WIDGET_event, ev
;Beginning of main widget menu events
;**************************************************************************
;Initialization Parameters
;
common init_struct,state2
common init_parameter,data_path,eph_path,res_path,eve_path,spl_int,fre_int,log_path
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
;
WIDGET_CONTROL, ev.top, get_uvalue=state,/HOURGLASS
;WIDGET_CONTROL,state.text,set_value=data_files
;Declaring state structure as parent widget
;Hourglass set during runtime
 	    FName=DIALOG_PICKFILE(title='Select File', FILTER = '*.*',/READ,/NOCONFIRM,$
    													    get_path=path)
		;en=strlen(path)
		;enn=strlen(Fname)
		cd,eph_path
 ;Option if telemetry *.val file selected
		orbtemp=fix(strmid(Fname,en+3,4))
		orb=strtrim(orbtemp,1)
patheph=strmid(path,0,strlen(path)-strlen(orb)-6)+'eph\'
		 ;state.orb_binfile=orb_binfile
         ;state.orb_date=orb_date
         ;state.orb=orb
         ;stop
		cd,patheph

		;stop
		;stop
		;stop
 ;Check crfile.shr file for ephemerius file name corresponding to this orbit
		val_crfiles,orb,orb_binfile,orb_date
 ;Opens ephemeruis file and inputs parameters values
		;cd,strmid(path,0,strlen(path)-5)
		fileph,string(orb_binfile)+'.0ep',ephv,path,state
 ;Intialize required child widgets
        WIDGET_CONTROL, state.orb_info,SET_VALUE = 'Orbit'+string(orb)+'  '+string(orb_date)
		WIDGET_CONTROL, state.dat_info,SET_VALUE =string(' ')
 ;Open *.val file and input data values
 ;stop state.orb=orb
         state.orb_binfile=orb_binfile
         state.orb_date=orb_date
         state.orb=orb

         fileval2,Fname,valv,path,state
 ;Pass ephemerius and data values to sturctures.
         cm_eph=ephv
         cm_val=valv
 ;Intialize required parent and child widget menus
        WIDGET_CONTROL, state.Dat_menu, sensitive=1
        WIDGET_CONTROL, state.eph_menu, sensitive=1
        WIDGET_CONTROL, state.ser_menu, sensitive=1
        WIDGET_CONTROL, state.file_info,SET_VALUE =string(' ')
        WIDGET_CONTROL, state.dat_info,$
        SET_VALUE ='Choice time or spectral domain using Series menu'
 ;Pass orbit info to state structure
        ;state.orb=orb
        ;state.orb_binfile=orb_binfile
        ;state.orb_date=orb_date
 ;Default error message
 ;*************************************************************************************
 ;Menu File->Save options
 ;
    		eph_data_write,state,cm_eph,cm_val,ffeph
            print,ffeph
            eph_plot_ps,state,cm_eph,cm_val,ffeph
			print,ffval
    		val_plot_ps,state,cm_eph,cm_val,ffval


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

PRO Dat_menu_Poynt_event, ev
common orbinfo,orb,orb_binfile,orb_date
common cm_crres,state,cm_eph,cm_val
WIDGET_CONTROL, ev.top, get_uvalue=state,/HOURGLASS
WIDGET_CONTROL, ev.id,get_uvalue=Dat5
print,dat5
WIDGET_CONTROL, state.file_info,get_value=fil_info
print,fil_info
;if fil_info EQ 'TIME DOMAIN' then $
if fil_info EQ 'SPECTRAL DOMAIN' then $
DPFlux2,state,cm_val,cm_eph,Dat5
end

PRO Dpch_event, ev
common orbinfo,orb,orb_binfile,orb_date
common cm_crres,state,cm_eph,cm_val
state.orb=orb
state.orb_binfile=orb_binfile
state.orb_date=orb_date
WIDGET_CONTROL, state.Dat_menu, sensitive=1
WIDGET_CONTROL, ev.top, get_uvalue=state,/HOURGLASS
WIDGET_CONTROL, ev.id,get_uvalue=f6
WIDGET_CONTROL, state.dat_info,$
       SET_VALUE ='Select data to view from Data menu'
WIDGET_CONTROL, state.file_info,SET_VALUE ='SPECTRAL DOMAIN'
;Dppow2,cm_eph,cm_val,state

DpChoice,n_elements(cm_val.(0))
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

pro data_save_event,ev
common orbinfo,orb,orb_binfile,orb_date
common cm_crres,state,cm_eph,cm_val
WIDGET_CONTROL, ev.top, get_uvalue=state,/HOURGLASS
WIDGET_CONTROL, ev.id,get_uvalue=f3
;WIDGET_CONTROL, state.dat_menu,get_uvalue=f5
print,f3
;print,f5
;stop
 rawE_write,cm_val,state,f3
end

;pro val_plot_ps_event,ev
;common orbinfo,orb,orb_binfile,orb_date
;common cm_crres,state,cm_eph,cm_val
;WIDGET_CONTROL, ev.top, get_uvalue=state,/HOURGLASS
;WIDGET_CONTROL, ev.id,get_uvalue=f3
;WIDGET_CONTROL, state.dat_menu,get_uvalue=Dat5
;print,Dat5
;stop
;val_plot_ps,state,cm_eph,cm_val,Dat5
;end

;******************************************************************************************
;Purpose:
;		Event handler for preprocessing CRRES spacecraft data.
;
;Calling Order:
;	 Parent Widget: "Pros_menu"
;	  Child Widget: "Process_menu"
;	  Child Option: "Processing"
;
;Dependencies:
;			lowa.pro: Control Widget for bandpass options
;					  Calls lowpass.pro to preform calculation.
;	Phase_remove.pro: Removes phasing due to spacecraft preprocessing
;		   alpha.pro: Calculates alpha angle for use in Ex calculations
;	 RotateCrres.pro: Rotates data from MGSE to Field Aligned coordinates
;		  Ex_cal.pro: Control Widget for Ex calculation options.
;					  Calls Ex_calcul.pro to preform calculation.
;		   Poynt.pro: Calculates Sxyz in time domain
;		 PhetaSB.pro: Calculates Pheta angle between S & B. Not fully implemented.
;  	  dpfluxnewb.pro: Calculates Sz in spectral domain (Redundant superseeded by
;					  Parent Menu->"Series"->"Spectral Domain").
;		 Despike.pro: Despikes time series data (Not yet fully implemented).
;
pro filter_event,ev
common orbinfo,orb,orb_binfile,orb_date
common cm_crres,state,cm_eph,cm_val
;**************************************************
;Get state structure
;
WIDGET_CONTROL, ev.top, get_uvalue=state,/HOURGLASS
;
;Get child widget values and store in Pros5
;
WIDGET_CONTROL, ev.id,get_uvalue=Pros5
;**************************************************
;Case for each Pros5 value
;
if Pros5 EQ 'Bandpass' then $
lowa,Pros5
if Pros5 EQ 'Despike' then $
 begin
;Result = DIALOG_MESSAGE('Despiking routine not yet implemented!')
Despike,cm_eph,cm_val,state
end
if Pros5 EQ 'Remove Phase Due to Spacecraft' then $
Phase_remove,Pros5
if Pros5 EQ 'Alpha Angle' then $
alpha, cm_eph,cm_val,state;,alph
;Result = DIALOG_MESSAGE('Alpha Angle Not yet Implemented')
if Pros5 EQ 'Field Aligned' then $
RotateCrres,cm_eph,cm_val,state
if Pros5 EQ 'MGSE' then $
Result = DIALOG_MESSAGE('MGSE Not yet Implemented')
if Pros5 EQ 'Calculate Ex' then $
Ex_cal
if Pros5 EQ 'Calculate time S' then $
Poynt,cm_eph,cm_val,state
if Pros5 EQ 'Calculate PhetaSB' then $
PhetaSB,cm_eph,cm_val,state;,dat5
if Pros5 EQ 'Calculate spectral Sz' then $
;dpfluxnewb,cm_eph,cm_val,state
Result = DIALOG_MESSAGE('This option is redundant!')
;****************************************************
end
;
;******************************************************************************************
;
pro CRRES_WIDGET
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
Edit_menu=WIDGET_BUTTON(bar, VALUE='Edit', /MENU)
Ephermius_menu=WIDGET_BUTTON(bar,uvalue='ephm',VALUE='Ephermius', /MENU)
Data_menu=WIDGET_BUTTON(bar, VALUE='Data', /MENU)
Series_menu=WIDGET_BUTTON(bar, VALUE='Series', /MENU)
Process_menu=WIDGET_BUTTON(bar, VALUE='Processing', /MENU)
Help_menu=WIDGET_BUTTON(bar, VALUE='Help', /MENU)

;**************************************************

orb_info = WIDGET_LABEL(base2,value='USE File MENU TO ',/DYNAMIC_RESIZE)
dat_info= WIDGET_LABEL(base2,value='SELECT *.val or *.0ep FILE',/DYNAMIC_RESIZE)
val_info = WIDGET_LABEL(base2,value=' ',/DYNAMIC_RESIZE)
text=widget_text(base2,xsize=60,ysize=30,/SCROLL,/EDITABLE)
file_info = WIDGET_LABEL(base2,value=' ',uvalue='fil_info',/DYNAMIC_RESIZE)
;****************************************************************************
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
Ed_menu = CW_PDMENU(Edit_menu, ed_desc,uvalue='f4', /RETURN_NAME,/mbar)
Dat_menu = CW_PDMENU(Data_menu, dat_desc,uvalue='f5',IDS='Dat5', /RETURN_NAME,/mbar)
Ser_menu = CW_PDMENU(Series_menu, ser_desc,uvalue='f6',IDS='ser5', /RETURN_NAME,/mbar)
;dom1_menu =  CW_PDMENU(base2, ser_desc,uvalue='f7', /RETURN_NAME)
pros_menu = CW_PDMENU(process_menu, pros_desc,uvalue='f7',IDS='pros5', /RETURN_NAME,/mbar)
;*****************************************************************************
eeph=strarr(1)
state={fil_menu:fil_menu,$
        Ed_menu:Ed_menu,$
        eph_menu:eph_menu,$
        Dat_menu:Dat_menu,$
        ser_menu:ser_menu,$
        pros_menu:pros_menu,$
        text:text,epph:epph,$
        ephss:0L,$
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
WIDGET_CONTROL, state.eph_menu, sensitive=1
WIDGET_CONTROL, state.Dat_menu, sensitive=1
WIDGET_CONTROL, state.ser_menu, sensitive=1
XMANAGER, 'CRRES_WIDGET', base,/no_block
end



