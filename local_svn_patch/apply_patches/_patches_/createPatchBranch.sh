#!/bin/bash

gitRootPath=$1
gitTagBaseName=$2
patchBranchName=$3

#gitTagBaseName="release-5_4_1"
#patchBranchName="patch/v5.4.1"

cd "${gitRootPath}/tamc-ee"
echo -e "\n ----> $(pwd)"
git checkout -b ${patchBranchName} ${gitTagBaseName}_tis_shared

cd "${gitRootPath}/tbd-studio-ee"
echo -e "\n ----> $(pwd)"
git checkout -b ${patchBranchName} ${gitTagBaseName}_tis_shared

cd "${gitRootPath}/tbd-studio-se"
echo -e "\n ----> $(pwd)"
git checkout -b ${patchBranchName} ${gitTagBaseName}_tos

cd "${gitRootPath}/tcommon-studio-ee"
echo -e "\n ----> $(pwd)"
git checkout -b ${patchBranchName} ${gitTagBaseName}_tis_shared
git merge --no-commit ${gitTagBaseName}_tis_private
git add .
git commit -m "Merged ${gitTagBaseName}_tis_private and ${gitTagBaseName}_tis_shared"
git merge --no-commit ${gitTagBaseName}_tos
git add .
git commit -m "Merged ${gitTagBaseName}_tos and ${gitTagBaseName}_tis_shared and ${gitTagBaseName}_tis_private"

cd "${gitRootPath}/tcommon-studio-se"
echo -e "\n ----> $(pwd)"
git checkout -b ${patchBranchName} ${gitTagBaseName}_tos
git merge --no-commit ${gitTagBaseName}_tis_shared
git add .
git commit -m "Merged ${gitTagBaseName}_tis_shared and ${gitTagBaseName}_tos"

cd "${gitRootPath}/tdi-studio-ee"
echo -e "\n ----> $(pwd)"
git checkout -b ${patchBranchName} ${gitTagBaseName}_tis_shared

cd "${gitRootPath}/tdi-studio-se"
echo -e "\n ----> $(pwd)"
git checkout -b ${patchBranchName} ${gitTagBaseName}_tos

cd "${gitRootPath}/tdq-studio-ee"
echo -e "\n ----> $(pwd)"
git checkout -b ${patchBranchName} ${gitTagBaseName}_tdq
git merge --no-commit ${gitTagBaseName}_tis_shared
git add .
git commit -m "Merged ${gitTagBaseName}_tis_shared and ${gitTagBaseName}_tdq"
git merge --no-commit ${gitTagBaseName}_tos
git add .
git commit -m "Merged ${gitTagBaseName}_tos and ${gitTagBaseName}_tis_shared and ${gitTagBaseName}_tdq"

cd "${gitRootPath}/tdq-studio-se"
echo -e "\n ----> $(pwd)"
git checkout -b ${patchBranchName} ${gitTagBaseName}_top
git merge --no-commit ${gitTagBaseName}_tos
git add .
git commit -m "Merged ${gitTagBaseName}_tos and ${gitTagBaseName}_top"

cd "${gitRootPath}/tesb-studio-ee"
echo -e "\n ----> $(pwd)"
git checkout -b ${patchBranchName} ${gitTagBaseName}_tis_shared

cd "${gitRootPath}/tesb-studio-se"
echo -e "\n ----> $(pwd)"
git checkout -b ${patchBranchName} ${gitTagBaseName}_tos

cd "${gitRootPath}/tmdm-server-ee"
echo -e "\n ----> $(pwd)"
git checkout -b ${patchBranchName} ${gitTagBaseName}

cd "${gitRootPath}/tmdm-server-se"
echo -e "\n ----> $(pwd)"
git checkout -b ${patchBranchName} ${gitTagBaseName}

cd "${gitRootPath}/tmdm-studio-ee"
echo -e "\n ----> $(pwd)"
git checkout -b ${patchBranchName} ${gitTagBaseName}_tem
git merge --no-commit ${gitTagBaseName}_tis_shared
git add .
git commit -m "Merged ${gitTagBaseName}_tis_shared and ${gitTagBaseName}_tem"


cd "${gitRootPath}/tmdm-studio-se"
echo -e "\n ----> $(pwd)"
git checkout -b ${patchBranchName} ${gitTagBaseName}_tom
git merge --no-commit ${gitTagBaseName}_tem
git add .
git commit -m "Merged ${gitTagBaseName}_tem and ${gitTagBaseName}_tom"


cd "${gitRootPath}/toem-studio-ee"
echo -e "\n ----> $(pwd)"
git checkout -b ${patchBranchName} ${gitTagBaseName}_tis_shared

cd "${gitRootPath}/toem-studio-se"
echo -e "\n ----> $(pwd)"
git checkout -b ${patchBranchName} ${gitTagBaseName}_tos
