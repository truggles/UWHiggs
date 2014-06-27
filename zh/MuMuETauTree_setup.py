
# Tools to compile cython proxy class
from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

setup(ext_modules=[Extension(
    "MuMuETauTree",                 # name of extension
    ["MuMuETauTree.pyx"], #  our Cython source
    include_dirs=['/cvmfs/cms.cern.ch/slc5_amd64_gcc462/cms/cmssw/CMSSW_5_3_9/external/slc5_amd64_gcc462/bin/../../../../../../lcg/root/5.32.00-cms21/include'],
    library_dirs=['/cvmfs/cms.cern.ch/slc5_amd64_gcc462/cms/cmssw/CMSSW_5_3_9/external/slc5_amd64_gcc462/bin/../../../../../../lcg/root/5.32.00-cms21/lib'],
    libraries=['Tree', 'Core', 'TreePlayer'],
    language="c++")],  # causes Cython to create C++ source
    cmdclass={'build_ext': build_ext})
