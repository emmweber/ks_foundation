%#ok<*SAGROW>

%%

rffl901mc = struct(...
   'filename', 'rffl901mc', ...
   'type', 'exc', ...
   'abswidth', 0.3728, ...
   'effwidth', 0.2516, ...
   'area', 0.2909, ...
   'dtycyc', 0.6160, ...
   'maxpw', 0.6160, ...
   'max_b1', 0.0505, ...
   'max_int_b1_sq', 0.00257, ...
   'max_rms_b1', 0.0253, ...
   'nom_fa', 90, ...
   'nom_pw', 4000, ...
   'nom_bw', 886, ...
   'isodelay', 1500, ... % appears to be
   'iso2end_subpulse', -1, ... % only for SPSP
   'res', 250, ...
   'extgradfile', 0 ...
   );

rffse90 = struct(...
   'filename', 'rffse90', ...
   'type', 'exc', ...
   'abswidth', 0.3777, ...
   'effwidth', 0.2713, ...
   'area', 0.3615, ...
   'dtycyc', 0.7462, ...
   'maxpw', 0.7462, ...
   'max_b1', 0.0406013, ...
   'max_int_b1_sq', 0.0017884, ...
   'max_rms_b1', 0.0211473, ...
   'nom_fa', 90, ...
   'nom_pw', 4000, ...
   'nom_bw', 800, ...
   'isodelay', 1708, ...
   'iso2end_subpulse', -1, ... % only for SPSP
   'res', 400, ...
   'extgradfile', 0 ...
   );

rffse902 = struct(...
   'filename', 'rffse902', ...
   'type', 'exc', ...
   'abswidth', 0.3777, ...
   'effwidth', 0.2713, ...
   'area', 0.3615, ...
   'dtycyc', 0.7462, ...
   'maxpw', 0.7462, ...
   'max_b1', 0.0406013, ...
   'max_int_b1_sq', 0.0017884, ...
   'max_rms_b1', 0.0211473, ...
   'nom_fa', 90, ...
   'nom_pw', 5000, ...
   'nom_bw', 800, ...
   'isodelay', 1750, ...
   'iso2end_subpulse', -1, ... % only for SPSP
   'res', 250, ...
   'extgradfile', 0 ...
   );

rffl902mc = struct(...
   'filename', 'rffl902mc', ...
   'type', 'exc', ...
   'abswidth', 0.3728, ...
   'effwidth', 0.2516, ...
   'area', 0.2909, ...
   'dtycyc', 0.6160, ...
   'maxpw', 0.6160, ...
   'max_b1', 0.0505, ...
   'max_int_b1_sq', 0.00257, ...
   'max_rms_b1', 0.0253, ...
   'nom_fa', 90, ...
   'nom_pw', 5000, ...
   'nom_bw', 886, ...
   'isodelay', 3340, ...
   'iso2end_subpulse', -1, ... % only for SPSP
   'res', 250, ...
   'extgradfile', 0 ...
   );

rfssfse90new = struct(...
   'filename', 'rfssfse90new', ...
   'type', 'exc', ...
   'abswidth', 0.3648, ...
   'effwidth', 0.2647, ...
   'area', 0.3578, ...
   'dtycyc', 0.7538, ...
   'maxpw', 0.7538, ...
   'max_b1', 0.0820572, ...
   'max_int_b1_sq', 0.00356446, ...
   'max_rms_b1', 0.0422165, ...
   'nom_fa', 90, ...
   'nom_pw', 2000, ...
   'nom_bw', 1280, ...
   'isodelay', 996, ...
   'iso2end_subpulse', -1, ... % only for SPSP
   'res', 200, ...
   'extgradfile', 0 ...
   );

% RF_3DFGRE (legacy pulse)
rf3dfgre = struct(...
   'filename', 'rf3dfgre', ...
   'type', 'exc', ...
   'abswidth', 0.1878, ...
   'effwidth', 0.1005, ...
   'area', 0.0949, ...
   'dtycyc', 0.2633, ...
   'maxpw', 0.2132, ...
   'max_b1', 0.0644207, ... % SAR_MAXB1_NEWALPHA1
   'max_int_b1_sq', 0.001335, ... % SAR_MAX_INT_B1_SQ_NEWALPHA1
   'max_rms_b1', 0.02043, ...
   'nom_fa', 30, ...
   'nom_pw', 3200, ...
   'nom_bw', 3664, ...
   'isodelay', 440, ...
   'iso2end_subpulse', -1, ... % only for SPSP
   'res', 320, ...
   'extgradfile', 0 ...
   );


% RF_E3DFGRE
rf3d16min = struct(...
   'filename', 'rf3d16min', ...
   'type', 'exc', ...
   'abswidth', 0.1950, ...
   'effwidth', 0.1036, ...
   'area', 0.0943, ...
   'dtycyc', 1.0, ...
   'maxpw', 1.0, ...
   'max_b1', 0.194498, ...
   'max_int_b1_sq', 0.00627166, ...
   'max_rms_b1', 0.0627166, ...
   'nom_fa', 45, ...
   'nom_pw', 1600, ...
   'nom_bw', 7232, ...
   'isodelay', 252, ...
   'iso2end_subpulse', -1, ... % only for SPSP
   'res', 800, ...
   'extgradfile', 0 ...
   );

