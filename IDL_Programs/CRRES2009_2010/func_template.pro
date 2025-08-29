function func_template, file
;This function was create on April 28th 2009 by Alexa Halford
; This function is almost the same as Make_template but instead of
; eing a stand alone procedure it also returns the just created
; template to the parent procedure/program/function. 
template = ascii_template(file)

S1 = strpos(file, '.')
file2 = STRMID(file, 0, s1)

save, template, filename = strcompress('../Templates/'+file2+ '_template.save')

return, template

end
