Pro test_file
text= ' '
for jj=0,10 do $
begin
openr,dd,'e:\events\events.val',/get_lun
while (NOT eof(dd)) do $
begin
readf,dd,text
print,text
end
;Free_lun,dd
close,/all

;HEAP_GC, /VERBOSE

;stop
;RETALL
stop
end
end