% RF_TURBO
rf3d8min = struct(...
   'filename', 'rf3d8min', ...
   'type', 'exc', ...
   'abswidth', 0.1960, ...
   'effwidth', 0.1045, ...
   'area', 0.0954, ...
   'dtycyc', 1.0, ...
   'maxpw', 1.0, ...
   'max_b1', 0.256422, ...
   'max_int_b1_sq', 0.00549569, ...
   'max_rms_b1', 0.0828831, ...
   'nom_fa', 30, ...
   'nom_pw', 800, ...
   'nom_bw', 14403.0, ...
   'isodelay', 124, ...
   'iso2end_subpulse', -1, ... % only for SPSP
   'res', 400, ...
   'extgradfile', 0 ...
   );

% RF_TBW8
tbw8_01_001_150 = struct(...
   'filename', 'tbw8_01_001_150', ...
   'type', 'exc', ...
   'abswidth', 0.2495, ...
   'effwidth', 0.1458, ...
   'area', 0.1473, ...
   'dtycyc', 1.0, ...
   'maxpw', 1.0, ...
   'max_b1', 0.221475, ...
   'max_int_b1_sq', 0.00214499, ...
   'max_rms_b1', 0.0845575, ...
   'nom_fa', 15, ...
   'nom_pw', 300, ...
   'nom_bw', 26666.67, ...
   'isodelay', 62, ...
   'iso2end_subpulse', -1, ... % only for SPSP
   'res', 150, ...
   'extgradfile', 0 ...
   );

% RF_TBW6
tbw6_01_001_150 = struct(...
   'filename', 'tbw6_01_001_150', ...
   'type', 'exc', ...
   'abswidth', 0.2880, ...
   'effwidth', 0.1784, ...
   'area', 0.1870, ...
   'dtycyc', 1.0, ...
   'maxpw', 1.0, ...
   'max_b1', 0.174412, ...
   'max_int_b1_sq', 0.00162796, ...
   'max_rms_b1', 0.0736649, ...
   'nom_fa', 15, ...
   'nom_pw', 300, ...
   'nom_bw', 20000, ...
   'isodelay', 78, ...
   'iso2end_subpulse', -1, ... % only for SPSP
   'res', 150, ...
   'extgradfile', 0 ...
   );


% MINPH_RF_RTIA (2D)
rf_bw4_800us = struct(...
   'filename', 'rf_bw4_800us', ...
   'type', 'exc', ...
   'abswidth', 0.4032, ...
   'effwidth', 0.2913, ...
   'area', 0.4032, ...
   'dtycyc', 0.9784, ...
   'maxpw', 0.9784, ...
   'max_b1', 0.0606762, ...
   'max_int_b1_sq', 0.000864594, ... % Couldn't find. calculated using ks_eval_rfstat()
   'max_rms_b1', 0.0328746, ...  % Couldn't find. calculated using ks_eval_rfstat()
   'nom_fa', 30, ...
   'nom_pw', 800, ...
   'nom_bw', 4000, ...
   'isodelay', 378, ...
   'iso2end_subpulse', -1, ... % only for SPSP
   'res', 400, ...
   'extgradfile', 0 ...
   );

% Default SSFP (3D)
tbw3_01_001_pm_250 = struct(...
   'filename', 'tbw3_01_001_pm_250', ...
   'type', 'ssfp', ...
   'abswidth', 0.4121, ...
   'effwidth', 0.3, ...
   'area', 0.4112, ...
   'dtycyc', 1.0, ...
   'maxpw', 1.0, ...
   'max_b1', 0.142811, ...
   'max_int_b1_sq', 0.00305924, ...
   'max_rms_b1', 0.0782207, ...
   'nom_fa', 45, ...
   'nom_pw', 500, ...
   'nom_bw', 6000, ...
   'isodelay', 250, ...
   'iso2end_subpulse', -1, ... % only for SPSP
   'res', 250, ...
   'extgradfile', 0 ...
   );

% SSFP (3D)
rf3d_600us_01p_01s_10khz = struct(...
   'filename', 'rf3d_600us_01p_01s_10khz', ...
   'type', 'ssfp', ...
   'abswidth', 0.2211, ...
   'effwidth', 0.1456, ...
   'area', 0.1665, ...
   'dtycyc', 0.3356, ...
   'maxpw', 0.3356, ...
   'max_b1', 0.29395, ...
   'max_int_b1_sq', 0.00754861, ...
   'max_rms_b1', 0.112165, ...
   'nom_fa', 45, ...
   'nom_pw', 600, ...
   'nom_bw', 10089.4, ...
   'isodelay', 302, ...
   'iso2end_subpulse', -1, ... % only for SPSP
   'res', 300, ...
   'extgradfile', 0 ...
   );

% SSFP (2D)
   
tbw2_1_01 = struct(...
   'filename', 'tbw2_1_01', ...
   'type', 'ssfp', ...
   'abswidth', 0.5947, ...
   'effwidth', 0.4440, ...
   'area', 0.5947, ...
   'dtycyc', 1.0, ...
   'maxpw', 1.0, ...
   'max_b1', 0.197458, ...
   'max_int_b1_sq', 0.00865607, ...
   'max_rms_b1', 0.131576, ...
   'nom_fa', 90, ...
   'nom_pw', 500, ...
   'nom_bw', 4000.0, ...
   'isodelay', 250, ...
   'iso2end_subpulse', -1, ... % only for SPSP
   'res', 250, ...
   'extgradfile', 0 ...
   );
 


