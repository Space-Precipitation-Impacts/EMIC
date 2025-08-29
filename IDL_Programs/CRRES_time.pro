pro CRRES_time

;Here I'm just trying to get out how much CRRES has moved in a given amount of time. 
deltat = 2

restore, '../Data/CRRES_1min_1990.save'
restore, '../Data/CRRES_1min_1991.save'

Ls = [Ls90, Ls91]
mlt = [mlt90, mlt91]
mlat = [mlat90, mlat91]
time = [eph_time90, eph_time91]
rad = [rad90, rad91]
x = [X_ECI90, X_ECI91]
y = [y_ECI90, y_ECI91]
z = [z_ECI90, z_ECI91]


deltaLs = Ls(deltat:n_elements(Ls)-1) - Ls(0:n_elements(Ls)-1 - deltat)
deltamlt = mlt(deltat:n_elements(MLT)-1) - mlt(0:n_elements(mlt)-1 - deltat)
deltarad = rad(deltat:n_elements(rad)-1) - rad(0:n_elements(rad)-1 - deltat)
deltamlat = mlat(deltat:n_elements(mlat)-1) - mlat(0:n_elements(mlat)-1 - deltat)

;print, 'median change in Ls' , median(deltaLS)
;print, 'median change in mlt' , median(deltamlt)*60, 'mins'
;print, 'median change in mlat' , median(deltamlat)
;print, 'median change in rad' , median(deltarad)*6378.00*1000., 'meters'

;********************************************************************************
index = where(Ls > 3)

Ls3 = Ls(index)
mlt3 = mlt(index)
mlat3 = mlat(index)
rad3 = rad(index)


deltaLs3 = Ls3(deltat:n_elements(Ls3)-1) - Ls3(0:n_elements(Ls3)-1 - deltat)
deltamlt3 = mlt3(deltat:n_elements(MLT3)-1) - mlt3(0:n_elements(mlt3)-1 - deltat)
deltarad3 = rad3(deltat:n_elements(rad3)-1) - rad3(0:n_elements(rad3)-1 - deltat)
deltamlat3 = mlat3(deltat:n_elements(mlat3)-1) - mlat3(0:n_elements(mlat3)-1 - deltat)

print, 'for L>3 median change in Ls' , median(deltaLS3)
print, 'for L>3 median change in mlt' , median(deltamlt3)*60, 'mins'
print, 'for L>3 median change in mlat' , median(deltamlat3)
print, 'for L>3 median change in rad' , median(deltarad3)*6378.00*1000., 'meters'


print, 'for L>3 mean change in Ls' , mean(deltaLS3, /nan)
print, 'for L>3 mean change in mlt' , mean(deltamlt3, /nan)*60, 'mins'
print, 'for L>3 mean change in mlat' , mean(deltamlat3, /nan)
print, 'for L>3 mean change in rad' , mean(deltarad3, /nan)*6378.00*1000., 'meters'


end
