;TITLE: RotateCrres.pro
;AUTHOR: Paul Manusiu
;DATE: 05/10/2000
;DESCRIPTION: Rotates CRRES data in MGSE into field aligned coordinates
;
Pro RotateCrres,cm_eph,cm_val,state
common init_parameter,idl_path,data_path,eph_path,res_path,eve_path,spl_int,fre_int,log_path
;***********************************************************************************
common orbinfo,orb,orb_binfile,orb_date
common logs, filename1,filename2
;********************************************************************************
common val_header, header
;********************************************************************************
common datafiles, data_files,no_data,para_struct

WIDGET_CONTROL, state.text,SET_VALUE = 'Rotate Crres data into field aligned coordinates'

openw,lg,filename1,/get_lun,/append
printf,lg,'Rotate Crres data into field aligned coordinates'

Ex=cm_val.(1)
Ey=cm_val.(2)
Ez=cm_val.(3)
dBx=cm_val.(4)
dBy=cm_val.(5)
dBz=cm_val.(6)
Bxmain=cm_val.(7)
Bymain=cm_val.(8)
Bzmain=cm_val.(9)
Sx=cm_val.(11)
Sy=cm_val.(12)
Sz=cm_val.(13)

;
;Rotation routine
WIDGET_CONTROL, state.text,SET_VALUE = 'Starting rotation procedure...',/append
Printf,lg,'Starting rotation procedure....'
Print,'Starting rotation procedure....'

;
pI=3.1415926535898
n=n_elements(cm_val.(0))						;Number of elements in each array
;n1=n_elements(dBxn)
;if long(n1) NE long(n) then $;
;	begin
;	 print,'All arrays must have same size';
;	 exit
;endif
;
;******************************************************************************
;Calculating theta and phi for rotation angles
;
theta = fltarr(n)
phi = fltarr(n)
;theta = atan(sqrt(BXmain*Bxmain+Bymain*Bymain)/abs(Bzmain))
;phi = atan(abs(BYMAIN/BXMAIN))
;
for q=long(0),long(n)-long(1) do $
 begin
 ;if(BZMAIN[q] EQ float(0.0)) then $
 ; begin
 ;  theta[q] = pI/2.0
 ;endif else $
 ; begin
   theta[q] = atan(sqrt(BXmain[q]*Bxmain[q]+Bymain[q]*Bymain[q])/abs(Bzmain[q]))
   if(BZMAIN[q] LT float(0.0)) then theta[q] = -theta[q]

 ;endelse
 ;if(BXMAIN[q] EQ float(0.0)) then $
 ;  begin
 ;  phi[q] = pI/2.0
 ;endif else $
 ;  begin
    phi[q] = atan(abs(BYMAIN[q]/BXMAIN[q]))
    if(BYMAIN[q] LT float(0.0)) AND (BXMAIN[q] LT float(0.0)) then phi[q] = phi[q] + pI
    if(BYMAIN[q] LT float(0.0)) and (BXMAIN[q] GT float(0.0)) then phi[q] = 2.0*pI-phi[q]
    if(BXMAIN[q] LT float(0.0)) and (BYMAIN[q] GT float(0.0)) then phi[q] = pI-phi[q]
 ;endelse