% HARD100
fermi100 = struct(...
   'filename', 'fermi100', ...
   'type', 'excnonsel', ...
   'abswidth', 0.6865, ...
   'effwidth', 0.6374, ...
   'area', 0.6865, ...
   'dtycyc', 1.0, ...
   'maxpw', 1.0, ...
   'max_b1', 0.142549, ...
   'max_int_b1_sq', 0.00129516, ...
   'max_rms_b1', 0.113805, ...
   'nom_fa', 15, ...
   'nom_pw', 100, ...
   'nom_bw', 12000, ...
   'isodelay', 50, ...
   'iso2end_subpulse', -1, ... % only for SPSP
   'res', 50, ...
   'extgradfile', 0 ...
   );



rfse1b4 = struct(...
   'filename', 'rfse1b4', ...
   'type', 'ref', ...
   'abswidth', 0.2874, ...
   'effwidth', 0.1799, ...
   'area', 0.1867, ...
   'dtycyc', 0.4486, ...
   'maxpw', 0.4486, ...
   'max_b1', 0.177, ... % 0.177 but GE says: rfstat gives 0.0197, and it does
   'max_int_b1_sq', 0.01803, ... % 0.01803 but rfstat gives: 0.0222974
   'max_rms_b1', 0.0751, ...% 0.0751 but rfstat gives: 0.0834742
   'nom_fa', 180, ...
   'nom_pw', 3200, ...
   'nom_bw', 905, ...
   'isodelay', 1600, ...
   'iso2end_subpulse', -1, ... % only for SPSP
   'res', 400, ...
   'extgradfile', 0 ...
   );



rffse1601 = struct(...
   'filename', 'rffse1601', ...
   'type', 'ref', ...
   'abswidth', 0.2918, ...
   'effwidth', 0.2026, ...
   'area', 0.2636, ...
   'dtycyc', 0.5423, ...
   'maxpw', 0.5423, ...
   'max_b1', 0.13494, ...
   'max_int_b1_sq', 0.0116042, ...
   'max_rms_b1', 0.0602188, ...
   'nom_fa', 173.916122, ...
   'nom_pw', 3200, ...
   'nom_bw', 800, ...
   'isodelay', 1600, ...
   'iso2end_subpulse', -1, ... % only for SPSP
   'res', 320, ...
   'extgradfile', 0 ...
   );


rffse1602 = struct(...
   'filename', 'rffse1602', ...
   'type', 'ref', ...
   'abswidth', 0.3713, ...
   'effwidth', 0.2617, ...
   'area', 0.3713, ...
   'dtycyc', 1, ...
   'maxpw', 1, ...
   'max_b1', 0.08724, ...
   'max_int_b1_sq', 0.00630358, ...
   'max_rms_b1', 0.0443832, ...
   'nom_fa', 158.340576, ...
   'nom_pw', 3200, ...
   'nom_bw', 800, ...
   'isodelay', 1600, ...
   'iso2end_subpulse', -1, ... % only for SPSP
   'res', 320, ...
   'extgradfile', 0 ...
   );


rffse160n = struct(...
   'filename', 'rffse160n', ...
   'type', 'ref', ...
   'abswidth', 0.4224, ...
   'effwidth', 0.3018, ...
   'area', 0.4224, ...
   'dtycyc', 1, ...
   'maxpw', 1, ...
   'max_b1', 0.07755, ...
   'max_int_b1_sq', 0.0057596, ...
   'max_rms_b1', 0.0424249, ...
   'nom_fa', 160.144730, ...
   'nom_pw', 3200, ...
   'nom_bw', 800, ...
   'isodelay', 1600, ...
   'iso2end_subpulse', -1, ... % only for SPSP
   'res', 320, ...
   'extgradfile', 0 ...
   );

   
rfssfse155 = struct(...
   'filename','rfssfse155', ...
   'type', 'ref', ...
   'abswidth', 0.4009, ...
   'effwidth', 0.2809, ...
   'area', 0.3507, ...
   'dtycyc', 0.7333, ...
   'maxpw', 0.7333, ...
   'max_b1', 0.24000, ...
   'max_int_b1_sq', 0.0194606, ...
   'max_rms_b1', 0.127347, ...
   'nom_fa', 155, ...
   'nom_pw', 1200, ...
   'nom_bw', 1280.0, ...
   'isodelay', 600, ...
   'iso2end_subpulse', -1, ... % only for SPSP
   'res', 120, ...
   'extgradfile', 0 ...
   );




% RF_FERMI_HARD
fermi124 = struct(...
   'filename', 'fermi124', ...
   'type', 'refnonsel', ...
   'abswidth', 0.9290, ...
   'effwidth', 0.9026, ...
   'area', 0.9290, ...
   'dtycyc', 0.9839, ...
   'maxpw', 0.9839, ...
   'max_b1', 0.254896, ...
   'max_int_b1_sq', 0.0145434, ...
   'max_rms_b1', 0.242163, ...
   'nom_fa', 90, ...
   'nom_pw', 248, ...
   'nom_bw', 4032.3, ...
   'isodelay', 124, ...
   'iso2end_subpulse', -1, ... % only for SPSP
   'res', 124, ...
   'extgradfile', 0 ...
   );

