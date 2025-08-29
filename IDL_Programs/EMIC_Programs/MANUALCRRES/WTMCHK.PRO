; This is a time series plotting program modified from
; WTMSER.PRO to check the SPWG data base conversion process
; before writing it all to CD-ROM. The maximum number
; plots in the stack is set by NPlts
;
; Outline of the code is:
; 1. Select the day to be viewed
; 2. Search for all data for this day
; 3. Plot and user may select print to postscript
;
; Colin Waters
; SPWG, Uni of Newcastle
; Department of Physics
;
; Modification History:
; Written : Feb, 1998
;
Function XTLab,Axis,Index,Value
 Sec=Value
 Hr=Long(Sec/3600.)
 Mn=Long(Sec-3600*Hr)/60
 Sc=Sec Mod 60
Return,String(hr,mn,sc,$
   Format="(I2.2,':',I2.2,':',i2.2)")
end
;
Pro DteStr,Yr,Mon,Dy,DStr
 YrStr=StrTrim(String(Yr),2)
 MnStr=StrTrim(String(Mon),2)
 If Mon LT 10 Then MnStr='0'+MnStr
 DyStr=StrTrim(String(Dy),2)
 If Dy LT 10 Then DyStr='0'+DyStr
 DStr=DyStr+'/'+MnStr+'/'+YrStr
end
;
PRO Sec2Time,NSec,Hr,Mn,Sc
 Hr=Long(NSec/3600.)
 Mn=Long((NSec-Hr*3600)/60.)
 Sc=NSec-(Hr*3600+Mn*60)
end
;
PRO Time2Sec,NSec,Hr,Mn,Sc
 NSec=Long(Hr*3600.)+Long(Mn*60.)+Long(Sc)
end
;
PRO ChkTDiff,SHr,SMn,SSc,EHr,EMn,ESc,NSc
 FTm=Long(0)
 STm=Long(0)
 Time2Sec,STm,SHr,SMn,SSc
 Time2Sec,FTm,EHr,EMn,ESc
 NSc=Long(FTm-STm)
end
;
Function YLab,Axis,Index,Value
COMMON BLKYL,Stat,Mn,Mx,MxFN
StatLab=' '
If (Index EQ 0) Then StatLab=Strtrim(String(Mn),2)+'  '
If (Index EQ 1) Then StatLab=Stat[0]
If (Index EQ 2) Then StatLab=Strtrim(String(Mx),2)+'  '
If (Index EQ 3) Then StatLab=Stat[1]
If (Index EQ 5) Then StatLab=Stat[2]
If (Index EQ 7) Then StatLab=Stat[3]
If (Index EQ 9) Then StatLab=Stat[4]
If (Index EQ 11) Then StatLab=Stat[5]
If (Index EQ 13) Then StatLab=Stat[6]
;print,'YLAb : ',index,value
Return,String(StatLab,Format="(A7)")
end
;
PRO timeax,xlow,xhigh,xticks,xtickv,xtickname,xminor
;
;  J.C. Samson,   February, 1994
;  Version 1.02
; procedure timeax provides arrays of
; tick values and tick names for a time axis
; given xlow and xhigh in hours
; #hours is calculated by subtracting xhigh-xlow
; xtickv and tickname can be used in the plot procedure
; xtickv and tickname have length "xticks+1"
;
xrng=xhigh-xlow
If xrng Lt 1.0/6.0 Then $
Begin
 xminor=4
 xticks=4
 minstep=xrng/float(xticks)
 xtickv=fltarr(xticks+1)
 xtickname=strarr(xticks+1)
 For i=0,xticks do $
 Begin
  time=xlow+float(i)*minstep
  xtickv(i)=time
  xtickname(i)=tim(time)
 end
endif else $
Begin
 If xrng Lt 0.5 Then $
 Begin
  xminc=[':00',':05',':10',':15',':20',':25',':30', $
         ':35',':40',':45',':50',':55']
  minstep=5.0/60.0
  xminor=5
 endif else $
 Begin
  xminc=[':00',':15',':30',':45']
  minstep=15.0/60.0
  xminor=3
 endelse
 xhrc=[' 0',' 1',' 2',' 3',' 4',' 5',' 6', $
      ' 7',' 8',' 9','10','11','12','13', $
      '14','15','16','17','18','19','20', $
      '21','22','23','24']
