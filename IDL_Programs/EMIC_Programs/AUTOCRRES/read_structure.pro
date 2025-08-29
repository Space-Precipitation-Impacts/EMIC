PRO READ_STRUCTURE, S	;A procedure to read into a structure, S, from the keyboard with prompts.
NAMES = TAG_NAMES(S)	;Get the names of the tags. Loop for each field.
FOR I = 0, N_TAGS(S) - 1 DO BEGIN
    A = S.(I) 	;Define variable A of same type and structure as the i-th field.
    HELP, S.(I) 	;Use HELP to print the attributes of the field. Prompt user with tag name of this field, and then read into variable A. S.(I) = A. Store back into structure from A.

    READ, 'Enter Value For Field ', NAMES[I], ': ', A
    S.(I) = A
ENDFOR
END