% SILVERHOULT 1.5T complex (.pha)
shNvrg5b = struct(...
   'filename', 'shNvrg5b', ...
   'type', 'adinv', ...
   'abswidth', 0.4634, ...
   'effwidth', 0.3099, ...
   'area', 0.4634, ...
   'dtycyc', 1, ...
   'maxpw', 1, ...
   'max_b1', 0.02934, ...
   'max_int_b1_sq', 0.00230333, ...
   'max_rms_b1', 0.0163276, ...
   'nom_fa', 43.82, ...
   'nom_pw', 8640, ...
   'nom_bw', 1185.185, ...
   'isodelay', 8640/2, ... % isodelay = nom_pw/2
   'iso2end_subpulse', -1, ... % only for SPSP
   'res', 432, ...
   'extgradfile', 0 ...
   );

% SILVERHOULT 3T complex (.pha)
sh3t2 = struct(...
   'filename', 'sh3t2', ...
   'type', 'adinv', ...
   'abswidth', 0.5390, ...
   'effwidth', 0.3732, ...
   'area', 0.5390, ...
   'dtycyc', 1, ...
   'maxpw', 1, ...
   'max_b1', 0.125, ...
   'max_int_b1_sq', 0.00110705, ...
   'max_rms_b1', 0.0130766, ...
   'nom_fa', 250, ...
   'nom_pw', 16000, ...
   'nom_bw', 1500, ...
   'isodelay', 16000/2, ... % isodelay = nom_pw/2
   'iso2end_subpulse', -1, ... % only for SPSP
   'res', 400, ...
   'extgradfile', 0 ... 
   );

rfinvI0 = struct(...
   'filename', 'rfinvI0', ...
   'type', 'inv', ...
   'abswidth', 0.2172, ...
   'effwidth', 0.1270, ...
   'area', 0.1312, ...
   'dtycyc', 0.3133, ...
   'maxpw', 0.3133, ...
   'max_b1', 0.1791, ...
   'max_int_b1_sq', 0.02037, ...
   'max_rms_b1', 0.0638, ...
   'nom_fa', 178, ...
   'nom_pw', 5000, ...
   'nom_bw', 777.8, ...
   'isodelay', 5000/2, ... % isodelay = nom_pw/2
   'iso2end_subpulse', -1, ... % only for SPSP
   'res', 250, ...
   'extgradfile', 0 ...
   );
 
%{
iso2end_subpulse derived from ss.se:
area_gz1 = ( (float)pw_constant/2 + (float)pw_ss_rampz/2 + (float)off90minor/2)*a_gzrf1;

1528822
off90minor = -45;
pw_ss_rampz = 288;
pw_gzrf1lobe = PSD_ss1528822_RF1_HlPW = 1200us
pw_constant = 1200 - 2 * 288 = 624
iso2end_subpulse = (624-45)/2 + 288 = 578 = rounded to 576 (4us raster)

ss30260334
off90minor = 0;
pw_ss_rampz = 252;
pw_gzrf1lobe = PSD_ss30260334_RF1_HlPW = 648us
pw_constant = 648 - 2 * 252 = 144
iso2end_subpulse = (144)/2 + 252 = 324   
%}


% SPSP 1.5T
ss1528822 = struct(...
   'filename', 'ss1528822', ...
   'type', 'spsp', ...
   'abswidth', 0.1280, ...
   'effwidth', 0.0636, ...
   'area', 0.1071, ...
   'dtycyc', 0.1828, ...
   'maxpw', 0.0757, ...
   'max_b1', 0.03807, ...
   'max_int_b1_sq', 0.00133, ...
   'max_rms_b1', 0.00960, ...
   'nom_fa', 90, ...
   'nom_pw', 14400, ...
   'nom_bw', 2571, ...
   'isodelay', 7200, ...
   'iso2end_subpulse', 576, ... % only for SPSP
   'res', 3600, ...
   'extgradfile', 1 ... % 1 = cannot stretch this RF pulse
   );

% SPSP 3T
ss30260334 = struct(...
   'filename', 'ss30260334', ...
   'type', 'spsp', ...
   'abswidth', 0.0819, ...
   'effwidth', 0.0429, ...
   'area', 0.0614, ...
   'dtycyc', 0.1171, ...
   'maxpw', 0.0652, ...
   'max_b1', 0.12788, ...
   'max_int_b1_sq', 0.00403, ...
   'max_rms_b1', 0.0203736, ...
   'nom_fa', 90, ...
   'nom_pw', 9720, ...
   'nom_bw', 4040, ...
   'isodelay', 4860, ...
   'iso2end_subpulse', 324, ... % only for SPSP
   'res', 2430, ...
   'extgradfile', 1 ... % 1 = cannot stretch this RF pulse
   );


% SLR SAT
rfdblsatl0 = struct(...
   'filename', 'rfdblsatl0', ...
   'type', 'spsat', ...
   'abswidth', 0.1641, ... % 0.1641 but rfstat gives: 0.232878
   'effwidth', 0.1468, ...
   'area', 0.1641, ...
   'dtycyc', 0.5723, ...
   'maxpw', 0.5723, ...
   'max_b1', 0.0894, ...
   'max_int_b1_sq', 0.00470, ...
   'max_rms_b1', 0.0343, ...
   'nom_fa', 90, ...
   'nom_pw', 4000, ...
   'nom_bw', 1267, ... % SpSat.e is using both 1267 and 1562
   'isodelay', 0, ... % no isodelay for sat pulses
   'iso2end_subpulse', -1, ... % only for SPSP
   'res', 400, ...
   'extgradfile', 0 ... 
   );