;
; minstep and xminc should be consistent
;
; Determine the ticks and step intervals
;
 n=fix(alog(xrng/(minstep*8))/alog(2))+1
 step=2^n*minstep
 If step Gt 0.5 then xminor=4
 xstart=float(fix((xlow-0.001)/step+1))*step
 numticks=fix((xhigh-xstart)/step)+1
 xticks=numticks-1
 xtickname=strarr(numticks)
 xtickv=fltarr(numticks)
 For j=0,xticks do $
 Begin
  xtickv(j)=xstart+float(j)*step
  kminute=fix((xtickv(j)-fix(xtickv(j)))/minstep+0.0001)
  khour=fix(xtickv(j))
  If khour Ge 24 then khour=khour-24
  xtickname(j)=xhrc(khour)+xminc(kminute)
 end
endelse
END
;
PRO MnDy2DyNum,Yr,Mn,Dy,DNum
 Mnth=IntArr(12)
 Mnth[0]=31 & Mnth[1]=28 & Mnth[2]=31 & Mnth[3]=30
 Mnth[4]=31 & Mnth[5]=30 & Mnth[6]=31 & Mnth[7]=31
 Mnth[8]=30 & Mnth[9]=31 & Mnth[10]=30 & Mnth[11]=31
 DNum=Dy
 For i=0,Mn-2 do DNum=DNum+Mnth[i]
end
;
PRO GetFName,Yr,Mn,Dy,DPth,StIn,StOut,Fd
; Input - Yr,Mn,Dy,St,StIn
; Output - DPth,StOut,Fd
 YrSr=Yr-1900
 DyNum=1
 Pth='D:\'+StIn   ; CD ROM Drive Letter HERE
; Catch,ErrStat
 cd,Pth
; If ErrStat NE 0 Then $
; Begin
;  Print,'Directory not found: ',Pth
;  Catch,ErrStat,/Cancel
; end
; Print,'Directory is ',Pth
 MnDy2DyNum,Yr,Mn,Dy,DyNum
 DyNStr=StrTrim(String(DyNum),2)
 If DyNum LT 10 Then DyNStr='00'+DyNStr
 If DyNum GT 9 Then $
 Begin
  If DyNum LT 100 Then DyNStr='0'+DyNStr
 end
 Srch=Pth+'\'+StIn+'X?'+DyNStr+'.?'+StrTrim(String(YrSr),2)
; Print,'Search String = ',Srch
 Fn=FindFile(Srch)
 If Fn[0] NE '' Then Begin
  Fd=1
  DPth=Fn
  Posn=StrPos(Fn,'.')
  StOut=StrMid(Fn,Posn[0]-8,4)
 end
end
;
PRO ChkDate,Yr,Year,Mn,Month,Dy,Day,NewPlot
 NewPlot=1
 If Year EQ Yr Then $
  If Month EQ Mn Then $
   If Day EQ Dy Then NewPlot=0
