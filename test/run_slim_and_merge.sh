#! /bin/bash
source $CMSSW_BASE/src/FinalStateAnalysis/environment.sh
echo $@
slimAndMergeNtuple $@  