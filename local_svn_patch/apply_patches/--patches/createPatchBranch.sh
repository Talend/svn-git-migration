#!/bin/sh

gitRootPath=$1
gitTagBaseName=$2
patchBranchName=$3

#gitTagBaseName="release-5_4_1"
#patchBranchName="patch/v5.4.1"

cd "${gitRootPath}/tamc-ee"
echo -e "\n ----> $(pwd)"
git branch ${patchBranchName} ${gitTagBaseName}_tis_shared
git checkout ${patchBranchName}

cd "${gitRootPath}/tbd-studio-ee"
echo -e "\n ----> $(pwd)"
git branch ${patchBranchName} ${gitTagBaseName}_tis_shared
git checkout ${patchBranchName}

cd "${gitRootPath}/tbd-studio-se"
echo -e "\n ----> $(pwd)"
git branch ${patchBranchName} ${gitTagBaseName}_tos
git checkout ${patchBranchName}

cd "${gitRootPath}/tcommon-studio-ee"
echo -e "\n ----> $(pwd)"
git branch ${patchBranchName} ${gitTagBaseName}_tis_shared
git checkout ${patchBranchName}
git merge ${gitTagBaseName}_tis_private
git rm pom.xml
git add .
git commit -m "Merged ${gitTagBaseName}_tis_private and ${gitTagBaseName}_tis_shared"
git merge ${gitTagBaseName}_tos
git rm pom.xml
git add .
git commit -m "Merged ${gitTagBaseName}_tos and ${gitTagBaseName}_tis_shared and ${gitTagBaseName}_tis_private"

cd "${gitRootPath}/tcommon-studio-se"
echo -e "\n ----> $(pwd)"
git branch ${patchBranchName} ${gitTagBaseName}_tos
git checkout ${patchBranchName}
git merge ${gitTagBaseName}_tis_shared
git rm pom.xml
git add .
git commit -m "Merged ${gitTagBaseName}_tis_shared and ${gitTagBaseName}_tos"

cd "${gitRootPath}/tdi-studio-ee"
echo -e "\n ----> $(pwd)"
git branch ${patchBranchName} ${gitTagBaseName}_tis_shared
git checkout ${patchBranchName}

cd "${gitRootPath}/tdi-studio-se"
echo -e "\n ----> $(pwd)"
git branch ${patchBranchName} ${gitTagBaseName}_tos
git checkout ${patchBranchName}

cd "${gitRootPath}/tdq-studio-ee"
echo -e "\n ----> $(pwd)"
git branch ${patchBranchName} ${gitTagBaseName}_tdq
git checkout ${patchBranchName}
git merge ${gitTagBaseName}_tis_shared
git rm pom.xml
git add .
git commit -m "Merged ${gitTagBaseName}_tis_shared and ${gitTagBaseName}_tdq"
git merge ${gitTagBaseName}_tos
git rm pom.xml
git add .
git commit -m "Merged ${gitTagBaseName}_tos and ${gitTagBaseName}_tis_shared and ${gitTagBaseName}_tdq"

cd "${gitRootPath}/tdq-studio-se"
echo -e "\n ----> $(pwd)"
git branch ${patchBranchName} ${gitTagBaseName}_top
git checkout ${patchBranchName}
git merge ${gitTagBaseName}_tos
git add .
git commit -m "Merged ${gitTagBaseName}_tos and ${gitTagBaseName}_top"

cd "${gitRootPath}/tesb-studio-ee"
echo -e "\n ----> $(pwd)"
git branch ${patchBranchName} ${gitTagBaseName}_tis_shared
git checkout ${patchBranchName}

cd "${gitRootPath}/tesb-studio-se"
echo -e "\n ----> $(pwd)"
git branch ${patchBranchName} ${gitTagBaseName}_tos
git checkout ${patchBranchName}

cd "${gitRootPath}/tmdm-server-ee"
echo -e "\n ----> $(pwd)"
git branch ${patchBranchName} ${gitTagBaseName}
git checkout ${patchBranchName}

cd "${gitRootPath}/tmdm-server-se"
echo -e "\n ----> $(pwd)"
git branch ${patchBranchName} ${gitTagBaseName}
git checkout ${patchBranchName}

cd "${gitRootPath}/tmdm-studio-ee"
echo -e "\n ----> $(pwd)"
git branch ${patchBranchName} ${gitTagBaseName}_tem
git checkout ${patchBranchName}
git merge ${gitTagBaseName}_tis_shared
git add .
git commit -m "Merged ${gitTagBaseName}_tis_shared and ${gitTagBaseName}_tem"


cd "${gitRootPath}/tmdm-studio-se"
echo -e "\n ----> $(pwd)"
git branch ${patchBranchName} ${gitTagBaseName}_tom
git checkout ${patchBranchName}
git merge ${gitTagBaseName}_tem
git add .
git commit -m "Merged ${gitTagBaseName}_tem and ${gitTagBaseName}_tom"


cd "${gitRootPath}/toem-studio-ee"
echo -e "\n ----> $(pwd)"
git branch ${patchBranchName} ${gitTagBaseName}_tis_shared
git checkout ${patchBranchName}

cd "${gitRootPath}/toem-studio-se"
echo -e "\n ----> $(pwd)"
git branch ${patchBranchName} ${gitTagBaseName}_tos
git checkout ${patchBranchName}

