cd
rm -rf gwttoolkit
git svn clone --stdlayout --username smallet@talend.com http://talendforge.org/svn/commons/gwttoolkit gwttoolkit
cd gwttoolkit
java -Dfile.encoding=utf-8 -jar ../svn-migration-scripts.jar clean-git --force
git remote add origin ssh://git@bitbucket.org/talend/gwt-toolkit.git
git push --all