% SLR SAT complex
satqptbw12 = struct(...
   'filename', 'satqptbw12', ...
   'type', 'spsatc', ...
   'abswidth', 0.3472, ... 
   'effwidth', 0.2506, ...
   'area', 0.3472, ...
   'dtycyc', 0.9960, ...
   'maxpw', 0.9960, ...
   'max_b1', 0.105, ...
   'max_int_b1_sq', 0.00179175, ...
   'max_rms_b1', 0.0211646, ...
   'nom_fa', 90, ...
   'nom_pw', 4000, ...
   'nom_bw', 3000, ... 
   'isodelay', 0, ... % no isodelay for sat pulses
   'iso2end_subpulse', -1, ... % only for SPSP
   'res', 1000, ...
   'extgradfile', 0 ... 
   );



% ChemSat 1.5T
rfcsm = struct(...
   'filename', 'rfcsm', ...
   'type', 'chemsat', ...
   'abswidth', 0.3652, ...
   'effwidth', 0.2468, ...
   'area', 0.2734, ...
   'dtycyc', 0.5329, ...
   'maxpw', 0.5329, ...
   'max_b1', 0.01342, ...
   'max_int_b1_sq', 0.000712, ...
   'max_rms_b1', 0.00667, ...
   'nom_fa', 90, ...
   'nom_pw', 16000, ...
   'nom_bw', 0, ...
   'isodelay', 0, ... % no isodelay for chemsat pulses
   'iso2end_subpulse', -1, ... % only for SPSP
   'res', 320, ...
   'extgradfile', 0 ...
   );

% ChemSat 3T
rfcs3t = struct(...
   'filename', 'rfcs3t', ...
   'type', 'chemsat', ...
   'abswidth', 0.3208, ...
   'effwidth', 0.2021, ...
   'area', 0.2103, ...
   'dtycyc', 0.4550, ...
   'maxpw', 0.3950, ...
   'max_b1', 0.03684, ...
   'max_int_b1_sq', 0.002194, ...
   'max_rms_b1', 0.01656, ...
   'nom_fa', 95, ...
   'nom_pw', 8000, ...
   'nom_bw', 0, ...
   'isodelay', 0, ... % no isodelay for chemsat pulses
   'iso2end_subpulse', -1, ... % only for SPSP
   'res', 200, ...
   'extgradfile', 0 ... 
   );

%tbw2_1_01, ...
   
rfpulses = [...  
   rffl901mc, rffse90, rffse902, rffl902mc, rfssfse90new, rf3dfgre, rf3d16min, rf3d8min, tbw8_01_001_150, tbw6_01_001_150, rf_bw4_800us  ... % exc
   tbw2_1_01, tbw3_01_001_pm_250, rf3d_600us_01p_01s_10khz, ... % ssfp
   fermi100, ... % exc nonslicesel
   rfse1b4, rffse1601, rffse1602, rffse160n, rfssfse155, ... % refocusing
   fermi124, ... % ref nonslicesel
   shNvrg5b, sh3t2, ... % adiabatic inversion 1.5T & 3T (uses .pha)
   rfinvI0, ... % inversion
   ss1528822, ss30260334, ... % SPectral-SPatial exc
   rfdblsatl0, satqptbw12, ... % Spatial SATs
   rfcsm, rfcs3t ... % ChemSat 1.5T & 3T
   ];


whos
rflocation = fullfile(pwd, 'rfpulses/');
outputpath = fullfile(pwd);
[~,~] = mkdir(outputpath);
%%

for j = 1:numel(rfpulses)
   clear rf
   rfp = fopen(fullfile(rflocation, [rfpulses(j).filename,'.rho']), 'r','b');
   if (rfp < 0)
       fprintf('could not find: %s\n', fullfile(rflocation, [rfpulses(j).filename,'.rho']));
   end
   fseek(rfp,32*2,'bof');
   rf = fread(rfp,rfpulses(j).res, 'short') / 32766;
   rf([1 end]) = 0;
   rf = rf * rfpulses(j).max_b1;
   fclose(rfp);
   x = linspace(0,rfpulses(j).nom_pw/1000, rfpulses(j).res);
   plot(x,rf,'k','LineWidth',2);
   set(gca,'FontSize',16,'FontWeight','normal','LineWidth',0.5);
   xlabel('[ms]')
   ylabel('B1 [G]')
   rname = strrep(rfpulses(j).filename,'rf_','');
   rname = strrep(rname,'rf','');
   rname = strrep(rname,'__','_');
   
   minslthick33mT = rfpulses(j).nom_bw / (1.9 * (0.1) * 4257.59); % 750w with double oblique (max 19 mT/m = 1.9 G/cm)
   minslthick50mT = rfpulses(j).nom_bw / (5 * (0.1) * 4257.59); % 750
   maxB1 = 0.24; % about true [G]
   maxFA = round((maxB1 / rfpulses(j).max_b1) * rfpulses(j).nom_fa);
   
   title(sprintf('%s\\_%s   -   %.0f [Hz]   -   isodelay: %d [us]\nMinSlThick: %0.1f-%0.1f [mm]  -   maxFA: ~ %d [deg]\n', rfpulses(j).type, strrep(rname,'_','\_'), rfpulses(j).nom_bw, rfpulses(j).isodelay, minslthick50mT, minslthick33mT, maxFA)); figure(1);
   axis tight
   drawnow;
   [~,~] = mkdir(fullfile(outputpath,'rfpulses'));
   
   % saveas(gcf, fullfile(outputpath,'rfpulses',[rfpulses(j).type, '_', rname,'.eps']),'eps');
   % saveas(gcf, fullfile(outputpath,'rfpulses',[rfpulses(j).type, '_', rname,'.png']),'png');
   
