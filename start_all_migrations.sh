#!/bin/bash
#This launches all the Talend migrations from svn to git.

if [ -z $1 ]; then
  echo "You must specify the Github authentification token as a parameter of this script."
  exit 1;
fi

ant -Dtalend.remote.git.base.url=git@github.com:Talend -Dgithub.authorisation.token=$1 -Dmigration.data.folder.path=studio/migration_data -lib ant-contrib-1.0b3.jar  | tee studio/migration_data/migration.log
ant -Dtalend.remote.git.base.url=git@github.com:Talend -Dgithub.authorisation.token=$1 -Dmigration.data.folder.path=studiodqportal_migration_data -lib ant-contrib-1.0b3.jar  | tee dqportal_migration_data/migration.log
ant -Dtalend.remote.git.base.url=git@github.com:Talend -Dgithub.authorisation.token=$1 -Dmigration.data.folder.path=licence_security_migration_data -lib ant-contrib-1.0b3.jar  | tee licence_security_migration_data/migration.log
ant -Dtalend.remote.git.base.url=git@github.com:Talend -Dgithub.authorisation.token=$1 -Dmigration.data.folder.path=mdm_migration_data -lib ant-contrib-1.0b3.jar  | tee mdm_migration_data/migration.log
