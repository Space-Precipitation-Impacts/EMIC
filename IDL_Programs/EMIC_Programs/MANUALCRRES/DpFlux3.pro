Pro DPFlux3,state,cm_val,cm_eph,Dat5
winnum=1
SInt=1./32.
sig=0.5  ; for interp. spline
NPnts=n_elements(cm_val.(0))
ExDat=DblArr(2,NPnts)
 ExDat(0,*)=cm_val.(0)/1000.
 ExDat(1,*)=cm_val.(1)
EyDat=DblArr(2,NPnts)
 EyDat(0,*)=cm_val.(0)/1000.
 EyDat(1,*)=cm_val.(2)
EzDat=DblArr(2,NPnts)
 EzDat(0,*)=cm_val.(0)/1000.
 EzDat(1,*)=cm_val.(3)
 bxDat=DblArr(2,NPnts)
 bxDat(0,*)=cm_val.(0)/1000.
 bxDat(1,*)=cm_val.(4)
 byDat=DblArr(2,NPnts)
 byDat(0,*)=cm_val.(0)/1000.
 byDat(1,*)=cm_val.(5)
 bzDat=DblArr(2,NPnts)
 bzDat(0,*)=cm_val.(0)/1000.
 bzDat(1,*)=cm_val.(6)
; Get Min Time
MnT=DblArr(6)
MnT(0)=Min(ExDat(0,*))
MnT(1)=Min(EyDat(0,*))
MnT(2)=Min(EzDat(0,*))
MnT(3)=Min(bxDat(0,*))
MnT(4)=Min(byDat(0,*))
MnT(5)=Min(bzDat(0,*))
MinTime=Min(MnT)
TotTime=Max(ExDat(0,*))-MinTime
NPnts=TotTime/SInt
TArr=DblArr(NPnts)
; Construct time base
For ii=0,NPnts-1 do TArr(ii)=MinTime+float(ii)*SInt
; Get space for PFLux in time domain
PFluxArr=DblArr(3,NPnts)
; Spline Time Domain Data onto Time Base
TmpEx=spline(ExDat(0,*),ExDat(1,*),TArr,sig)
TmpEy=spline(EyDat(0,*),EyDat(1,*),TArr,sig)
TmpEz=spline(EzDat(0,*),EzDat(1,*),TArr,sig)
Tmpbx=spline(bxDat(0,*),bxDat(1,*),TArr,sig)
Tmpby=spline(byDat(0,*),byDat(1,*),TArr,sig)
Tmpbz=spline(bzDat(0,*),bzDat(1,*),TArr,sig)
; Find S
PFluxArr(0,*)=TmpEy*Tmpbz-TmpEz*Tmpby  ; X
PFluxArr(1,*)=TmpEz*Tmpbx-TmpEx*Tmpbz  ; Y
PFluxArr(2,*)=TmpEx*Tmpby-TmpEy*Tmpbx  ; Z
; Set up Analysis parameters
end