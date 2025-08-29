
PRO testwidg_event, ev
WIDGET_CONTROL, ev.top, get_uvalue=state,/HOURGLASS

 if ev.id EQ state.fil_menu then $
  begin
    if ev.value EQ 'New' then Result = DIALOG_MESSAGE('Not yet Implemented')
    if ev.value EQ 'Open'then begin
            FName=DIALOG_PICKFILE(title='Select File', FILTER = '*.0EP')
            widget_control,state.text,set_value='Processing '+string(FName)
            filenam,FName,ephv
            print,ephv.(34)
            for ii=0,n_tags(ephv)-1 do $
             begin
            state.eph.(ii)=ephv.(ii)

            endfor
            print,n_tags(state.eph)
            print,state.eph.(34)
            ; FName=DIALOG_PICKFILE(title='Save File', FILTER = '*.*')
            ; openw,u,/get_lun,Fname
    		; print,'testing'
			; print,state.eph.(34)
            ; printf,u,state.eph.(34)
            ; Free_lun,u


    endif
            if ev.value EQ 'Save' then $
            begin
             FName=DIALOG_PICKFILE(title='Save File', FILTER = '*.*')
             openw,u,/get_lun,Fname
    		 print,'testing'
			 print,state.eph.(34)
             printf,u,state.eph.(34)
             Free_lun,u
            endif


    if ev.value EQ 'Save As' then begin
           FName=DIALOG_PICKFILE(title='Save file as', FILTER = '*.*')
           openw,u,/get_lun,Fname
           printf,u,'hello'
           Free_lun,u
           endif
    if ev.value EQ 'Close' then Result = DIALOG_MESSAGE('Not yet Implemented')
    if ev.value EQ 'Exit' then widget_control,ev.top,/destroy
 endif

end


pro testwidg
base = WIDGET_BASE(title='UniNew SPG CRRES spacecraft data handling', xsize=400,/row,mbar=bar)
base2=widget_base()
;**************************************************

file_menu=WIDGET_BUTTON(bar, VALUE='File', /MENU)
Edit_menu=WIDGET_BUTTON(bar, VALUE='Edit', /MENU)
Ephermius_menu=WIDGET_BUTTON(bar, VALUE='Ephermius', /MENU)
Data_menu=WIDGET_BUTTON(bar, VALUE='Data', /MENU)
Help_menu=WIDGET_BUTTON(bar, VALUE='Help', /MENU)

;**************************************************
text=widget_text(base,xsize=50,/editable)
table=widget_table(base2,xsize=50,ysize=10,column_labels=string(''),/resizeable_rows,/resizeable_columns,$
/COLUMN_MAJOR)
eph_struct,eph
mm=tag_names(eph)
mm = STRLOWCASE(mm)
eph_desc = [ '1\time','0\'+string(mm[0]),'0\'+string(mm[12]),$
'0\'+string(mm[18]),'0\'+string(mm[21]),'2\'+string(mm[26]),'1\latitude' , $
         '0\'+string(mm[9]) , $
         '0\'+string(mm[14]) , $
         '0\'+string(mm[17]) , $
         '0\'+string(mm[20]) , $
         '0\'+string(mm[28]) , $
         '2\'+string(mm[31]),$
         '0\'+string(mm[33])]
;**************************************************

fil_desc=['0\New','0\Open','0\Save','0\Save As','0\Close','0\Exit']
Ed_desc=['0\Undo','0\Cut','0\Copy','0\Paste','0\Delete']
dat_desc=['0\Ex','0\Ey','0\Ez','0\Bx','0\By','0\Bz']
;**************************************************
eph_menu = CW_PDMENU(Ephermius_menu, eph_desc,uvalue='f2', /RETURN_NAME,/mbar)
fil_menu = CW_PDMENU(file_menu, fil_desc,uvalue='f3', /RETURN_NAME,/mbar)
Ed_menu = CW_PDMENU(Edit_menu, ed_desc,uvalue='f4', /RETURN_NAME,/mbar)
Dat_menu = CW_PDMENU(Data_menu, dat_desc,uvalue='f5', /RETURN_NAME,/mbar)

;**************************************************
eeph=strarr(1)
 state={fil_menu:fil_menu,$
        Ed_menu:Ed_menu,$
        eph_menu:eph_menu,$
        Dat_menu:Dat_menu,text:text,table:table,eph:eph}

;**************************************************
WIDGET_CONTROL, base, /REALIZE
WIDGET_CONTROL, base,set_uvalue=state
;WIDGET_CONTROL, base2, /REALIZE
XMANAGER, 'testwidg', base,/no_block
end

