Pro extract_crres
count = long(0)
text=' '
head=strarr(14)
j=long(0)
openr,u,'c:\paul\phd\crres\orb926_1120_1405b.val',/get_lun
openw,uu,'c:\paul\phd\crres\orb926_1120_1450c.val',/get_lun
for i=0, 13 do $
	begin
readf,u,text
print,text
head[j]=text
j=j+1
end
printf,uu,head
while not eof(u) do $
begin
readf,u,num
count=count+long(1)
if num LE 4.44E+7 then $
begin
readf,u,text
printf,uu,text
;stop
end
end
print,count

;print,num
close,u
close,uu
end