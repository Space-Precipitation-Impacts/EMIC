; Cross Phase Statistics for auto-detection
;
; C. L. Waters, August, 2004
;
; Given a 2-D array of cross phase values, this
; procedure returns a 2-D arrays of the statistics at each cell
; of the dynamic cross phase array
; INPUTS:
; XPhArr    : XPh data as (NBlocs,NFreqs)
; LevX      : Number of time blocks to Avg over
; LevY      : Number of Freq blocks to average over
; OUTPUTS:
; AvgXPh    : Array(NBlocs,NFreqs) of Average XPh
; tstat     : Array of t stat = AvgXph/StdDev
;
Pro do_XPh_stats,XphArr,LevX,LevY,AvgXph,tstat
 Lev=LevX
 If LevY lt Lev Then Lev=LevY   ; Check for min Lev
 If (Lev gt 0) Then $           ; Check for Level 0
 Begin
  Sz=Size(XphArr)
  Nx=Sz(1)
  Ny=Sz(2)
  AvgXph=DblArr(Nx,Ny)          ; Define Avg array
  tstat= DblArr(Nx,Ny)          ; Define t_stat array
  SxSz=2*LevX+1                 ; Calc grid size in X dir
  SySz=2*LevY+1                 ; Calc grid size in Y dir
  Sel=DblArr(SxSz*SySz)         ; Tmp storage for grid
  For i=LevX,Nx-LevX-1 do $     ; Scan along time axis
  Begin
   For j=LevY,Ny-LevY-1 do $    ; Scan along frequency axis
   Begin
    cnt=0
    For A=0,SySz-1 do $
    Begin
     For B=0,SxSz-1 do $
     Begin
      Sel(cnt)=XphArr(i+B-LevX,j+A-LevY)   ; Collect Xph values in Sel array
      cnt=cnt+1
     end
    end      ; Completes SSz X SSz loop
    sta=moment(Sel)                        ; sta(0)=mean, sta(1)=Var,
    AvgXph(i,j)=sta(0)
;    AvgXph(i,j)=median(Sel)
    tstat(i,j)=sta(0)/(sqrt(sta(1)))        ; Avg/SD
   end       ; freq scan
  end        ; time axis scan
 end         ; if Lev gt 0
end