end
;
PRO AdjTime_event, ev
 Common Blk1,HrArr,MnArr,ScArr,SInt,NPnts,NPlts,Stat,Plt
 Common Blk2,SNHr,SNMn,SNSc,ENHr,ENMn,ENSc,MnTme,MxTme
 Common Blk3,FSArr,FEArr,DArr,XAx,MnY,MxY,RStat
 Common Blk4,SFRSw,EFRSw,Year,Month,Day,yr,mn,dy
 Common Blk5,SHrBut,SMnBut,SScBut,EHrBut,EMnBut,EScBut
 Common BlkYL,Sta,MnR,MxR,FN
 IFmt=1 ; CLW
 Sta=Stat & FN=NPlts
 Widget_Control,ev.id,Get_UValue=uval
 Sec2Time,MxTme,MxHr,MxMn,MxSc
 Sec2Time,MnTme,MnHr,MnMn,MnSc
 SH=SNHr & SM=SNMn & SS=SNSc
 EH=ENHr & EM=ENMn & ES=ENSc
 TDiff=Long(0)
 Case uval of
 'SFR' : Begin
          DmFR=SFRSw
          If DmFR EQ 'F' Then $
          Begin
           SFRSw='R'
           Widget_Control,ev.id,Set_Value='Reverse'
          end
          If DmFR EQ 'R' Then $
          Begin
           SFRSw='F'
           Widget_Control,ev.id,Set_Value='Forward'
          end
         end
 'YER' : Begin
          If SFRSw EQ 'F' Then Year=Year+1
          If SFRSw EQ 'R' Then Year=Year-1
          Widget_Control,ev.id,Set_Value='Year :'+StrTrim(String(Year),2)
         end
 'MNT' : Begin
          If SFRSw EQ 'F' Then Month=Month+1
          If SFRSw EQ 'R' Then Month=Month-1
          If Month GT 12 Then Month=1
          If Month LE 0 Then Month=12
          Widget_Control,ev.id,Set_Value='Month :'+StrTrim(String(Month),2)
         end
 'DAY' : Begin
          If SFRSw EQ 'F' Then Day=Day+1
          If SFRSw EQ 'R' Then Day=Day-1
          If Day GT 31 Then Day=1
          If Day LE 0 Then Day=31
          Widget_Control,ev.id,Set_Value='Day :'+StrTrim(String(Day),2)
         end
 'SHR' : Begin
          If SFRSw EQ 'F' Then SNHr=SNHr+1
          If SFRSw EQ 'R' Then SNHr=SNHr-1
          Tm=Long(0)
          Time2Sec,Tm,SNHr,SNMn,SNSc
       ; Make a multiple of SInt
          t2=Long((Tm-MnTme)/SInt[Plt])
          t1=Long(MnTme)+Long(t2*SInt[Plt])
          Sec2Time,t1,SNHr,SNMn,SNSc
       ; Check for Time < Data Start Time
          If Tm LT MnTme Then $
          Begin
           Msg=Dialog_Message('Time is Before Data Starts')
           SNHr=SH & SNMn=SM & SNSc=SS
          end
       ; Make sure STime is at least 1 hr < ETime
          If Tm GE MnTme Then $
          Begin
           ChkTDiff,SNHr,SNMn,SNSc,ENHr,ENMn,ENSc,TDiff
           If TDiff LT 3600 Then $
           Begin
            SNHr=SH & SNMn=SM & SNSc=SS
            Msg=Dialog_Message('Less than 1hr of Data Selected')
           end
          end
          Widget_Control,ev.id, Set_Value='HR : '+HrArr[0,SNHr]
          Widget_Control,SMnBut,Set_Value='MN : '+MnArr[0,SNMn]
          Widget_Control,SScBut,Set_Value='SC : '+ScArr[0,SNSc]
         end
 'SMN' : Begin
          If SFRSw EQ 'F' Then SNMn=SNMn+1
          If SFRSw EQ 'R' Then SNMn=SNMn-1
          If SNMn GT 59 Then $
          Begin
           SNHr=SNHr+1
           SNMn=SNMn-60
          end
          If SNMn LT 0 Then $
          Begin
           SNHr=SNHr-1
           SNMn=SNMn+60
          end
          Tm=Long(0)
          Time2Sec,Tm,SNHr,SNMn,SNSc
       ; Make a multiple of SInt
          t2=Long((Tm-MnTme)/SInt[Plt])
          t1=Long(MnTme)+Long(t2*SInt[Plt])
          Sec2Time,t1,SNHr,SNMn,SNSc
       ; Check for Time < Data Start Time
          If Tm LT MnTme Then $
          Begin
           Msg=Dialog_Message('Time is Before Data Starts')
           SNHr=SH & SNMn=SM & SNSc=SS
          end
       ; Make sure STime is at least 1 hr < ETime
          If Tm GE MnTme Then $
          Begin
           ChkTDiff,SNHr,SNMn,SNSc,ENHr,ENMn,ENSc,TDiff
           If TDiff LT 3600 Then $
           Begin
            SNHr=SH & SNMn=SM & SNSc=SS
            Msg=Dialog_Message('Less than 1hr of Data Selected')
           end
          end
          Widget_Control,SHrBut,Set_Value='HR : '+HrArr[0,SNHr]
          Widget_Control,ev.id,Set_Value='MN : '+MnArr[0,SNMn]
          Widget_Control,SScBut,Set_Value='SC : '+ScArr[0,SNSc]
         end
 'SSC' : Begin
          If SFRSw EQ 'F' Then SNSc=SNSc+Fix(SInt[Plt])
          If SFRSw EQ 'R' Then SNSc=SNSc-Fix(SInt[Plt])
          If SNSc GT 59 Then $
          Begin
           SNMn=SNMn+1
           If SNMn GT 59 Then $
           Begin
            SNHr=SNHr+1
            SNMn=SNMn-60
           end
           SNSc=SNSc-60
          end
          If SNSc LT 0 Then $
          Begin
           SNMn=SNMn-1
           If SNMn LT 0 Then $
           Begin
            SNHr=SNHr-1
            SNMn=SNMn+60
           end
           SNSc=SNSc+60
          end
          Tm=Long(0)
          Time2Sec,Tm,SNHr,SNMn,SNSc
       ; Make a multiple of SInt
          t2=Long((Tm-MnTme)/SInt[Plt])
          t1=Long(MnTme)+Long(t2*SInt[Plt])
          Sec2Time,t1,SNHr,SNMn,SNSc
       ; Check for Time < Data Start Time
          If Tm LT MnTme Then $
          Begin
           Msg=Dialog_Message('Time is Before Data Starts')
           SNHr=SH & SNMn=SM & SNSc=SS
          end
       ; Make sure STime is at least 1 hr < ETime
          If Tm GE MnTme Then $
          Begin
           ChkTDiff,SNHr,SNMn,SNSc,ENHr,ENMn,ENSc,TDiff
           If TDiff LT 3600 Then $
           Begin
            SNHr=SH & SNMn=SM & SNSc=SS
            Msg=Dialog_Message('Less than 1hr of Data Selected')
           end
          end
          Widget_Control,SHrBut,Set_Value='HR : '+HrArr[0,SNHr]
          Widget_Control,SMnBut,Set_Value='MN : '+MnArr[0,SNMn]
          Widget_Control,ev.id,Set_Value='SC : '+ScArr[0,SNSc]
         end
 'EFR' : Begin
          DmFR=EFRSw
          If DmFR EQ 'F' Then $
          Begin
           EFRSw='R'
           Widget_Control,ev.id,Set_Value='Reverse'
          end
          If DmFR EQ 'R' Then $
          Begin
           EFRSw='F'
           Widget_Control,ev.id,Set_Value='Forward'
          end
         end
 'EHR' : Begin
          If EFRSw EQ 'F' Then ENHr=ENHr+1
          If EFRSw EQ 'R' Then ENHr=ENHr-1
          Tm=Long(0)
          Time2Sec,Tm,ENHr,ENMn,ENSc
       ; Make a multiple of SInt
          t2=Long((Tm-MnTme)/SInt[Plt])
          t1=Long(MnTme)+Long(t2*SInt[Plt])
          Sec2Time,t1,ENHr,ENMn,ENSc
       ; Check for Time > Data End Time
          If Tm GT MxTme Then $
          Begin
           Msg=Dialog_Message('Time is Past End of Data')
           ENHr=EH & ENMn=EM & ENSc=ES
          end
       ; Make sure ETime is at least 1 hr > STime
          If Tm LE MxTme Then $
          Begin
           ChkTDiff,SNHr,SNMn,SNSc,ENHr,ENMn,ENSc,TDiff
           If TDiff LT 3600 Then $
           Begin
            ENHr=EH & ENMn=EM & ENSc=ES
            Msg=Dialog_Message('Less than 1hr of Data Selected')
           end
          end
          Widget_Control,ev.id, Set_Value='HR : '+HrArr[1,ENHr]
          Widget_Control,EMnBut,Set_Value='MN : '+MnArr[1,ENMn]
          Widget_Control,EScBut,Set_Value='SC : '+ScArr[1,ENSc]
         end
 'EMN' : Begin
          If EFRSw EQ 'F' Then ENMn=ENMn+1
          If EFRSw EQ 'R' Then ENMn=ENMn-1
          If ENMn GT 59 Then $
          Begin
           ENHr=ENHr+1
           ENMn=ENMn-60
          end
          If ENMn LT 0 Then $
          Begin
           ENHr=ENHr-1
           ENMn=ENMn+60
          end
          Tm=Long(0)
          Time2Sec,Tm,ENHr,ENMn,ENSc
       ; Make a multiple of SInt
          t2=Long((Tm-MnTme)/SInt[Plt])
          t1=Long(MnTme)+Long(t2*SInt[Plt])
          Sec2Time,t1,ENHr,ENMn,ENSc
       ; Check for Time > Data end
          If Tm GT MxTme Then $
          Begin
           Msg=Dialog_Message('Time is Past End of Data')
           ENHr=EH & ENMn=EM & ENSc=ES
          end
       ; Make sure STime is at least 1 hr < ETime
          If Tm LE MxTme Then $
          Begin
           ChkTDiff,SNHr,SNMn,SNSc,ENHr,ENMn,ENSc,TDiff
           If TDiff LT 3600 Then $
           Begin
            ENHr=EH & ENMn=EM & ENSc=ES
            Msg=Dialog_Message('Less than 1hr of Data Selected')
           end
          end
          Widget_Control,EHrBut,Set_Value='HR : '+HrArr[1,ENHr]
          Widget_Control,ev.id,Set_Value='MN : '+MnArr[1,ENMn]
          Widget_Control,EScBut,Set_Value='SC : '+ScArr[1,ENSc]
         end
 'ESC' : Begin
          If EFRSw EQ 'F' Then ENSc=ENSc+Fix(SInt[Plt])
          If EFRSw EQ 'R' Then ENSc=ENSc-Fix(SInt[Plt])
          If ENSc GT 59 Then $
          Begin
           ENMn=ENMn+1
           If ENMn GT 59 Then $
           Begin
            ENHr=ENHr+1
            ENMn=ENMn-60
           end
           ENSc=ENSc-60
          end
          If ENSc LT 0 Then $
          Begin
           ENMn=ENMn-1
           If ENMn LT 0 Then $
           Begin
            ENHr=ENHr-1
            ENMn=ENMn+60
           end
           ENSc=ENSc+60
          end
          Tm=Long(0)
          Time2Sec,Tm,ENHr,ENMn,ENSc
       ; Make a multiple of SInt
          t2=Long((Tm-MnTme)/SInt[Plt])
          t1=Long(MnTme)+Long(t2*SInt[Plt])
          Sec2Time,t1,ENHr,ENMn,ENSc
       ; Check for Time > Data end
          If Tm GT MxTme Then $
          Begin
           Msg=Dialog_Message('Time is Past End of Data')
           ENHr=EH & ENMn=EM & ENSc=ES
          end
       ; Make sure STime is at least 1 hr < ETime
          If Tm LE MxTme Then $
          Begin
           ChkTDiff,SNHr,SNMn,SNSc,ENHr,ENMn,ENSc,TDiff
           If TDiff LT 3600 Then $
           Begin
            ENHr=EH & ENMn=EM & ENSc=ES
            Msg=Dialog_Message('Less than 1hr of Data Selected')
           end
          end
          Widget_Control,EHrBut,Set_Value='HR : '+HrArr[1,ENHr]
          Widget_Control,EMnBut,Set_Value='MN : '+MnArr[1,ENMn]
          Widget_Control,ev.id,Set_Value='SC : '+ScArr[1,ENSc]
         end
 'PLOT': Begin
          ChkDate,Yr,Year,Mn,Month,Dy,Day,NewPlot ;Check for different Day
          Yr=Year & Mn=Month & Dy=Day
          If NewPlot EQ 1 Then $
          Begin
           Fna=StrArr(10) & Sz=Size(Stat)
           NPs=Long(0) & NPlts=0 & Pth='' & VStat=''
           For ii=0,Sz(1)-1 do $
           Begin
            Fnd=0
            GetFName,Year,Month,Day,Pth,Stat[ii],VStat,Fnd
            If Fnd EQ 1 Then $
            Begin
             Print,'Files Found : ',Pth
             Fna[NPlts]=Pth
             RStat[NPlts]=VStat
             NPlts=NPlts+1
            end
           end
           If NPlts EQ 0 Then Msg=Dialog_Message('No Data for this Day')
           If NPlts GT 0 Then $
           Begin
            NewPlot=1 & SampI=1.0
            TmpArr=DblArr(1)
            StdFRead,Fna[0],TmpArr,SampI,NPs
            SInt[0]=SampI
            NPnts[0]=NPs
            SzD=Size(TmpArr)
            DArr=DblArr(86400,NPlts)  ; Limit to 1 Day at 1 Hz
            For jj=Long(0),Long(NPs)-1 do DArr[jj,0]=TmpArr[jj]
            For ii=1,NPlts-1 do $
            Begin
             StdFRead,Fna[ii],TmpArr,SampI,NPs
             SInt[ii]=SampI
             NPnts[ii]=NPs
             For jj=Long(0),Long(NPs)-1 do DArr[jj,ii]=TmpArr[jj]
            end
            MnTme=0
           end    ;if NPlts GT 0
          end     ;if NewPlot
          If NPlts GT 0 Then $
          Begin
           Time2Sec,SBTime,Long(SNHr),Long(SNMn),Long(SNSc)
           Time2Sec,EBTime,Long(ENHr),Long(ENMn),Long(ENSc)
           XAx=LonArr(Max(NPnts))
           FSInt=100.0
           For ii=0,NPlts-1 do $
           Begin
            If SInt[ii] NE 0.0 Then $
             If FSInt GT SInt[ii] Then FSInt=SInt[ii]
           end
           Strt=LonArr(NPlts) & Fin=LonArr(NPlts)
           For kk=0,NPlts-1 do $
           Begin
            Strt[kk]=Long((SBTime-MnTme)/SInt[kk])
            Fin[kk] =Long((EBTime-MnTme)/SInt[kk])-1
           end
           YWnSz=150+(NPlts-1)*40
           MnnY=Min(DArr[Strt[0]:Fin[0],*]) & MxxY=Max(DArr[Strt[0]:Fin[0],*])
           Ampl=Abs(MnnY)
           If Ampl LT MxxY Then Ampl=MxxY
           YRange=[-Ampl,(2.0*NPlts+1.0)*Ampl]
           Window,0,XSize=650,YSize=YWnSz,Title='Magnetometer Time Series'
           DteStr,Year,Month,Day,Ttle
           Ttle='Data for '+Ttle
           For i=Long(0),Long(NPnts[0]-1) do XAx(i)=Long(MnTme)+i*SInt[0]
           Plot,XAx[Strt[0]:Fin[0]],DArr[Strt[0]:Fin[0],0],$
            YRange=YRange,YStyle=1,Title=Ttle, $
            XStyle=1,XTickFormat='XTLab',XTitle='Time'
            XYOuts,SBTime,MAx(DArr[0:100,0]),RStat[0],/Data
            YOffs=0.0
           For k=1,NPlts-1 do $
           Begin
            YOffs=YOffs+Ampl*2.0
            For i=Long(0),Long(Max(NPnts[k])-1) do XAx(i)=Long(MnTme)+i*SInt[k]
            OPlot,XAx,YOffs+DArr[Strt[k]:Fin[k],k]
            XYOuts,SBTime,YOffs+Max(DArr[0:100,k]),RStat[k],/Data
           end
          end
         end
 'PRN' : Begin
          If NPlts EQ 0 Then Msg=Dialog_Message('No Data Selected for this Day')
          If NPlts GT 0 Then $
          Begin
           WSet,0
           XYOuts,40,20,'Printing...',/Device,color=!D.N_Colors-1
           Set_Plot,'PS'
           YWnSz=150+(NPlts-1)*40
           YSz=Float(YWnSz)/500.0*16.0          ;plot height in cm
           Device,Filename='E:\CLW\TSPLOT.PS',$
           XOffset=2,YOffset=10,XSize=15,YSize=YSz
           Time2Sec,SBTime,Long(SNHr),Long(SNMn),Long(SNSc)
           Time2Sec,EBTime,Long(ENHr),Long(ENMn),Long(ENSc)
           Strt=LonArr(NPlts) & Fin=LonArr(NPlts)
           For kk=0,NPlts-1 do $
           Begin
            Strt[kk]=Long((SBTime-MnTme)/SInt[kk])
            Fin[kk] =Long((EBTime-MnTme)/SInt[kk])-1
           end
           xstart=Float(SNHr)+Float(SNMn)/60.+SNSc/3600.
           xend=Float(ENHr)+Float(ENMn)/60.+ENSc/3600.
           XRange=[xstart,xend]
           MnnY=Min(DArr[Strt[0]:Fin[0],*])
           MxxY=Max(DArr[Strt[0]:Fin[0],*])
           Ampl=Abs(MnnY)
           If Ampl LT MxxY Then Ampl=MxxY
           YRange=[-Ampl,(2.0*NPlts-1.0)*Ampl]
           XLabel='Time UT'
           Label=String((fix(Day)),string(fix(Month)),$
            string(fix(Year)),format="(I2.2,'/',I2.2,'/',I4.2,'   (Amplitude: nT)')")
           ;label='Amplitude: nT'
           TIMEAX, xstart,xend,xticks,xtickv,xtickname,xminor
           nonames=strarr(xticks+1)
           For i=0,xticks do nonames(i)=' '
           yticks=2*NPlts
           ytickv=FltArr(yticks)
           ytickname=StrArr(yticks)
           For i=0,yticks-1 do ytickv(i)=(i-1)*Ampl
           For i=0,yticks-1 do ytickname(i)=' '
           MnR=ytickv[0] & MxR=ytickv[2]
           jj=1
           For ii=0,yticks/2-1 do $
           Begin
            ytickname(jj)=stat(ii)
            jj=jj+2
           end
           For i=0,NPlts-1 do $
           Begin
            DSz=Fin[i]-Strt[i]+1
            xdata=FltArr(DSz)
            ydata=DblArr(DSz)
            YOffs=2.0*Float(i)*Ampl
            For j=Long(Strt[i]),Long(Fin[i]) do $
            Begin
             xdata(j-Strt[i])=MnTme/3600.0+Float(j)*SInt[i]/3600.0
             ydata(j-Strt[i])=DArr(j,i)+YOffs
            end
            print,'YOffs: ',YOffs
            If (i Eq 0) then $
            Begin
             plot,xdata,ydata,xtitle=xlabel,title=label,$
              xticks=xticks,xtickv=xtickv,xtickname=xtickname,$
              yticks=yticks,YTickFormat='YLab',$ ;ytickv=ytickv,$
              Xrange=Xrange,Yrange=Yrange,YStyle=1,xticklen=0.03,$
              xminor=xminor,charsize=0.65,charthick=2,/data
            endif else $
            oplot,xdata,ydata
           end
           Device, /close
           Print,'Finished postscript file : TSPLOT.PS.'
           Set_Plot, 'WIN'
           WSet,0
           XYOuts,40,20,'Printing...',/Device,color=0
          end
         end
 'EXIT': Begin
          OpenW,u,'e:\clw\mtmser.par',/Get_Lun
          PrintF,u,SFRsw
          PrintF,u,Year
          PrintF,u,Month
          PrintF,u,Day
          Free_Lun,u
          Widget_Control,ev.top, /Destroy
         end
 ENDCASE
