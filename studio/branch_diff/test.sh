for branches in 5_0 5_1 5_2 5_3 5_4
do
	for repo in tos top tom tis_shared tis_private tdq tem 
	do 
		echo "$branches $repo" 
		svn list --depth immediates http://talendforge.org/svn/$repo/branches/branch-$branches/ > $repo.$branches
	done
done