endfor
;
;******************************************************************************
;Rotation about z through phi to x1y1z1
;
WIDGET_CONTROL, state.text,SET_VALUE = 'Rotation about Z axis.......',/append
Print,'Rotation about Z axis.......'
Printf,lg,'Rotation about Z axis.......'
BZmain1 = BZmain
Sz1 = Sz
Ez1 = Ez
dBz1 = dBz
BYmain1 = BYmain*cos(phi)-BXmain*sin(phi)
Ey1 = Ey*cos(phi) - Ex*sin(phi)
Sy1 = Sy*cos(phi)-Sx*sin(phi)
dBy1 = dBy*cos(phi)-dBx*sin(phi)
BXmain1 = BXmain*cos(phi)+BYmain*sin(phi)
dBx1 = dBx*cos(phi)+dBy*sin(phi)
Ex1 = Ex*cos(phi)+Ey*sin(phi)
Sx1 = Sx*cos(phi)+Sy*sin(phi)
;
;*****************************************************************************
;Rotation about Y1 through theta to X2Y2Z2
;
WIDGET_CONTROL, state.text,SET_VALUE = 'Rotation about Y1 axis.......',/append
Print,'Rotation about Y1 axis ...........'
printf,lg,'Rotation about Y1 axis.......'
BYmain2 = BYmain1
Ey2 = Ey1
Sy2 = Sy1
dBy2 = dBy1
BXmain2 = BXmain1*cos(theta)-BZmain1*sin(theta)
dBx2 = dBx1*cos(theta)-dBz1*sin(theta)
Ex2 = Ex1*cos(theta)-Ez1*sin(theta)
Sx2 = Sx1*cos(theta)-Sz1*sin(theta)
dBz2 = dBz1*cos(theta)-dBx1*sin(theta)
Ez2 = Ez1*cos(theta)+Ex1*sin(theta)
Sz2 = Sz1*cos(theta)+Sx1*sin(theta)
BZmain2 = BZmain1*cos(theta)+BXmain1*sin(theta)
;******************************************************************************
;Rotate X2Y2Z2 about Z2 through -phi to X3Y3Z3
;
WIDGET_CONTROL, state.text,SET_VALUE = 'Rotation about Z2 axis.......',/append
Print,'Rotation about Z2 axis ..........'
Printf,lg,'Rotation about Z2 axis.......'
BZmain3 = BZmain2
Sz3 = Sz2
Ez3 = Ez2
dBz3 = dBz2
BYmain3 = BYmain2*cos(-phi)-BXmain2*sin(-phi)
Ey3 = Ey2*cos(-phi) - Ex2*sin(-phi)
Sy3 = Sy2*cos(-phi)-Sx2*sin(-phi)
dBy3 = dBy2*cos(-phi)-dBx2*sin(-phi)
BXmain3 = BXmain2*cos(-phi)+BYmain2*sin(-phi)
dBx3 = dBx2*cos(-phi)+dBy2*sin(-phi)
Ex3 = Ex2*cos(-phi)+Ey2*sin(-phi)
Sx3 = Sx2*cos(-phi)+Sy2*sin(-phi)
;
;******************************************************************************
;Passing rotated values to variables
;
;Print,'Passing values .........'
;Ex=Ex2
;Ey=Ey2
;Ez=Ez2
;dBxn=dBx2
;dByn=dBy2
;dBzn=dBz2
;Bxmain = Bxmain2
;Bymain = Bymain2
;Bzmain = Bzmain2
;

;******************************************************************************
;Passing rotated values to variables
;
WIDGET_CONTROL, state.text,SET_VALUE = 'Passing values .........',/append
Print,'Passing values .........'
cm_val.(1)=Ex3
cm_val.(2)=Ey3
cm_val.(3)=Ez3
cm_val.(4)=dBx3
cm_val.(5)=dBy3
cm_val.(6)=dBz3
cm_val.(7)=Bxmain3
cm_val.(8)=Bymain3
cm_val.(9)=Bzmain3
cm_val.(11)=Sx3
cm_val.(12)=Sy3
cm_val.(13)=Sz3

Ex=0.0
Ex3=0.0
Ex2=0.0
Ex1=0.0
Ey=0.0
Ey3=0.0
Ey2=0.0
Ey1=0.0
Ez=0.0
Ez3=0.0
Ez2=0.0
Ez1=0.0
dBx=0.0
dBx3=0.0
dBx2=0.0
dBx1=0.0
dBy=0.0
dBy3=0.0
dBy2=0.0
dBy1=0.0
dBz=0.0
dBz3=0.0
dBz2=0.0
dBz1=0.0
Bxmain = 0.0
Bxmain3=0.0
Bxmain2 =0.0
Bxmain1=0.0
Bymain =0.0
Bymain3=0.0
Bymain2 =0.0
Bymain1=0.0
Bzmain =0.0
Bzmain3=0.0
Bzmain2 =0.0
Bzmain1=0.0
Sx=0.0
Sx3=0.0
Sx2=0.0
Sx1=0.0
Sx=0.0
Sy3=0.0
Sy2=0.0
Sy1=0.0
Sz=0.0
Sz3=0.0
Sz2=0.0
Sz1=0.0
;print,n_elements(cm_val.(13))
;stop
;plot,cm_val.(13),xstyle=1,nsum=5
;stop
;
WIDGET_CONTROL, state.text,SET_VALUE = 'Done',/append
Free_Lun,lg
end