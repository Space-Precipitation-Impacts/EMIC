; This is a time series plotting program that uses widgets
; to control the time interval of the plot. The maximum number
; plots in the stack is set by NPlts
;
; Colin Waters
; SPWG, Uni of Newcastle
; Department of Physics
;
; Modification History:
; Written : Dec, 1997
; Jan 1998 : Added print routine; CLW
; Feb 1999 : Added Adust Amplitude Widget; CLW
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
PRO AdjTime_event, ev
 Common Blk1,HrArr,MnArr,ScArr,FNo,SInt,NPnts,NPlts,Stat
 Common Blk2,SNHr,SNMn,SNSc,ENHr,ENMn,ENSc,MnTme,MxTme
 Common Blk3,FSArr,FEArr,DArr,TmpArr,XAx,Ampl
 Common Blk4,SFRSw,EFRSw,Year,Month,Day
 Common Blk5,SHrBut,SMnBut,SScBut,EHrBut,EMnBut,EScBut,base
 Common BlkYL,Sta,MnR,MxR,FN
 IFmt=1 ; CLW
 Sta=Stat & FN=FNo
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
 'SHR' : Begin
          If SFRSw EQ 'F' Then SNHr=SNHr+1
          If SFRSw EQ 'R' Then SNHr=SNHr-1
          Tm=Long(0)
          Time2Sec,Tm,SNHr,SNMn,SNSc
       ; Make a multiple of SInt
          t2=Long((Tm-MnTme)/SInt)
          t1=Long(MnTme)+Long(t2*SInt)
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
          t2=Long((Tm-MnTme)/SInt)
          t1=Long(MnTme)+Long(t2*SInt)
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
          If SFRSw EQ 'F' Then SNSc=SNSc+Fix(SInt)
          If SFRSw EQ 'R' Then SNSc=SNSc-Fix(SInt)
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
          t2=Long((Tm-MnTme)/SInt)
          t1=Long(MnTme)+Long(t2*SInt)
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
          t2=Long((Tm-MnTme)/SInt)
          t1=Long(MnTme)+Long(t2*SInt)
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
          t2=Long((Tm-MnTme)/SInt)
          t1=Long(MnTme)+Long(t2*SInt)
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
          If EFRSw EQ 'F' Then ENSc=ENSc+Fix(SInt)
          If EFRSw EQ 'R' Then ENSc=ENSc-Fix(SInt)
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
          t2=Long((Tm-MnTme)/SInt)
          t1=Long(MnTme)+Long(t2*SInt)
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
 'ADF' : Begin
          FNo=FNo+1
          If FNo GE NPlts Then $
          Begin
           Msg=Dialog_Message('Maximum number of Plots exceeded')
           FNo=NPlts-1
          end
          If FNo LT NPlts Then $
          Begin
           FName=Dialog_PickFile(Title='Select Data',Filter='*.*')
           StaL='' & NPs=Long(0)
           Year=1990 & Month=0 & Day=0
           OpenR,u,FName,/Get_Lun
           ReadF,u,Format='(1x,A4,5I5,1x,2F5.1,I5)',$
           StaL,Year,Month,Day,Hour,Min,Sec,SInt,NPs
           XDat=DblArr(NPs)
           ReadF,u,XDat
           Free_Lun,u
           Stat[FNo]=StaL
       ; Update NPnts Array
          NPnts[FNo]=NPs
       ; Get Start and End times in Sec from 00:00:00
           Time2Sec,STime,Long(Hour),Long(Min),Long(Sec)
           ETime=STime+Long(NPs*SInt)
           FSArr[FNo]=STime
           FEArr[FNo]=ETime
       ; Get Overall Max and Min NSec
           MxTme=Max(FEArr)
           For i=0,FNo do $
            If MnTme GT FSArr[i] Then MnTme=FSArr[i]
           MaxNP=Long((MxTme-MnTme)/SInt)
           If Max(NPnts) GT MaxNP Then MaxNP=Max(NPnts)
       ; Redefine DArr in Case NPnts change
           DArr=DblArr(FNo+1,MaxNP)
           XAx=LonArr(MaxNP)
           For i=Long(0),Long(MaxNP-1) do XAx(i)=MnTme+i*SInt
       ; Load current data file
           Strt=Long((FSArr[FNo]-MnTme)/SInt)
           For i=Strt,NPnts[FNo]-1 do DArr[FNo,i]=XDat[i]
          ; Load the rest of the Data from TmpArr
           For i=0,FNo-1 do $
           Begin
            Strt=Long((FSArr[FNo]-MnTme)/SInt) ; Can never be -ve
            For j=Strt,NPnts[i]-1 do DArr[i,j]=TmpArr[i,j]
           end
           TmpArr=DArr    ; Keep a copy of DArr
          end ; DArr now covers from MnTme to MxTme
          Time2Sec,SBTime,Long(SNHr),Long(SNMn),Long(SNSc)
          Time2Sec,EBTime,Long(ENHr),Long(ENMn),Long(ENSc)
          Strt=Long((SBTime-MnTme)/SInt)
          Fin =Long((EBTime-MnTme)/SInt)-1
          YWnSz=150+FNo*30
          YRange=[-Ampl,(2.0*FNo+1.0)*Ampl]
          Window,0,XSize=700,YSize=YWnSz,Title='Magnetometer Time Series'
          DteStr,Year,Month,Day,Ttle
          Ttle='Data for '+Ttle
          Plot,XAx[Strt:Fin],DArr[0,Strt:Fin],$
           YRange=YRange,YStyle=1,Title=Ttle, $
           XStyle=1,XTickFormat='XTLab',XTitle='Time'
          XYOuts,SBTime,MAx(DArr[0,0:100]),Stat[0],/Data
          YOffs=0.0
          For k=1,FNo do $
          Begin
           YOffs=YOffs+Ampl*2.0
           OPlot,XAx[Strt:Fin],YOffs+DArr[k,Strt:Fin]
           XYOuts,SBTime,YOffs+Max(DArr[k,0:100]),Stat[k],/Data
          end
         end
 'DDF' : Msg=Dialog_Message('Not Implemented yet')
 'ADA' : Begin
          ampadj,base,100,200,ampl
         end
 'PLOT': Begin
          Time2Sec,SBTime,Long(SNHr),Long(SNMn),Long(SNSc)
          Time2Sec,EBTime,Long(ENHr),Long(ENMn),Long(ENSc)
          Strt=Long((SBTime-MnTme)/SInt)
          Fin =Long((EBTime-MnTme)/SInt)-1
          YWnSz=150+FNo*40
          YRange=[-Ampl,(2.0*FNo+1.0)*Ampl]
          Window,0,XSize=700,YSize=YWnSz,Title='Magnetometer Time Series'
          DteStr,Year,Month,Day,Ttle
          Ttle='Data for '+Ttle
          Plot,XAx[Strt:Fin],DArr[0,Strt:Fin],$
           YRange=YRange,XRange=[XAx(strt),XAx(Fin)],YStyle=1,Title=Ttle, $
           XStyle=1,XTickFormat='XTLab',XTitle='Time'
          XYOuts,SBTime,MAx(DArr[0,0:100]),Stat[0],/Data
          YOffs=0.0
          For k=1,FNo do $
          Begin
           YOffs=YOffs+Ampl*2.0
           OPlot,XAx[Strt:Fin],YOffs+DArr[k,Strt:Fin]
           XYOuts,SBTime,YOffs+Max(DArr[k,0:100]),Stat[k],/Data
          end
         end
 'PRN' : Begin
          WSet,0
          XYOuts,40,15,'Printing c:\temp\tsplot.ps...',/Device,color=!D.N_Colors-1
          Widget_Control,/Hourglass
          Set_Plot,'PS'
          YWnSz=150+FNo*40
          YSz=Float(YWnSz)/500.0*16.0  ; plot height in cm
          Device,Filename='C:\TEMP\TSPLOT.PS',$
           XOffset=2,YOffset=10,XSize=15,YSize=YSz
          Time2Sec,SBTime,Long(SNHr),Long(SNMn),Long(SNSc)
          Time2Sec,EBTime,Long(ENHr),Long(ENMn),Long(ENSc)
          Strt=Long((SBTime-MnTme)/SInt)
          Fin =Long((EBTime-MnTme)/SInt)-1
          DSz=Fin-Strt+1
          xstart=Float(SNHr)+Float(SNMn)/60.+SNSc/3600.
          xend=Float(ENHr)+Float(ENMn)/60.+ENSc/3600.
          XRange=[xstart,xend]
          YRange=[-Ampl,(2.0*FNo+1.0)*Ampl]
          XLabel='Time UT'
          Label=String((fix(Day)),string(fix(Month)),$
           string(fix(Year)),format="(I2.2,'/',I2.2,'/',I4.2,'   (Amplitude: nT)')")
          ;label='Amplitude: nT'
          TIMEAX, xstart,xend,xticks,xtickv,xtickname,xminor
          nonames=strarr(xticks+1)
          For i=0,xticks do nonames(i)=' '
          yticks=2*(FNo+1)
          ytickv=FltArr(yticks)
          ytickname=StrArr(yticks)
          For i=0,yticks-1 do ytickv(i)=(i-1)*Ampl
          For i=0,yticks-1 do ytickname(i)=' '
          MnR=ytickv[0]
          MxR=ytickv[1]
          If yticks GT 2 Then MxR=ytickv[2]
          jj=1
          For ii=0,yticks/2-1 do $
          Begin
           ytickname(jj)=stat(ii)
           jj=jj+2
          end
          For i=0,FNo do $
          Begin
           xdata=FltArr(DSz)
           ydata=DblArr(DSz)
           YOffs=2.0*Float(i)*Ampl
           For j=Long(Strt),Long(Fin) do $
           Begin
            xdata(j-Strt)=MnTme/3600.0+Float(j)*SInt/3600.0
            ydata(j-Strt)=DArr(i,j)+YOffs
           end
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
          Print,'Finished postscript file : C:\TEMP\TSPLOT.PS.'
          Set_Plot,'WIN'
          WSet,0
          Wait,0.5
          XYOuts,40,15,'Printing c:\temp\tsplot.ps...',/Device,color=0
         end
 'EXIT': Widget_Control,ev.top, /Destroy
 ENDCASE
