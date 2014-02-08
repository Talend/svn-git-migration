#! /bin/bash
cd ../migration_data/branches

for sortedFile in $(find . -type f -name "*.sorted")
do
	sort $sortedFile > ${sortedFile}.tmp
	rm -rf ${sortedFile}
	mv ${sortedFile}.tmp $sortedFile
done

