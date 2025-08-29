; Cross Phase Median filtering Procedure
;
; C. L. Waters, January, 2004
;
; Given a 2-D array of cross phase values, this
; procedure returns a 2-D array that has been median filtered
; based on nearest neighbour values. The filtering is based on
; Median Filter Levels:
; Level 0 : No filtering - array is unchanged
; Level 1 : 3x3 grid filter
; Level 2 : 5x5 grid filter
; Level 3 : 7x7 grid filter etc.
;
; This must be called BEFORE Cross Power Cutoff
;
Pro XPhMed,XphArr,LevX,LevY,NoPh
; Print,'In XPhMed, Lev=',Lev
 Lev=LevX
 If LevY lt Lev Then Lev=LevY   ; Check for min Lev
 If (Lev gt 0) Then $           ; Check for Level 0
 Begin
  Sz=Size(XphArr)
  Nx=Sz(1)
  Ny=Sz(2)
  ArrTmp=DblArr(Nx,Ny)          ; Work with temporary array
  For i=0,Nx-1 do $             ; Initialise ArrTmp with no plot phase value
  Begin
   For j=0,Ny-1 do ArrTmp(i,j)=NoPh
  end
  SxSz=2*LevX+1                   ; Calc grid size in X dir
  SySz=2*LevY+1                   ; Calc grid size in Y dir
  Sel=DblArr(SxSz*SySz)           ; Tmp storage for grid
  For i=LevX,Nx-SxSz-1 do $        ; Scan along time axis
  Begin
   For j=LevY,Ny-SySz-1 do $       ; Scan along frequency axis
   Begin
    cnt=0
    For A=0,SxSz-1 do $
    Begin
     For B=0,SySz-1 do $
     Begin
      Sel(cnt)=XphArr(i+B-LevX,j+A-LevY)
      cnt=cnt+1
     end
    end      ; Completes SSz X SSz loop
;    If (Cnt GE Indx) Then ArrTmp(i,j)=XPhArr(i,j)
    ArrTmp(i,j)=median(Sel)
   end       ; freq scan
  end        ; time axis scan
  For i=0,Nx-1 do $
  Begin
   For j=0,Ny-1 do XphArr(i,j)=ArrTmp(i,j)
  end
 end         ; if Lev gt 0
end