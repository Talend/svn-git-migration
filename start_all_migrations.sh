#!/bin/bash
#This launches all the Talend migrations from svn to git.

if [ -z $1 ]; then
  echo "You must specify the Github authentification token as a parameter of this script."
  exit 1;
fi

ant -Dtalend.remote.git.base.url=git@github.com:Talend -Dgithub.authorisation.token=$1 -Dmigration.data.folder.path=studio/migration_data -lib ant-contrib-1.0b3.jar  | tee ../final_repos/studio_migration.log
ant -Dtalend.remote.git.base.url=git@github.com:Talend -Dgithub.authorisation.token=$1 -Dmigration.data.folder.path=dqportal_migration_data -lib ant-contrib-1.0b3.jar  | tee ../final_repos/dqportal_migration.log
ant -Dtalend.remote.git.base.url=git@github.com:Talend -Dgithub.authorisation.token=$1 -Dmigration.data.folder.path=licence_security_migration_data -lib ant-contrib-1.0b3.jar  | tee ../final_repos/licence_security_migration.log
ant -Dtalend.remote.git.base.url=git@github.com:Talend -Dgithub.authorisation.token=$1 -Dmigration.data.folder.path=mdm_migration_data -lib ant-contrib-1.0b3.jar  | tee ../final_repos/mdm_migration.log
