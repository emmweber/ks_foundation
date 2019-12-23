/*
@ @licstart  The following is the entire license notice for the
JavaScript code in this file.

Copyright (C) 1997-2017 by Dimitri van Heesch

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

@licend  The above is the entire license notice
for the JavaScript code in this file
*/
var NAVTREE =
[
  [ "KSFoundation", "index.html", [
    [ "EPIC using KSFoundation", "index.html", [
      [ "Key features", "index.html#KeyFeatures", null ],
      [ "Quick Reference", "index.html#Reference", null ],
      [ "Installation", "index.html#Installation", [
        [ "Basic installation", "index.html#InstallationMain", null ],
        [ "Install DDD to debug in WTools (HOST & TGT)", "index.html#InstallationDbg", null ]
      ] ],
      [ "Sequences and modules", "index.html#SeqMod", [
        [ "Sequences written using KSFoundation EPIC", "index.html#Sequences", null ],
        [ "Sequence modules", "index.html#SeqModules", null ]
      ] ]
    ] ],
    [ "EPIC crash course", "_e_p_i_c_crashcourse.html", [
      [ "Compiling pulse sequences (PSDs) for the MR-scanner", "_e_p_i_c_crashcourse.html#ECCcompile", null ],
      [ "Simulation vs. Hardware", "_e_p_i_c_crashcourse.html#ECCsimhw", null ],
      [ "HOST vs. TGT", "_e_p_i_c_crashcourse.html#ECChosttgt", null ],
      [ "Mandatory code sections (@****) in *.e and their use", "_e_p_i_c_crashcourse.html#ECCmancode", null ],
      [ "Mandatory top-level functions in a PSD and what they do", "_e_p_i_c_crashcourse.html#Eccmantop", null ],
      [ "CVs (Control Variables)", "_e_p_i_c_crashcourse.html#ECCcv", null ],
      [ "@inline and %ifdef", "_e_p_i_c_crashcourse.html#ECCinline", null ]
    ] ],
    [ "Imakefile modifications for KSFoundation and to sense EPIC releases", "_imakefile.html", null ],
    [ "Known bugs", "_known_bugs.html", null ],
    [ "Phase encoding plans (KS_PHASEENCODING_PLAN)", "_phase_enc_plan.html", [
      [ "How the scan loop is organized", "_phase_enc_plan.html#peplan_scanloop", null ],
      [ "Workflow: Setup KS_PHASER first, then pass it/them to a ks_phaseencoding_generate*** function", "_phase_enc_plan.html#peplan_phasers", null ],
      [ "Summary (3D ksgre case)", "_phase_enc_plan.html#peplan_summary", null ],
      [ "Please contribute to new KS_PHASEENCODING_PLANs", "_phase_enc_plan.html#peplan_contribute", null ]
    ] ],
    [ "Plotting (HTML)", "_plotting.html", [
      [ "Requirements to make plotting work", "_plotting.html#plot_req", null ],
      [ "Where are your HTML plots?", "_plotting.html#plot_where", null ],
      [ "Sequence plotting on HOST (dry-running before TGT)", "_plotting.html#plot_host", null ],
      [ "Sequence plotting on TGT", "_plotting.html#plot_tgt", [
        [ "Example", "_plotting.html#plot_tgt_example", null ],
        [ "Customizing the plot", "_plotting.html#plot_custom", null ]
      ] ],
      [ "Slice-time plotting of multiple sequence modules", "_plotting.html#plot_slicetime", [
        [ "Example", "_plotting.html#plot_slicetime_example", null ]
      ] ]
    ] ],
    [ "Data Structures", "annotated.html", [
      [ "Data Structures", "annotated.html", "annotated_dup" ],
      [ "Data Fields", "functions.html", [
        [ "All", "functions.html", "functions_dup" ],
        [ "Variables", "functions_vars.html", "functions_vars" ]
      ] ]
    ] ],
    [ "Files", "files.html", [
      [ "File List", "files.html", "files_dup" ],
      [ "Globals", "globals.html", [
        [ "All", "globals.html", "globals_dup" ],
        [ "Functions", "globals_func.html", "globals_func" ],
        [ "Variables", "globals_vars.html", "globals_vars" ],
        [ "Typedefs", "globals_type.html", null ],
        [ "Enumerations", "globals_enum.html", null ],
        [ "Enumerator", "globals_eval.html", null ],
        [ "Macros", "globals_defs.html", null ]
      ] ]
    ] ]
  ] ]
];

var NAVTREEINDEX =
[
"_e_p_i_c_crashcourse.html",
"_k_s_foundation_8h.html#a4bd8f92bd97315429605430e234dceb4",
"_k_s_foundation_8h.html#addfe7afa496fc5757c450680db49dc5f",
"_k_s_foundation__host_8c.html#a17152525ac5b5d4593e423d016d41d29",
"_k_s_inversion_8e.html#ac7243c21c92994e98b1baf972465bde4",
"ksepi_8e.html#ab86d8a9c08d382dc537ec69e0f1cc9dc",
"ksgre__implementation_8e.html#a3db7939a5492a55fada202f44c2fc62a",
"struct_k_s_c_h_e_m_s_a_t___p_a_r_a_m_s.html#a26b4ce5286681394fce04d2803769a05"
];

var SYNCONMSG = 'click to disable panel synchronisation';
var SYNCOFFMSG = 'click to enable panel synchronisation';