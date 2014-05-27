SVN 2 Git Migration
===
This project contains the script and data files for performing complex migration from svn to git.
When I say complex I mean many svn repos to many git repos with split and merge of folders.

### Prerequisit
You need to run this script in a Unix like OS (not Windows except if you fix the script or manage to install the following utilities).
the script requires the following tools to be installed

* git (with svn module: `# apt-get install git-svn`)
* ant (`# apt-get install ant`). Engine to run the script
* curl (`# apt-get install curl`). Used to call bitbucket REST APIs to delete and create remote repositories.
* this GIT repository (`$ git clone https://bitbucket.org/talend/talend-svn-git-migration.git`).

### Main script

the main script can be found at the root of the repo in 
**build.xml**

all repos are found according to the java property **repo.root.folder**, by default the repo.root.folder is set to the parent folder of the git repository.

### Preparing the Svn Git clones
Before launching the migration script you need to clone locally the svn repositories you need to migrate. Please follow the Atlassian tuto [here](https://www.atlassian.com/git/migration#!migration-convert).
You must create svn git clone in 

    ${repo.root.folder}/svn_git_repos
please be sure to follow the full Atlassian tuto including the clean phase

    java -Dfile.encoding=utf-8 -jar talend-svn-git-migration/svn-migration-scripts.jar clean-git --force

###Preparing the migration data
The main script takes a folder path as an input to know what to migrate and where to migrate it. this folder should look like this.

    .
    ├── branches
    │   ├── branch-5_4                 (name of any branch we want to keep)
    │   │   ├── tdq2tdq-studio-ee.txt  (data file)
    │   ├── master                     (this branch must exists)
    │   │   ├── tdq2tdq-studio-ee.txt
    │   │   ├── tem2tmdm-studio-ee.txt
    │   │   ├── tem2tmdm-studio-se.txt
    ├── migration_ant.properties        (properties for the main migration script)
    ├── refactor_ant.xml                (optional ant script for refactor)
 
1. The folder *branches* must contain at least the *master* folder representing the master branch and any other folder will represent other branches that we wishes to keep in git.

2. Data files are files containing the root folder and file that we want to keep. Those files follow the pattern : ` <svn_git_repo_name>2<git_repo_name>.txt`
where

 * *svn\_git\_repo\_name* is the name of the svn_git repository located in `${repo.root.folder}/svn_git_repos`
 * *git\_repo\_name* is the name of the final git repository we want to place the files into.

3. *migration\_ant.properties* is a java properties formatted file with a simple set of properties for the main script to work.
here is an example

    list.of.branches.no.master=branch-5_4  
    list.of.branches=${list.of.branches.no.master},master  
    list.of.tags=release-5_4_0,release-5_4_1  
    tuj.skip.refactor=true  
    history.date.limit=2011-09-05


###Launching the migration
for BitBucket
    cd talend-svn-git-migration
    ant -Dmigration.data.folder.path=you_migration_data_folder -Dremote.git.username=you_user_name -Dremote.git.password=your_password -lib ant-contrib-1.0b3.jar  | tee you_migration_data_folder/migration.log
for Github
    cd talend-svn-git-migration
    ant -Dtalend.remote.git.base.url=git@github.com:Talend -Dgithub.authorisation.token=<your_authorisation_token> -Dmigration.data.folder.path=studio/migration_data -lib ant-contrib-1.0b3.jar  | tee studio/migration_data/migration.log


* you\_migration\_data\_folder : the folder that contain all the migration data files (see the above chapter for content)
* you\_user\_name : is the user name used in bitbucket to create remote repositories (you can simply adapt the script to use Github if you wish)
* your\_password : the password used to create the remote repository.


###What does the script
* Fetches the latest commit from the remote svn server.
* create git tags and branches from the svn tags and branches.
* creates a git graft file to remove old history is the property *history.date.limit* is set.
* copies the required svn_repo into the `${repo.root.folder}/migration_workspace` for one single final git repo. It uses the migration data file to remove the no-required folders and files for each branches.
* strips files bigger than 1M from history (but this is subject to change)
* merges all the workspace repos into the final git repository `${repo.root.folder}/final_repos/<the_final_git_repo>`.
* delete/create the remote git repository
* pushes all branches and tags to the remote repository.