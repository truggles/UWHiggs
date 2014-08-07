#!/bin/bash
# Run all of the analysis

set -o nounset
set -o errexit

source jobid.sh

#export jobid=$jobid7
#rake fakerates
#rake fits
#rake analyzezh

export jobid=$jobid8
#rake fakerates --trace
#rake fits --trace
#rake analyzezh_fullsim --trace
#rake analyzezh_fullsim_madgraph
#rake analyzezh_data
#rake analyzezh_signal
#rake analyzezh_ks
#rake analyzezh_ggzz
rake analyzezh --trace
#rake mmmt_fs
#rake eett_fs
#rake plots --trace
#rake cards
#rake limits
#rake mmtt
#rake mmtt_ggzz
#rake eeem_ggzz
#rake data_only_mmmt
#rake eett
#rake mmtt
#rake mmtt_signal_only

