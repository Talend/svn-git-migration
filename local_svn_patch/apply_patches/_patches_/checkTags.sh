#!/bin/bash


workRootPath=$(cd $(dirname $0); pwd)
gitRootPath="$workRootPath/../"
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
	   
	   tags=$(git tag) # process release-5_x_y_tis_shared
	   preTags=$(for tmp in $tags; do echo ${tmp:0:13}; done| sort | uniq )
	   for shortTag in $preTags;
	   do
	   	
	   	echo "    >>>@@@  $shortTag"
	   	#try to find the full matched short tag 
	   	found=$(for tmp in $tags; do echo $tmp; done | grep "^${shortTag}$") 
	   	if [ "X$found" = "X" ];then #not existed, create it
	   		# all tages contained the same prefix(shortTag)
		   	samePreTags=$(for tmp in $tags; do echo $tmp; done | grep $shortTag)
			#
			preTag=
			for gitTag in ${samePreTags};
			do 
				if [ "X$preTag" = "X" ]; then # fist one
					echo "    >>>### git checkout -b tmp_$shortTag $gitTag"
					git checkout -b tmp_$shortTag $gitTag
					preTag=$gitTag
				else
					echo "    >>>### git merge --no-commit $gitTag"
					git merge --no-commit $gitTag					
					git add .
					git commit -m "Merge $preTag and $gitTag for $shortTag."
				fi
				
				echo "    >>>### git tag -d $gitTag"
				#git tag -d $gitTag
			   	
			done
			
			git tag $shortTag
			git checkout $shortTag
			git branch -D tmp_$shortTag 
			
		   	
	   	else
	   		echo "      Have existed the tag $shortTag"
	   		
	   	fi
	   	
	   done
	   
	fi
    fi
     
done

echo -e "\nFinished to check tags. <<<<\n"
