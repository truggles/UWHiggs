
log = condor.log
notification = never
getenv = true
## make sure AFS is accessible and suppress the default FilesystemDomain requirements of Condor
requirements = HasAFS_OSG && TARGET.FilesystemDomain =!= UNDEFINED && TARGET.UWCMS_CVMFS_Revision >= 0 && TARGET.CMS_CVMFS_Revision >= 0


executable = /afs/hep.wisc.edu/cms/stephane/mssm_limits/src/cards_extrap/eeet/300/300_0.sh
output = /afs/hep.wisc.edu/cms/stephane/mssm_limits/src/cards_extrap/eeet/300/300_0.stdout
error = /afs/hep.wisc.edu/cms/stephane/mssm_limits/src/cards_extrap/eeet/300/300_0.stderr
queue
