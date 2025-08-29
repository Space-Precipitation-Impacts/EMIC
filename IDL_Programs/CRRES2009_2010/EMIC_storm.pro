;this is the over arching program for the EMIC storm study. This was
;started on April 23rd 2009 by Alexa Halford and includes reading in
;the Dst and ploting it to find events that we want to look at. To run
;this program just type @EMIC_storm in the idl terminal.

                                ;This is the number of minuets in the
                                ;normalized onset length, main phase
                                ;length and the recovery for the storms.
onsetlength = 60.*3. ;180.
mainlength = 6000.;3000.
recovlength = 12000.;8000.


                                ;These are the precent size bins that
                                ;we want the EMIC events divided int
                                ;to. 
opcr = .25
mpcr = .1
rpcr = .1
                              
                                ;This is the event file for the storm
                                ;phases, and followed by the folder
                                ;paths for the figures, save files,
                                ;templates, and the data folders
;eventf = 'CRRES_test.txt'
eventf = 'CRRES_storm_phases.txt';'CRRES_SSC_90_91.txt'
figf = '../figures/'
savef = '../Savefiles/'
tempf = '../Templates/'
dataf = '../Data/'

                                ; This is the buffer for the plotting
                                ; when it's a quick and dirty
                                ; plot and not set individually for
                                ; each storm.
ebuffer = 60.*24.*3.
sbuffer = 60.*3.
                                ; These are the years that CRRES was active.
year_array = [1990, 1991]

                                ; Now we are compiling the relavent
                                ; procedures for this program.
.compile read_emicCRRES
.compile read_emicLex
.compile read_emicPaul
.compile read_dst
.compile read_eventfile
.compile Dst_prep
.compile plot_dst_emic
.compile norm_dst



read_emicCRRES, year_array, dataf, tempf 
;read_emicLex, year_array, dataf, tempf 


;read_dst, year_array, dataf, tempf
read_sym, year_array, dataf, savef, tempf

read_eventfile , eventf, sbuffer, ebuffer, dataf, savef, tempf

;read_emicPaul, year_array, dataf, tempf

Dst_prep, eventf, sbuffer, ebuffer, dataf, savef

plot_dst_emic, sbuffer, ebuffer, dataf, savef, figf

norm_dst, dataf, savef, tempf, figf, onsetlength, mainlength, recovlength, opcr, mpcr, rpcr


print, 'done with everything'
