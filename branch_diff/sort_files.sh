#! /bin/bash
files=`ls | grep trunk`
for file in $files;
do
  sort $file > $file.sorted
done


