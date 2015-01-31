#!/bin/bash
# Run all of the analysis

date

# FR_tracker.txt is a text file to track duplicate events through the TauFakeRate process.
# We need to remove it to start fresh so that we can add new events.
rm -rfv FR_tracker.txt
echo "Removed FR_tracker.txt to start a fresh."

set -o nounset
set -o errexit

source jobid.sh

#export jobid=$jobid7
#rake fakerates
#rake fits
#rake analyzezh

export jobid=$jobid8
#rake fakerates
#rake fits
##rake analyzezh_A300_MG_svFit
##rake analyzezh_fullsim --trace
##rake analyzezh_fullsim_madgraph
##rake analyzezh_data
##rake analyzezh_signal
##rake analyzezh_ks
##rake analyzezh_ggzz
##rake analyzezh_ZZJetsTo4L
##rake analyzezh_mg
##rake analyzezh_A300FS
##rake mmem_A300FS
#rake analyzezh
##rake mmmt_fs
##rake eett_fs
#rake plots
rake cards
##rake cards_TES_Up
##rake cards_TES_Down
##rake limits
##rake mmtt
##rake mmtt_ggzz
##rake eeem_ggzz
##rake data_only_mmmt
##rake eett
##rake mmtt
##rake mmtt_signal_only

date
