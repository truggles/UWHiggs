#!/bin/bash

cd /afs/hep.wisc.edu/cms/stephane/mssm_limits/src/cards_extrap/eeet
eval `scram runtime -sh`

echo "Running limit.py:"
echo "with options --tanb+  --working-dir=${_CONDOR_SCRATCH_DIR}"
echo "in directory 300"

echo "Copy 300 --> ${_CONDOR_SCRATCH_DIR}/92I09JX4L6/300"
mkdir -p ${_CONDOR_SCRATCH_DIR}/92I09JX4L6
cp -r 300 ${_CONDOR_SCRATCH_DIR}/92I09JX4L6/300
cp -r common ${_CONDOR_SCRATCH_DIR}/92I09JX4L6

echo "Running"
$CMSSW_BASE/src/HiggsAnalysis/HiggsToTauTau/scripts/limit.py --tanb+  --working-dir=${_CONDOR_SCRATCH_DIR} ${_CONDOR_SCRATCH_DIR}/92I09JX4L6/300

echo "Copy ${_CONDOR_SCRATCH_DIR}/92I09JX4L6/300 --> 300 (root output files only)"
cp ${_CONDOR_SCRATCH_DIR}/92I09JX4L6/300/*.root* 300
cp ${_CONDOR_SCRATCH_DIR}/92I09JX4L6/300/.scan 300
cp ${_CONDOR_SCRATCH_DIR}/92I09JX4L6/300/*.png 300
if [ -d ${_CONDOR_SCRATCH_DIR}/92I09JX4L6/300/out ] ;
  then
    mkdir -p /300/out ;
    cp -u ${_CONDOR_SCRATCH_DIR}/92I09JX4L6/300/out/*.* /300/out ;
fi
rm -r ${_CONDOR_SCRATCH_DIR}/92I09JX4L6
