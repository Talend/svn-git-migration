#!/bin/sh
cd ../migration_data/branches

for sortedFile in $(find . -type f -name "*.txt")
do
	sort $sortedFile > ${sortedFile}.tmp
	rm -rf ${sortedFile}
	mv ${sortedFile}.tmp $sortedFile
done
