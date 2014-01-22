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
rake fakerates
rake fits
rake analyzezh
#rake plots
#rake mmtt
#rake mmtt_ggzz
#rake eeem_ggzz
#rake data_only_mmmt
#rake eett
#rake mmtt
#rake mmtt_signal_only

