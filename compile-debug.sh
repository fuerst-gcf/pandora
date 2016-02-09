#!/bin/bash
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/hdf5/target/lib/
export PANDORAPATH=$HOME/pandora/target
export PATH=$PATH:$PANDORAPATH/bin/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PANDORAPATH/lib/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/openmpi/lib
export PATH=$PATH:/opt/openmpi/bin

cd $HOME/pandora
rm -r ./lib
rm -r ./target/lib/libpandorad.*
scons hdf5=$HOME/hdf5/target debug=1 -j 8
scons install installDir=$HOME/pandora/target hdf5=$HOME/hdf5/target debug=1 $1
