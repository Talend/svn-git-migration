#!/bin/sh
workPath="$1"

if [ "$#" -lt 1 ]; then
	echo "Please provide the branch root path, also must be absolute path."
	exit 1
fi


for rep in tos tis_shared tis_private top tdq tom tem datastewardship
do
	cd "${workPath}/${rep}"
	git svn fetch
	git svn rebase --local
done