END

PRO AdjTime
 Common Blk1,HrArr,MnArr,ScArr,SInt,NPnts,NPlts,Stat,Plt
 Common Blk2,SNHr,SNMn,SNSc,ENHr,ENMn,ENSc,MnTme,MxTme
 Common Blk3,FSArr,FEArr,DArr,XAx,MnY,MxY,RStat
 Common Blk4,SFRSw,EFRSw,Year,Month,Day,yr,mn,dy
 Common Blk5,SHrBut,SMnBut,SScBut,EHrBut,EMnBut,EScBut
 HrArr=StrArr(2,48)
 MnArr=StrArr(2,60)
 ScArr=StrArr(2,60)
 For j=0,1 do $
 Begin
  For i=0,47 do HrArr[j,i]=String(StrTrim(i,2),Format='(A2)')
  For i=0,59 do MnArr[j,i]=String(StrTrim(i,2),Format='(A2)')
 end
 ScArr=MnArr
 SFRSw='F' & EFRSw='R'
 base = WIDGET_BASE(/COLUMN,XSize=100)
 STxt = Widget_Text(base,value='Start Time')
 SFRBut = Widget_Button(base,value='Forward',UValue='SFR')
 YrBut = Widget_Button(base,value='Year :'+StrTrim(String(Year),2),UValue='YER')
 MnBut = Widget_Button(base,value='Month :'+StrTrim(String(Month),2),UValue='MNT')
 DyBut = Widget_Button(base,value='Day :'+StrTrim(String(Day),2),UValue='DAY')
 SHrBut = Widget_Button(base,value='HR : '+HrArr[0,SNHr],UValue='SHR')
 SMnBut = Widget_Button(base,value='MN : '+MnArr[0,SNMn],UValue='SMN')
 SScBut = Widget_Button(base,value='SC : '+ScArr[0,SNSc],UValue='SSC')
 ETxt = Widget_Text(base,value='End Time')
 EFRBut = Widget_Button(base,value='Reverse',UValue='EFR')
 EHrBut = Widget_Button(base,value='HR : '+HrArr[1,ENHr],UValue='EHR')
 EMnBut = Widget_Button(base,value='MN : '+MnArr[1,ENMn],UValue='EMN')
 EScBut = Widget_Button(base,value='SC : '+ScArr[1,ENSc],UValue='ESC')
 PltBut= Widget_Button(base,value='Plot',UValue='PLOT')
 PrnBut= Widget_Button(base,value='Print',UValue='PRN')
 ExBut = Widget_Button(base,value='Exit',UValue='EXIT')
 WIDGET_CONTROL, base, /REALIZE
 XMANAGER, 'AdjTime', base