END

PRO AdjTime
 Common Blk1,HrArr,MnArr,ScArr,FNo,SInt,NPnts,NPlts,Stat
 Common Blk2,SNHr,SNMn,SNSc,ENHr,ENMn,ENSc,MnTme,MxTme
 Common Blk3,FSArr,FEArr,DArr,TmpArr,XAx,Ampl
 Common Blk4,SFRSw,EFRSw,Year,Month,Day
 Common Blk5,ShrBut,SMnBut,SScBut,EHrBut,EMnBut,EScBut,base
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
 SHrBut = Widget_Button(base,value='HR : '+HrArr[0,SNHr],UValue='SHR')
 SMnBut = Widget_Button(base,value='MN : '+MnArr[0,SNMn],UValue='SMN')
 SScBut = Widget_Button(base,value='SC : '+ScArr[0,SNSc],UValue='SSC')
 ETxt = Widget_Text(base,value='End Time')
 EFRBut = Widget_Button(base,value='Reverse',UValue='EFR')
 EHrBut = Widget_Button(base,value='HR : '+HrArr[1,ENHr],UValue='EHR')
 EMnBut = Widget_Button(base,value='MN : '+MnArr[1,ENMn],UValue='EMN')
 EScBut = Widget_Button(base,value='SC : '+ScArr[1,ENSc],UValue='ESC')
 AdFBut= Widget_Button(base,value='Add Data',UValue='ADF')
 DelBut= Widget_Button(base,value='Del Data',UValue='DDF')
 AdjBut= Widget_Button(base,value='Adjust Amplitude',UValue='ADA')
 PltBut= Widget_Button(base,value='Plot',UValue='PLOT')
 PrnBut= Widget_Button(base,value='Print',UValue='PRN')
 ExBut = Widget_Button(base,value='Exit',UValue='EXIT')
 WIDGET_CONTROL, base, /REALIZE
 XMANAGER, 'AdjTime', base
