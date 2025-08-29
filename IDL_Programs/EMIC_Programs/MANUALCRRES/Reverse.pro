Pro Reverse,XDat,YDat,LenX
 Print,'Reversing Data...'
 Wait,0.5
 For i=Long(0),Long(LenX-1) do $
  YDat(i)=XDat(LenX-i-1)
 XDat=YDat
 For i=Long(0),Long(LenX-1) do $
  YDat(i)=0
end