END
;
PRO WTMCHK
 Common Blk1,HrArr,MnArr,ScArr,SInt,NPnts,NPlts,Stat,Plt
 Common Blk2,SNHr,SNMn,SNSc,ENHr,ENMn,ENSc,MnTme,MxTme
 Common Blk3,FSArr,FEArr,DArr,XAx,MnY,MxY,RStat
 Common Blk4,SFRSw,EFRSw,Year,Month,Day,yr,mn,dy
 TotPlts=10
 NStat=16
 Stat=StrArr(NStat) & RStat=StrArr(NStat)
 ;Stat[0]='ARM' & Stat[1]='GLO'
 ;Stat[2]='MUS' & Stat[3]='ORB'
 Stat[0]='ARM' & Stat[1]='AUK' & Stat[2]='CAN'
 Stat[3]='COO' & Stat[4]='DAL' & Stat[5]='DAR'
 Stat[6]='GLA' & Stat[7]='GLE' & Stat[8]='GLO'
 Stat[9]='KUL' & Stat[10]='LAU' & Stat[11]='LEM'
 Stat[12]='MAK' & Stat[13]='NEW' & Stat[14]='NWI'
 Stat[15]='ORB'
 FSArr=LonArr(TotPlts) & FEArr=LonArr(TotPlts)
 NPnts=LonArr(TotPlts) & SInt=FltArr(TotPlts)
 Set_Plot,'WIN'
 LoadCT,0
 Device,Decomposed=0
 NPlts=0 & StaL='' & SFRSw='F'
 Year=1985 & Month=1 & Day=1
 OpenR,u,'c:\clw\idl\mtmser.par',/Get_Lun
 ReadF,u,SFRsw
 ReadF,u,Year
 ReadF,u,Month
 ReadF,u,Day
 Free_Lun,u
 Yr=Year & Mn=Month & Dy=Day+1  ; Just have to be different
 Hour=0 & Min=0 & Sec=0.0
 NewPlot=1
 SNHr=0 & SNMn=0 & SNSc=0
 SSec=Long(0)
 ESec=Long(86400)
 Sec2Time,ESec,ENHr,ENMn,ENSc
 FSArr[0]=SSec & FEArr[0]=ESec
 MnTme=SSec & MxTme=ESec
 Frst=1  ; First Time Through Switch
 Plt=1   ; First Plot
 AdjTime
 If !d.window GE 0 Then WDelete,0
end