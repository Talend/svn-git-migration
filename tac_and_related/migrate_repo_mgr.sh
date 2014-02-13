cd
rm -rf repo
git svn clone --stdlayout --username smallet@talend.com http://talendforge.org/svn/repository_manager repo
cd repo
java -Dfile.encoding=utf-8 -jar ../svn-migration-scripts.jar clean-git --force
git remote add origin ssh://git@bitbucket.org/talend/repository-manager.git
git push --all
