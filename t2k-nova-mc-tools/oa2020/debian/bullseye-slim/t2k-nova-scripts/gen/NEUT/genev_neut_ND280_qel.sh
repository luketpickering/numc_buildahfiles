#!/bin/bash

if [ -z $1 ]; then
  echo "Please pass a number of events to generate."
  exit 1
fi

BEAMMODE="FHC"
NU_PDG=14
FLUX_FILE=${ND280FLUX_NUMODE_FILE}
FLUX_HIST=${ND280FLUX_NUMODE_HIST}
if [ ! -z $2 ] && [ "${2}" == "RHC" ]; then
  echo "Running with "
  NU_PDG=-14
  FLUX_FILE=${ND280FLUX_NUBARMODE_FILE}
  FLUX_HIST=${ND280FLUX_NUBARMODE_HIST}
  BEAMMODE="RHC"
fi

NEVS=$1
TARG_N=6
TARG_Z=6
TARG_H=1
TARG_A=12
MDLQE=402

RUNNUM=${RANDOM}

if [ -e ND280.qel.${BEAMMODE}.${RUNNUM}.neut.root ]; then
   echo "Already have file: ND280.qel.${BEAMMODE}.${RUNNUM}.neut.root, not overwriting."
   exit 1
fi

#if it was sourced as . setup.sh then you can't scrub off the end... assume that
#we are in the correct directory.
if ! echo "${BASH_SOURCE}" | grep "/" --silent; then
  SETUPDIR=$(readlink -f $PWD)
else
  SETUPDIR=$(readlink -f ${BASH_SOURCE%/*})
fi

cp ${SETUPDIR}/qel.stub.card ND280.qel.${BEAMMODE}.card.cfg
for i in NEVS TARG_N \
         TARG_Z \
         TARG_H \
         TARG_A \
         NU_PDG \
         FLUX_FILE \
         FLUX_HIST \
         MDLQE; do
  sed -i "s|__${i}__|${!i}|g" ND280.qel.${BEAMMODE}.card.cfg
done
mv ND280.qel.${BEAMMODE}.card.cfg ND280.qel.${BEAMMODE}.card

echo "Running neutroot2 ND280.qel.${BEAMMODE}.card ND280.qel.${BEAMMODE}.${RUNNUM}.neut.root for ${NEVS} events."
neutroot2 ND280.qel.${BEAMMODE}.card ND280.qel.${BEAMMODE}.${RUNNUM}.neut.root &> /dev/null

if [ -e ND280.qel.${BEAMMODE}.${RUNNUM}.neut.root ]; then
   rm -f fort.77 ND280.qel.${BEAMMODE}.card

   PrepareNEUT -i ND280.qel.${BEAMMODE}.${RUNNUM}.neut.root \
               -f ${FLUX_FILE},${FLUX_HIST} -G
else
   echo "Failed to produce expected output file: ND280.qel.${BEAMMODE}.${RUNNUM}.neut.root"
   exit 1
fi
