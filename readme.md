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

###Launching the migration
    cd talend-svn-git-migration/studio
    ant -Dmigration.data.folder.path=you_migration_data_folder -Dremote.git.username=you_user_name -Dremote.git.password=your_password -lib ant-contrib-1.0b3.jar  -listener net.sf.antcontrib.perf.AntPerformanceListener

* you\_migration\_data\_folder : the folder that contain all the migration data files (see below)
* you\_user\_name : is the user name used in bitbucket to create remote repositories (you can simply adapt the script to use Github if you wish)
* your\_password : the password used to create the remote repository.