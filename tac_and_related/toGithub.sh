init_clone() {
cd test_tac_size/
rm -rf tac
git clone git@bitbucket.org:talend/tac.git
cp tac/ tac_orig/ -r
cd tac
}

init_cp() {
cd test_tac_size/
rm -rf tac
cp tac_orig/ tac/ -r
cd tac
}

tags() {
echo ====================================================
echo Rename tags
echo ====================================================
for tag in release-5_0_0 release-5_0_1 release-5_0_2 release-5_0_3 release-5_1_0 release-5_1_1 release-5_1_2 release-5_1_3 release-5_2_0 release-5_2_1 release-5_2_2 release-5_2_3 release-5_3_0 release-5_3_1 release-5_3_2 release-5_4_0 release-5_4_1;
do
  git checkout $tag --quiet
  echo '--->' delete tag $tag
  git tag -d $tag
  new_tag=`echo $tag | sed -e 's/_/./g' | sed -e 's/-/\//g'`
  echo '--->' add tag $new_tag
  echo
  git tag -a $new_tag -m "$new_tag"
done

echo
echo ====================================================
echo Remove some tags
echo ====================================================
git checkout master
for tag in `git tag -l release-*`;
do
  git tag -d $tag
done
}

branches() {
echo
echo ====================================================
echo Rename maintenance branches
echo ====================================================
for branch in branch-5_5 branch-5_4 branch-5_3 branch-5_2 branch-5_1 branch-5_0;
do
  git checkout $branch
  new_branch=`echo $branch | sed -e 's/_/./g' | sed -e 's/branch-/maintenance\//g'`
  echo '--->' rename branch $branch to $new_branch
  git branch -M $branch $new_branch
  echo 
done

echo
echo ====================================================
echo Checkout branches we like to keep
echo ====================================================
for branch in `git branch --list origin/bugfix/* origin/feature/* -r`;
do
  short_name=`echo $branch | sed -e 's/origin\///g'`
  echo '--->' checking out $short_name
  git checkout $short_name
  echo
done
}

clean_bfg() {
echo
echo ====================================================
echo Remove some big files with BFG
echo ====================================================
java -jar ~/talend-svn-git-migration/bfg-1.11.2.jar --delete-folders '{input,org.talend.selenium.tac.test,org.talend.designer.components.*,org.talend.gwttoolkit,org.talend.administrator_gwt,org.talend.administrator_gxt,DisplayTag}'
echo '--->' Cleaning after BFG
git reset --hard
git reflog expire --expire=now --all
git gc --prune=now --aggressive
rm -rf ../tac.bfg-report/
}

clean_filter_branch() {
echo
echo ====================================================
echo Remove some files with filter-branch
echo ====================================================
~/talend-svn-git-migration/tac_and_related/filter_branch.sh org.talend.gadget.admindashboard/war/WEB-INF/lib org.talend.gadget.admindashboard/lib
}

push() {
echo
echo ====================================================
echo Change remote from bitbucket to github
echo ====================================================
git remote rm origin
git remote add origin git@github.com:Talend/tac.git

echo '--->' pushing branches
git push -u origin --all
echo '--->' pushing tags
git push -u origin --tags
}

cd ~
#init_cp
init_clone
tags
branches
clean_bfg
clean_filter_branch
push
