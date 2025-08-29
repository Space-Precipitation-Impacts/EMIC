; Cross Phase "Coherency" index Procedure
;
; C. L. Waters, March, 1996
;
; Given a 2-D array of cross phase values, this
; procedure returns a 2-D array that contains only
; those points that have "indx" neighbouring values
; within "PhRng". "NoPh" is the value so that no phase value
; is printed in the final plot
;
; This must be called BEFORE Cross Power Cutoff
;
Pro XPhCoh,XphArr,Indx,PhRng,NoPh
Sz=Size(XphArr)
Nx=Sz(1)
Ny=Sz(2)
ArrTmp=DblArr(Nx,Ny)
For i=0,Nx-1 do $     ; Initialise ArrTmp
Begin
 For j=0,Ny-1 do ArrTmp(i,j)=NoPh
end
Sel=DblArr(3,3)     ; 3X3 cell
For i=1,Nx-2 do $   ; Scan along time axis
Begin
 For j=1,Ny-2 do $  ; Scan along frequency axis
 Begin
  Cnt=0
  For A=0,2 do $
  Begin
   For B=0,2 do $
   Begin
    Sel(A,B)=XphArr(i,j)-XphArr(i+B-1,j+A-1)
    If (Sel(A,B) LT 0.0) Then Sel(A,B)=-Sel(A,B)   ; Make sure Sel is +ve
    If (Sel(A,B) LE PhRng) Then Cnt=Cnt+1          ; Add neighbours within PhRng
   end
  end      ; Completes 3X3 loop
  If (Cnt GE Indx) Then ArrTmp(i,j)=XPhArr(i,j)
 end
end
For i=0,Nx-1 do $
Begin
 For j=0,Ny-1 do XphArr(i,j)=ArrTmp(i,j)
end
end