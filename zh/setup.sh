#!/bin/bash

# Setup the cython proxies, find input ntuple files, and compute luminosity.

source jobid.sh
#export datasrc=/hdfs/store/user/stephane/
#export datasrc=/nfs_scratch/stephane/data
export datasrc=$CMSSW_BASE/src/UWHiggs/zh/inputs/2014-02-28_8TeV_Ntuples-v2/
export jobid=$jobid8
#export afile=`find $datasrc/$jobid | grep root | head -n 1`

#make sure that this file is new if you made new variables in Ntuples, also run the top 8 "make_wrapper" functions and ls *pyx
# new svFit file
export afile='/nfs_scratch/truggles/2015-01-01_DataNtups/data_DoubleElectron_Run2012A_22Jan2013_v1/make_ntuples_cfg-patTuple_cfg-003EC246-5E67-E211-B103-00259059642E.root'

#echo "Building cython wrappers from file: $afile"
#
#rake "make_wrapper[$afile, eeem/final/Ntuple, EEEMuTree]"
#rake "make_wrapper[$afile, eeet/final/Ntuple, EEETauTree]"
#rake "make_wrapper[$afile, eemt/final/Ntuple, EEMuTauTree]"
#rake "make_wrapper[$afile, eett/final/Ntuple, EETauTauTree]"
#rake "make_wrapper[$afile, emmm/final/Ntuple, EMuMuMuTree]"
#rake "make_wrapper[$afile, emmt/final/Ntuple, MuMuETauTree]"
#rake "make_wrapper[$afile, mmmt/final/Ntuple, MuMuMuTauTree]"
#rake "make_wrapper[$afile, mmtt/final/Ntuple, MuMuTauTauTree]"
#
### Legacy for 3lepton  channels
###rake "make_wrapper[$afile, eem/final/Ntuple, EEMuTree]"
###rake "make_wrapper[$afile, eee/final/Ntuple, EEETree]"
###rake "make_wrapper[$afile, emm/final/Ntuple, MuMuETree]"
###rake "make_wrapper[$afile, mmm/final/Ntuple, MuMuMuTree]"
##
##
#ls *pyx | sed "s|pyx|so|" | xargs rake 

echo "done?"

echo "getting meta info"

echo "rake meta:getinputs[$jobid, $datasrc]"
rake "meta:getinputs[$jobid, $datasrc, "mmtt"]"
#rake "meta:getmeta[inputs/$jobid, mm/metaInfo, 7]"
#echo "done getting input files"
export jobid=$jobid8
rake "meta:getinputs[$jobid, $datasrc]"
# Use the 7TeV WH samples for 8TeV
pushd inputs/$jobid/
# Symlink the list of input files and the counts of the number of events.
# For the effectively lumis, we have to recompute using the 8 TeV x-section.
#ls ../../inputs/$jobid7/WH_*HWW* | grep -v lumicalc | xargs -n 1 ln -s 
popd
rake "meta:getmeta[inputs/$jobid, eett/metaInfo, 8]"
echo "done"

