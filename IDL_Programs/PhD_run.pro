

dataf = '~/Data/'
tempf = '~/Templates/'
savef = '~/Savefiles'
figf = '~/figures/'

.compile read_emicLex
.compile EMIC_LT_LS
.compile EMIC_LT_LS_storm
.compile apples_to_apples
.compile test_alpha

read_emicLex, [1990, 1991], dataf, tempf

EMIC_LT_LS, dataf

EMIC_LT_LS_storm;, dataf, tempf

apples_to_apples, figf, savef, tempf, dataf

test_alpha