end
%%



fname = fullfile(outputpath,'KSFoundation_GERF.h');
[~,basename] = fileparts(fname);
fprintf('\n');

fp = fopen(fname, 'w');
if fp == -1; fprintf('Can''t open %s for write',fp);return;end;

fprintf(fp,'#ifndef KSF_GERF_H\n');
fprintf(fp,'#define KSF_GERF_H\n\n');
fprintf(fp,'/*******************************************************************************************************************\n');
fprintf(fp,'* Neuro MR Physics group \n');
fprintf(fp,'* Department of Neuroradiology\n');
fprintf(fp,'* Karolinska University Hospital\n');
fprintf(fp,'* Stockholm, Sweden\n');
fprintf(fp,'*\n');
fprintf(fp,'* Filename	: %s.h\n', basename);
fprintf(fp,'*\n');
fprintf(fp,'* Generated in Matlab using KSFoundation_GERFpulses.m\n');
fprintf(fp,'* Date of file generation: %s\n',sprintf('%d-%02d-%02d %02d:%02d:%02.0f',clock));
fprintf(fp,'* \n');
fprintf(fp,'* This file contains selected GE RF pulses for use with KSFoundation\n');
fprintf(fp,'*\n');
fprintf(fp,'********************************************************************************************************************/\n');
fprintf(fp,'\n\n');
fprintf(fp,'/**\n********************************************************************************************************************\n');
fprintf(fp,'* @file %s.h\n', basename);
fprintf(fp,'* @brief This is an auto-generated file that contains a selection of GE RF pulses converted to KS_RF objects\n');
fprintf(fp,'*\n');
fprintf(fp,'* To use one of these KS_RF pulses, do the following in the pulse sequence:\n');
fprintf(fp,'* 1. Declare a KS_RF object in the `@ipgexport` section\n');
fprintf(fp,'*    - `KS_RF myrf = KS_INIT_RF;`\n');
fprintf(fp,'* 2. Assign the KS_RF object after choosing one in KSFoundation_GERF.h\n');
fprintf(fp,'*    - e.g. `myrf = exc_fse90`\n');
fprintf(fp,'*\n');
fprintf(fp,'* #### DISCLAIMER:\n');
fprintf(fp,'* Efforts has been made to copy and correctly match a selection of GEs RF pulses (`***.rho` in $ESE_TOP/psd/psdrfpulses)\n');
fprintf(fp,'* with proper associated RF_PULSE structures into the RF format (KS_RF) used in KSFoundation.\n');
fprintf(fp,'* However, neither GE Healthcare nor Karolinska University Hospital takes any responsibility that the RF pulses\n');
fprintf(fp,'* available in this file for use in EPIC performs as their corresponding product RF pulses (`***.rho`).\n');
fprintf(fp,'* Absolutely *no* promises are made regarding correct flip angle, SAR calculation data, etc. on any MR system.\n');
fprintf(fp,'* Use of these RF pulses are at your own risk, and for investigational use only\n');
fprintf(fp,'*__________________________________________________________________________________________________________________\n');
fprintf(fp,'********************************************************************************************************************/\n\n\n');


