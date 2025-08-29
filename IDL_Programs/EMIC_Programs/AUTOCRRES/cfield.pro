Pro cfield
base = WIDGET_BASE()
field = CW_FIELD(base, xsize=50,TITLE = "Name", /FRAME)
WIDGET_CONTROL, base, /REALIZE
XMANAGER, 'cfield', base,/no_block
end