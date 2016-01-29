
version = '0.0.1'

import os, platform, SCons
from distutils.version import LooseVersion

vars = Variables('custom.py')
vars.Add(BoolVariable('debug', 'compile with debug flags', 'no'))
vars.Add(BoolVariable('edebug', 'compile with extreme debug logs', 'no'))
vars.Add(BoolVariable('python2', 'use Python2.7 instead of Python3', 'no'))
vars.Add('installDir', 'directory where to install Pandora', '/usr/local/pandora')

if platform.system()=='Linux':
    vars.Add(PathVariable('hdf5', 'Path where HDF5 library was installed', '/usr/local/hdf5', PathVariable.PathIsDir))

env = Environment(variables=vars, ENV=os.environ, CXX='mpicxx')
if env['debug'] == False:
    env.VariantDir('build', '.')
else:
    env.VariantDir('buildDebug', '.')

Help(vars.GenerateHelpText(env))

env.Append(LIBS = 'pthread gdal hdf5 z tinyxml boost_filesystem boost_system boost_timer boost_chrono gomp mpl dl'.split())

env.Append(CCFLAGS = '-DTIXML_USE_STL -fopenmp -std=c++0x')

if platform.system()=='Darwin':
    env.Append(CCFLAGS = '-cxx=g++-4.8')
    env.Append(LINKFLAGS = '-undefined warning')

if env['debug'] == True:
    env.Append(CCFLAGS = '-g -Wall -DPANDORADEBUG')
    if env['edebug']==True:
        env.Append(CCFLAGS = '-DPANDORAEDEBUG')
    libraryName = 'pandorad.so'
else:
    env.Append(CCFLAGS = '-Ofast')
    libraryName = 'pandora.so'

coreFiles = [str(f) for f in Glob('src/*.cxx')]
analysisFiles = [str(f) for f in Glob('src/analysis/*.cxx')]
srcFiles = coreFiles + analysisFiles

coreHeaders = [str(f) for f in Glob('include/*.hxx')]
analysisHeaders = [str(f) for f in Glob('include/analysis/*.hxx')]

if env['debug'] == False:
    srcBaseFiles = ['build/' + src for src in srcFiles]
else:
    srcBaseFiles = ['buildDebug/' + src for src in srcFiles]

env.Append(CPPPATH = 'include include/analysis'.split())

if platform.system()=='Linux':
    env.Append(CPPPATH = [env['hdf5']+'/include', '/usr/include/gdal/'])
    env.Append(CPPPATH = [env['hdf5']+'/include'])
    env.Append(LIBPATH = [env['hdf5']+'/lib'])
elif platform.system()=='Darwin':
    env.Append(LIBPATH = '/usr/local/lib')


# versioned lib do not create correct links with .so in osx
if platform.system()=='Linux':
    sharedLib = env.SharedLibrary('lib/'+libraryName, srcBaseFiles, SHLIBVERSION=version)
elif platform.system()=='Darwin':
    sharedLib = env.SharedLibrary('lib/'+libraryName, srcBaseFiles)


# installation
installLibDir = env['installDir'] + '/lib/'
installHeadersDir = env['installDir'] + '/include/'
installAnalysisHeadersDir = installHeadersDir+'analysis'

installedLib = ""

if(LooseVersion(SCons.__version__) < LooseVersion("2.3.0")):
        installedLib = env.Install(installLibDir, sharedLib, SHLIBVERSION=version)
else:
        installedLib = env.InstallVersionedLib(installLibDir, sharedLib, SHLIBVERSION=version)


installedHeaders = env.Install(installHeadersDir, coreHeaders)
installedAnalysisHeaders = env.Install(installAnalysisHeadersDir, analysisHeaders)

installBin = env.Install(env['installDir'], Glob('./bin'))
installShare = env.Install(env['installDir'], Glob('./share'))
installMpiStub = env.Install(env['installDir']+'/utils', Glob('./utils/*.cxx'))

# cassandra
#cassandraCompilation = env.Command("bin/cassandra", "", "cd cassandra && qmake && make")
#if platform.system()=='Darwin':
#    cassandraCompilation = env.Command("bin/cassandra", "", "cd cassandra && qmake cassandra_osx.pro && make")

# final targets
Default(sharedLib)
#env.Alias('cassandra', cassandraCompilation)
env.Alias('install', [sharedLib, installedLib, installedHeaders, installedAnalysisHeaders, installBin, installShare, installMpiStub])

