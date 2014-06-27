#!/usr/bin/env condor_submit
log = condor.log
notification = never
getenv = true
## make sure AFS is accessible and suppress the default FilesystemDomain requirements of Condor
requirements = HasAFS_OSG && TARGET.FilesystemDomain =!= UNDEFINED && TARGET.UWCMS_CVMFS_Revision >= 0 && TARGET.CMS_CVMFS_Revision >= 0