END
;
PRO WTMSER
 Common Blk1,HrArr,MnArr,ScArr,FNo,SInt,NPnts,NPlts,Stat
 Common Blk2,SNHr,SNMn,SNSc,ENHr,ENMn,ENSc,MnTme,MxTme
 Common Blk3,FSArr,FEArr,DArr,TmpArr,XAx,Ampl
 Common Blk4,SFRSw,EFRSw,Year,Month,Day
 NPlts=10
 FSArr=LonArr(NPlts)
 FEArr=LonArr(NPlts)
 NPnts=LonArr(NPlts)
 Stat=StrArr(NPlts)
 Ampl=100.
 Set_Plot,'WIN'
 LoadCT,0
 Device,Decomposed=0
 Window,0,XSize=700,YSize=150,Title='Magnetometer Time Series'
; Add 50 to each window as more TS are added
 FNo=0 & StaL=''
 Year=1990 & Month=0 & Day=0
 Hour=0 & Min=0 & Sec=0.0
;
; Input first Data File
;
 FName=Dialog_PickFile(Title='Select First Data File',Filter='*.*')
 NPs=Long(0)
 OpenR,u,FName,/Get_Lun
 ReadF,u,Format='(1x,A4,5I5,1x,2F5.1,I5)',$
  StaL,Year,Month,Day,Hour,Min,Sec,SInt,NPs
 XDat=DblArr(NPs)
 ReadF,u,XDat
 Free_Lun,u
;
 NPnts[0]=NPs
 SNHr=Fix(Hour) & SNMn=Fix(Min) & SNSc=Fix(Sec)
 STime=Long(Hour*3600)+Long(Min*60)+Long(Sec)
 ETme=Long(STime+NPs*SInt)
 Sec2Time,ETme,ENHr,ENMn,ENSc
 FSArr[FNo]=STime
 FEArr[FNo]=ETme
 MnTme=STime
 MxTme=ETme
 XAx=LonArr(NPs)
 For i=Long(0),Long(NPs-1) do XAx(i)=Long(STime)+i*SInt
;
 DArr=DblArr(FNo+1,NPs)
 TmpArr=DblArr(FNo+1,NPs)
 DArr[0,*]=XDat
 TmpArr=DArr
 Stat[0]=StaL
 DteStr,Year,Month,Day,Ttle
 Ttle='Data for '+Ttle
 !X.Range=[STime,ETme]
 Plot,XAx,XDat,XRange=[STime,ETme],YRange=[-Ampl,Ampl],$
 YStyle=1,XStyle=1,XTickFormat='XTLab',Title=Ttle,XTitle='Time'
 XYOuts,STime,MAx(XDat[0:100]),Stat[0],/Data
 AdjTime
 Set_Plot,'WIN'
 WDelete,0
end