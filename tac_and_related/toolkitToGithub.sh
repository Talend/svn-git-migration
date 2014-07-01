init_clone() {
cd test_tac_size/
rm -rf gwt-toolkit/
git clone git@bitbucket.org:talend/gwt-toolkit.git
cp gwt-toolkit/ gwt-toolkit_orig/ -r
cd gwt-toolkit/
}

init_cp() {
cd test_tac_size/
rm -rf gwt-toolkit/
cp gwt-toolkit_orig/ gwt-toolkit/ -r
cd gwt-toolkit
}

branches() {
echo
echo ====================================================
echo Rename maintenance branches
echo ====================================================
for branch in branch-1_5 branch-1_4 branch-1_3;
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

push() {
echo
echo ====================================================
echo Change remote from bitbucket to github
echo ====================================================
git remote rm origin
git remote add origin git@github.com:Talend/gwt-toolkit.git

echo '--->' pushing branches
git push -u origin --all
echo '--->' pushing tags
git push -u origin --tags
}

cd ~
#init_cp
init_clone
branches
push
