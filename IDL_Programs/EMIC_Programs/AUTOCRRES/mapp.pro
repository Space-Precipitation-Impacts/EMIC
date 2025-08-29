pro mapp
pp=findgen(10)
for i=0,9 do $
 begin
MAP_SET, /SATELLITE, SAT_P=[pp[i], 55, 150], 41.5, -74., $

   /ISOTROPIC, /HORIZON, $
   LIMIT=[39, -74, 33, -80, 40, -77, 41,-74], $
   /CONTINENTS, TITLE='Satellite / Tilted Perspective'
MAP_GRID, /LABEL, LATLAB=-75, LONLAB=39, LATDEL=1, LONDEL=1
;Set up the satellite projection.
end
end