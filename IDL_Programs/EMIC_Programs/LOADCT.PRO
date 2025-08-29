pro loadct, table_number, silent = silent, GET_NAMES = rnames, FILE=file
;+
; NAME:
;	LOADCT
;
; PURPOSE:
;	Load predefined color tables.
;
; CATEGORY:
;	Image display.
;
; CALLING SEQUENCE:
;	LOADCT [, Table]
;
; OPTIONAL INPUTS:
;	Table:	The number of the pre-defined color table to load, from 0 
;		to 15.  If this value is omitted, a menu of the available 
;		tables is printed and the user is prompted to enter a table 
;		number.
;
; KEYWORD PARAMETERS:
;	Silent:	If this keyword is set, the Color Table message is suppressed.
;	GET_NAMES: If this keyword is present AND DEFINED, the names
;		of the color tables are returned as a string array.
;		No changes are made to the color table.
;	FILE:	If this keyword is set, the file by the given name is used
;		instead of the file colors1.tbl in the IDL directory.  This
;		allows multiple IDL users to have their own color table file.
;		The specified file must exist.
;
; OUTPUTS:
;	No explicit outputs.
;
; COMMON BLOCKS:
;	COLORS:	The IDL color common block.
;
; SIDE EFFECTS:
;	The color tables of the currently-selected device are modified.
;
; RESTRICTIONS:
;	Works from the file: $IDL_DIR/colors1.tbl or the file specified
;	with the FILE keyword.
;
; PROCEDURE:
;	The file "colors1.tbl" or the user-supplied file is read.  If
;       the currently selected device doesn't have 256 colors, the color
;	data is interpolated from 256 colors to the number of colors
;	available.
;
;	The colors loaded into the display are saved in the common
;	block COLORS, as both the current and original color vectors.
;
;	Interpolation:  If the current device has less than 256 colors,
;	the color table data is interpolated to cover the number of
;	colors in the device.
;
; MODIFICATION HISTORY:
;	Old.  For a widgetized version of this routine, see XLOADCT in the IDL
;		widget library.
;	DMS, 7/92, Added new color table format providing for more than
;		16 tables.  Now uses file colors1.tbl.  Old LOADCT procedure
;		is now OLD_LOADCT.
;	ACY, 9/92, Make a pixmap if no windows exist for X windows to
;		determine properly the number of available colors.
;		Add FILE keyword.
;-
common colors, r_orig, g_orig, b_orig, r_curr, g_curr, b_curr


on_ioerror, bad
on_error, 2		;Return to caller if error
get_lun, lun

if !d.name eq 'X' and !d.window eq -1 then begin  ;Uninitialized?
;	If so, make a dummy window to determine the # of colors available.
	window,/free,/pixmap,xs=4, ys=4
	wdelete, !d.window
	endif

nc = !d.table_size		;# of colors in this device.
if nc eq 0 then message, 'Device has static color tables.  Can''t load.'

if (n_elements(file) GT 0) then filename = file $
                           else filename = filepath('colors1.tbl')

openr,lun, filename, /block

ntables = 0b
readu, lun, ntables

IF	(n_params() eq 0) or $		;Read names?
	(n_elements(rnames) ge 1) or $
	(not keyword_set(silent)) then begin
		names = bytarr(32, ntables)
		point_lun, lun, ntables * 768L + 1	;Read table names
		readu, lun, names
		names = strtrim(names, 2)
	ENDIF

IF n_elements(rnames) ge 1 THEN BEGIN	;Return names?
	rnames = names
	goto, close_file
	ENDIF


if n_params() lt 1 then begin	;Summarize table?
	nlines = (ntables + 2) / 3	;# of lines to print
	for i=0, nlines-1 do $		;Print each line
	  print, format="(i2,'- ',a17, 3x, i2,'- ',a17, 3x, i2,'- ',a17)", $
	    i, names(i), i+nlines, names(i+nlines), i+2*nlines < (ntables-1), $
		names(i+2*nlines < (ntables-1))
	read,'Enter table number: ',table_number
	endif

if (table_number ge ntables) or (table_number lt 0) then begin
  message, 'Table number must be from 0 to ' + strtrim(ntables-1, 2)
  end


if keyword_set(silent) eq 0 then $
	message,'Loading table ' + names(table_number),/INFO
aa=assoc(lun, bytarr(256),1)	;Read 256 long ints
r_orig = aa(table_number*3)
g_orig = aa(table_number*3+1)
b_orig = aa(table_number*3+2)

if nc ne 256 then begin	;Interpolate
	p = (lindgen(nc) * 255) / (nc-1)
	r_orig = r_orig(p)
	g_orig = g_orig(p)
	b_orig = b_orig(p)
	endif

r_curr = r_orig
g_curr = g_orig
b_curr = b_orig
tvlct,r_orig, g_orig, b_orig
goto, close_file

bad:
  message,'Error reading file: ' + filename + ', ' + !err_string

close_file:
  free_lun,lun
  return
end
