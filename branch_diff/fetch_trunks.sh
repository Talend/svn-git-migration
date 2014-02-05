	for repo in tos top tom tis_shared tis_private tdq tem 
	do 
		echo "trunk $repo" 
		svn list --depth immediates http://talendforge.org/svn/$repo/trunk/ > $repo.trunk
	done