for j = 1:numel(rfpulses)
   
   if strcmp(rfpulses(j).type,'exc') || strcmp(rfpulses(j).type,'excnonsel') || strcmp(rfpulses(j).type,'ssfp') || strcmp(rfpulses(j).type,'spsp')
      role = 'KS_RF_ROLE_EXC';
   elseif strcmp(rfpulses(j).type,'ref') || strcmp(rfpulses(j).type,'refnonsel')
      role = 'KS_RF_ROLE_REF';
   elseif strcmp(rfpulses(j).type,'inv') || strcmp(rfpulses(j).type,'adinv')
      role = 'KS_RF_ROLE_INV';
   elseif strcmp(rfpulses(j).type,'chemsat')
      role = 'KS_RF_ROLE_CHEMSAT';
   elseif strcmp(rfpulses(j).type,'spsat') || strcmp(rfpulses(j).type,'spsatc')
      role = 'KS_RF_ROLE_SPSAT';
   else
      role = 'KS_RF_ROLE_NOTSET';
   end
   
   rfp = fopen(fullfile(rflocation, [rfpulses(j).filename,'.rho']), 'r','b');
   if rfp < 0, continue; end
   
   clear rf
   fseek(rfp, 32*2,'bof');
   rf = fread(rfp,rfpulses(j).res, 'short') / 32766;
   rf([1 end]) = 0;
   % normalize RF
   rf = rf./max(abs(rf));   
   fclose(rfp);
   
   % KS_INIT_RF
   rname = strrep(rfpulses(j).filename,'rf_','');
   rname = strrep(rname,'rf','');
   rname = strrep(rname,'__','_');
   rname = strrep(rname,'__','_');
   rfinit = [];
   
   rfinit = strcat(rfinit, sprintf('const KS_RF %s_%s = {%s,', rfpulses(j).type, rname, role));
   rfinit = strcat(rfinit, sprintf('%g,', rfpulses(j).nom_fa)); % flip
   rfinit = strcat(rfinit, sprintf('%g,', rfpulses(j).nom_bw)); % bw
   rfinit = strcat(rfinit, sprintf('0,')); % cf_offset
   rfinit = strcat(rfinit, sprintf('1,')); % amp
   rfinit = strcat(rfinit, sprintf('%d,', rfpulses(j).nom_pw - rfpulses(j).isodelay)); % start2iso
   rfinit = strcat(rfinit, sprintf('%d,', rfpulses(j).isodelay)); % iso2end
   if isfield(rfpulses(j),'iso2end_subpulse') && rfpulses(j).iso2end_subpulse ~= -1
     rfinit = strcat(rfinit, sprintf('%d,', rfpulses(j).iso2end_subpulse)); % iso2end_subpulse
   else
     rfinit = strcat(rfinit, sprintf('KS_NOTSET,')); % iso2end_subpulse
   end
   
   % designinfo
   designinfo = sprintf('GE RF pulse: %s.rho', rfpulses(j).filename);
   rfinit = strcat(rfinit, sprintf('"%s",',designinfo));
   
   % RF pulse info
   % RX27_APPLY_HADAMARD is defined in KSFoundation.h to ", 1" if RX27 or later
   % DV27: #define RX27_APPLY_HADAMARD , 1
   % pre DV27: #define RX27_APPLY_HADAMARD
   rfinit = strcat(rfinit, sprintf('{NULL,NULL,%g,%g,%g,%g,%g,0,%g,%g,%g,%g,NULL,%g,%g,PSD_PULSE_OFF,0,%d,1,NULL,%d,NULL RX27_APPLY_HADAMARD}', ...
      rfpulses(j).abswidth,rfpulses(j).effwidth,rfpulses(j).area,rfpulses(j).dtycyc,rfpulses(j).maxpw,...
      rfpulses(j).max_b1,rfpulses(j).max_int_b1_sq,rfpulses(j).max_rms_b1,rfpulses(j).nom_fa,...
      rfpulses(j).nom_pw,rfpulses(j).nom_bw,rfpulses(j).isodelay,rfpulses(j).extgradfile));
   
   
   % KS_INIT_WAVE (RF)
   rfwaveinit = [];
   rfwaveinit = strcat(rfwaveinit, sprintf(',{{0,0,NULL,sizeof(KS_WAVE)},KS_INIT_DESC,'));
   rfwaveinit = strcat(rfwaveinit, sprintf('%d,',numel(rf))); % res
   rfwaveinit = strcat(rfwaveinit, sprintf('%d,{',rfpulses(j).nom_pw)); % duration
   for k = 1:numel(rf)
     if abs(rf(k)) < 1e-5
       rfwaveinit = strcat(rfwaveinit, '0');
     elseif rf(k) > 0.999999
       rfwaveinit = strcat(rfwaveinit, '1');
     elseif rf(k) < -0.999999
       rfwaveinit = strcat(rfwaveinit, '-1');
     else
       rfwaveinit = strcat(rfwaveinit, sprintf('%.5f', rf(k)));
     end
     if k < numel(rf),rfwaveinit = strcat(rfwaveinit, ',');end
   end
   rfwaveinit = strcat(rfwaveinit, sprintf('},{0,0,0},KS_NOTSET,KS_INITVALUE(KS_MAXINSTANCES, KS_INIT_SEQLOC),NULL,NULL,NULL}'));
   
   
   %%%%%%%%%%%%%%%% gradients (may be more than one) %%%%%%%%%%%%%%%%
   gext = {}; gsuffix  = {}; grad = {};
   
   if exist(fullfile(rflocation, [rfpulses(j).filename, '.grd']),'file')
      gext{end+1} = '.grd'; gsuffix{end+1} = '_gz';
   end
   if exist(fullfile(rflocation, [rfpulses(j).filename, '.gz']),'file')
      gext{end+1} = '.gz'; gsuffix{end+1} = '_gz';
   end   
   if exist(fullfile(rflocation, [rfpulses(j).filename, '.gy']),'file')
      gext{end+1} = '.gy'; gsuffix{end+1} = '_gy';
   end
   if exist(fullfile(rflocation, [rfpulses(j).filename, '.gx']),'file')
      gext{end+1} = '.gx'; gsuffix{end+1} = '_gx';
   end
   if exist(fullfile(rflocation, [rfpulses(j).filename, '.grad']),'file')
      gext{end+1} = '.grad'; gsuffix{end+1} = '_gz'; 
   end
   
   if ~isempty(gext)
      for g = 1:numel(gext)
         gfp = fopen(fullfile(rflocation, [rfpulses(j).filename,gext{g}]), 'r','b');
         fseek(gfp, 32*2,'bof');
         grad{g} = fread(gfp, rfpulses(j).res, 'short') / 32766;
         fclose(gfp);
         
         gradinit{g} = sprintf('{{0,0,NULL,sizeof(KS_WAVE)},KS_INIT_DESC,');
         gradinit{g} = strcat(gradinit{g}, sprintf('%d,',numel(grad{g}))); % res
         gradinit{g} = strcat(gradinit{g}, sprintf('%d,{',rfpulses(j).nom_pw)); % duration
         % KS_WAVEFORM
         for k = 1:numel(grad{g})
            if abs(grad{g}(k)) < 1e-5
               gradinit{g} = strcat(gradinit{g}, '0');
            elseif grad{g}(k) > 0.999999
               gradinit{g} = strcat(gradinit{g}, '1');
            elseif grad{g}(k) < -0.999999
               gradinit{g} = strcat(gradinit{g}, '-1');
            else
               gradinit{g} = strcat(gradinit{g}, sprintf('%.5f', grad{g}(k)));
            end
            if k < numel(grad{g}),gradinit{g} = strcat(gradinit{g}, ',');end
         end
         gradinit{g} = strcat(gradinit{g}, sprintf('},{0,0,0},KS_GRADWAVE_RELATIVE,KS_INITVALUE(KS_MAXINSTANCES, KS_INIT_SEQLOC),NULL,NULL,NULL}'));
      end
   end
   
   
   
   %%%%%%%%%%%%%%%% omega %%%%%%%%%%%%%%%%
   clear omega
   
   if exist(fullfile(rflocation, [rfpulses(j).filename, '.frq']),'file')
      oext = '.frq';
   elseif exist(fullfile(rflocation, [rfpulses(j).filename, '.omega']),'file')
      oext = '.omega';
   else
      oext = '';
   end
   
   if ~isempty(oext)
      gfp = fopen(fullfile(rflocation, [rfpulses(j).filename,oext]), 'r','b');
      fseek(gfp, 32*2,'bof');
      omega = fread(gfp, rfpulses(j).res, 'short') / 32766;
      fclose(gfp);
      
      omegainit = sprintf(',{{0,0,NULL,sizeof(KS_WAVE)},KS_INIT_DESC,');
      omegainit = strcat(omegainit, sprintf('%d,',numel(omega))); % res
      omegainit = strcat(omegainit, sprintf('%d,{',rfpulses(j).nom_pw)); % duration
      % KS_WAVEFORM
      for k = 1:numel(omega)
         if abs(omega(k)) < 1e-5
            omegainit = strcat(omegainit, '0');
         elseif omega(k) > 0.999999
            omegainit = strcat(omegainit, '1');
         elseif omega(k) < -0.999999
            omegainit = strcat(omegainit, '-1');
         else
            omegainit = strcat(omegainit, sprintf('%.5f', omega(k)));
         end
         if k < numel(omega),omegainit = strcat(omegainit, ',');end
      end
      omegainit = strcat(omegainit, sprintf('},{0,0,0},KS_NOTSET,KS_INITVALUE(KS_MAXINSTANCES, KS_INIT_SEQLOC),NULL,NULL,NULL}'));
   end
   
   
   
   %%%%%%%%%%%%%%%% theta %%%%%%%%%%%%%%%%
   clear theta 
   
   if exist(fullfile(rflocation, [rfpulses(j).filename, '.pha']),'file')
      thext = '.pha'; 
   elseif exist(fullfile(rflocation, [rfpulses(j).filename, '.the']),'file')
      thext = '.the'; 
   elseif exist(fullfile(rflocation, [rfpulses(j).filename, '.theta']),'file')
      thext = '.theta';
   else
      thext = '';
   end
   
   if ~isempty(thext)
         gfp = fopen(fullfile(rflocation, [rfpulses(j).filename,thext]), 'r','b');
         fseek(gfp, 32*2,'bof');
         theta = fread(gfp, rfpulses(j).res, 'short') / 32766 * 180; % [degrees]
         fclose(gfp);
         
         thetainit = sprintf(',{{0,0,NULL,sizeof(KS_WAVE)},KS_INIT_DESC,');
         thetainit = strcat(thetainit, sprintf('%d,',numel(theta))); % res
         thetainit = strcat(thetainit, sprintf('%d,{',rfpulses(j).nom_pw)); % duration
         % KS_WAVEFORM
         for k = 1:numel(theta)
            thetainit = strcat(thetainit, sprintf('%.3f', theta(k)));
           if k < numel(theta),thetainit = strcat(thetainit, ',');end
         end
         thetainit = strcat(thetainit, sprintf('},{0,0,0},KS_NOTSET,KS_INITVALUE(KS_MAXINSTANCES, KS_INIT_SEQLOC),NULL,NULL,NULL}'));     
   end
   
      
   % put rfwave init in rf
   rfinit = strcat(rfinit, rfwaveinit);
   
   % put omegawave init in rf
   if ~isempty(oext)
      rfinit = strcat(rfinit, omegainit);
   elseif strncmp(rfpulses(j).type,'spsp',4) && ~isempty(gext)
      rfinit = strcat(rfinit, ',');
      rfinit = strcat(rfinit, gradinit{1});
   else
      rfinit = strcat(rfinit, ',KS_INIT_WAVE');
   end
   
   % put thetawave init in rf
   if ~isempty(thext)
      rfinit = strcat(rfinit, thetainit);
   else
      rfinit = strcat(rfinit, ',KS_INIT_WAVE');
   end    
   
   % end part of KS_INIT_RF
   rfinit = strcat(rfinit, sprintf('};'));
   
   fprintf(fp, '/**  <img align=left src=%s_%s.png border=2 width=350 height=270> */\n',rfpulses(j).type, rname);
   fprintf(fp, rfinit);
   fprintf(fp, '\n');
   
   
   for g = 1:numel(gext)
      fprintf(fp, '\nconst KS_WAVE %s_%s%s = %s;\n', rfpulses(j).type, rname, gsuffix{g}, gradinit{g});
   end
   
   fprintf(fp, '\n');
   
   fprintf('.');
end

fprintf(fp,'\n#endif /* KSF_GERF_H */\n');


fclose(fp);

fprintf('\nWriting done: %s\n', fname);


