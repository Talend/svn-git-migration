#!/bin/bash
if [ $# -lt 1 ]; then 
	echo "Must provide the path of git root repository."
	exit 1
fi
gitRootPath=$1

cd $gitRootPath

echo -e ">>> Starting to check tags ...\n"


for rep in $(ls)
do
    fullPath=$gitRootPath/$rep

    #directory, ignore files in current path.
    if [ -d $fullPath ]; then
	cd $fullPath

	#check the git log
	testResult=$(git log -1 2>/dev/null)

	if [ "X${testResult}" != "X" ]; then #not empty, means in git 
	   echo ">>> @@ Check the tags for $rep"
	   
	   tags=$(git tag | grep "^release/") # release/5.4.1/tis_shared
	   preTags=$(for tmp in $tags; do echo ${tmp%/*}; done | sort | uniq ) #release/5.4.1
	   for shortTag in $preTags;
	   do
	   	# if have been release/5.4.1, so ignore.
	   	if [ "$shortTag" = "release" ]; then
	   		continue
	   	fi
	   	echo "    >>>@@@  $shortTag"
	   	#try to find the full matched short tag release/5.4.1
	   	found=$(for tmp in $tags; do echo $tmp; done | grep "^${shortTag}$") 
	   	if [ "X$found" = "X" ];then #not existed, create it
	   		# all tages contained the same prefix(release/5.4.1), release/5.4.1/tos, release/5.4.1/tis_shared, etc
		   	samePreTags=$(for tmp in $tags; do echo $tmp; done | grep $shortTag)
			#
			firstTag=
			for gitTag in ${samePreTags};
			do 
				if [ "X$firstTag" = "X" ]; then # fist one
					echo "    >>>### git checkout -b tmp_$shortTag $gitTag"
					git checkout -b tmp_$shortTag $gitTag
					firstTag=$gitTag
				else # merge other tags release/5.4.1/***
					echo "    >>>### git merge --no-commit $gitTag"
					git merge --no-commit $gitTag					
					git add .
					git commit -m "Merge $firstTag and $gitTag for $shortTag."
				fi
				#delete old tags release/5.4.1/***
				echo "    >>>### git tag -d $gitTag"
				git tag -d $gitTag
				#delete the remote one too.
				echo "    >>>### git push origin :/refs/tags/$gitTag"
				git push origin :refs/tags/$gitTag
			   	
			done
			
			#create new tag release/5.4.1
			git tag $shortTag
			#switch to master, then delete the tmp branch for tag.
			git checkout master
			git branch -D tmp_$shortTag 
			
		   	
	   	else
	   		echo "      Have existed the tag $shortTag"
	   		
	   	fi
	   	
	   done
	   # push tags
	   git push --tags
	   
	fi
    fi
     
done

echo -e "\nFinished to check tags. <<<<\n"
