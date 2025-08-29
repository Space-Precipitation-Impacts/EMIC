pro make_template, file

template = ascii_template(file)

S1 = strpos(file, '.')
file2 = STRMID(file, 0, s1)

save, template, filename = strcompress('../Templates/'+file2+ '_template.save')

end
