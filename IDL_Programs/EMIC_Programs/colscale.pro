; NAME:
;   COLSCALE
;
; PURPOSE:
;   This procedure creates color levels with
;   indexes using the standard color
;   tables.
;
; CATEGORY:
;   SDutil.
;
; CALLING SEQUENCE:
;   COLSCALE,Minval,Maxval,Nlv,Cin,Lvl,Ncol,Tcol
;
; INPUTS:
;   Minval  : The lowest value of the scale.
;   Maxval  : The greatest value of the scale.
;   Nlv : The number of levels in the scale
;
; KEYWORD PARAMETERS:
;   VEL :   Choses the velocity colortable
;       otherwise the power colortable is
;       selected.
;   BW :    Choses a black and white color table
;       for postscript devices
; OUTPUTS:
;   Cin : The color index for each level
;           intarr(nlv)
;   Lvl : The minimum of the level
;           fltarr(nlv)
;   Ncol    : The number of available colors.
;   Tcol    : The color that is most visible
;           on the device.
;
; COMMON BLOCKS:
;   common pattern,pat
;   The common block for pattern fills for pcl
;   devices only.  If not a pcl device this block
;   does not have to be defined.
;
; PROCEDURE:
;   Loads the color table that is stored in the
;   procedure newcolor.pro.  This procedure
;   should take care of all device dependencies.
;
; EXAMPLE:
;   To load the velocity colortable with 11 levels
;   use the following:
;   Colscale,-500.0,500.0,11,cin,lvl,ncol,tcol,/vel
;
;   To load the black and white color table for a ps
;   device, use the following:
;   set_plot,'ps'
;   device,color=0, ...
;   Colscale,-500.0,500.0,11,cin,lvl,ncol,tcol,/BW
;
; MODIFICATION HISTORY:
;   Written by: Don Danskin., Jan. 1994
;   Modified by:    Don Danskin, May 31, 1994.  Included
;           help text and made VEL a keyword.
;           Don Danskin, June 14, 1994. Added
;           B&W keyword for ps devices.
;
Pro colscale,minval,maxval,nlv,cin,lvl,ncol,tcol,VEL=VEL,BW=BW
@common1.pro
 IF KEYWORD_SET(VEL) THEN i_par = 2 else i_par = 0
 common pattern,pat ;patterned fill to get greyscaling levels for pcl devices
 pat=bytarr(4,4,16)+1
 CASE !d.name OF
 'WIN': BEGIN
         newcolor
         ncol = 25
         tcol = 24
         CIN = INDGEN(NLV)+2
         if i_par eq 2 then cin= cin + 11
         LVL = MINVAL+(INDGEN(NLV))*(MAXVAL-MINVAL)/(NLV)
        END
'PS': BEGIN
       ncol = (!d.n_colors < 256) - 1
       IF KEYWORD_SET(BW) THEN CIN = (NLV - INDGEN(NLV) -1)*FIX(NCOL/NLV) $
    ELSE BEGIN
        CIN = INDGEN(NLV)+2
        if i_par eq 2 then cin= cin + 11
        newcolor
    ENDELSE
    ncol = 25
    tcol = 0
    LVL = MINVAL+(INDGEN(NLV))*(MAXVAL-MINVAL)/(NLV)
    END
'PCL':  BEGIN
         ncol = 2
         tcol = 1
         CIN=(NLV - INDGEN(NLV))*((ncol)/(NLV))
         pat=bytarr(4,4,16)
         pat(1,1,1:15) = 1
         pat(2,2,2:15) = 1
         pat(1,2,3:15) = 1
         pat(2,1,4:15) = 1
         pat(0,2,5:15) = 1
         pat(3,1,6:15) = 1
         pat(3,2,7:15) = 1
         pat(0,1,8:15) = 1
         pat(3,3,9:15) = 1
         pat(0,3,10:15) = 1
         pat(2,3,11:15) = 1
         pat(1,3,12:15) = 1
         pat(3,0,13:15) = 1
         pat(2,0,14:15) = 1
         pat(1,0,15) = 1
         pat(0,0,15) = 1
         LVL = MINVAL+(INDGEN(NLV))*(MAXVAL-MINVAL)/(NLV)
        End
 EndCase
 numcol=ncol
end
