#!/bin/sh

echo "VERSION 0.3"

#
# $1 repository i.e.: git.tools.f4.htw-berlin.de
# $2 own username
# $3 own password
# $4 username of owner of repo
# $5 reponame
# $6 username dvc
# $7 server to dvc
# $8 password of ssh access to dvc
# $9 git branchname to checkout
# $10 path to dvc server





# clone repository
git clone https://$2:$3@$1/$4/$5/

a=$?
if [ $a -gt 0 ]
then
    echo "ERROR: by cloning the git repository"
    exit $a
fi


echo $(ls)


# go in folder of repository
cd $5

a=$?
if [ $a -gt 0 ]
then
    echo "ERROR: by changing the directory to the git repository"
    exit $a
fi

echo $(ls)

echo "\n['remote \"nas\"']\nurl = ssh://$6@$7${10}\npassword = '$8'\n\n[core]\nremote = nas" > .dvc/config.local
#echo "\n['remote \"nas\"']\nurl = ssh://$6@$7\npassword = '$8'\ndir = "${10}"\n\n[core]\nremote = nas" > .dvc/config.local

a=$?
if [ $a -gt 0 ]
then
    echo "ERROR: by writing the .dvc/config.local file. Is this really a DVC-Git-Repository?"
    exit $a
fi


echo $(ls)

git checkout $9

a=$?
if [ $a -gt 0 ]
then
    echo "ERROR: by checkout to git-branch. Does this really exist?"
    exit $a
fi


echo $(ls)

dvc pull

a=$?
if [ $a -gt 0 ]
then
    echo "ERROR: by pulling from the DVC server. Maybe wrong path, username or password"
    exit $a
fi




dvc repro -P

a=$?
if [ $a -gt 0 ]
then
    echo "ERROR: by using the command dvc repro -P, maybe there is a programming error in your code."
    exit $a
fi




git commit -m 'run all pipelines'

a=$?
if [ $a -gt 0 ]
then
    echo "ERROR: it could not be commited to git"
    exit $a
fi






git commit -m 'run all pipelines'

a=$?
if [ $a -gt 0 ]
then
    echo "ERROR: it could not be commited to git"
    exit $a
fi




dvc commit

a=$?
if [ $a -gt 0 ]
then
    echo "ERROR: it could not be commited to dvc"
    exit $a
fi







dvc push

a=$?
if [ $a -gt 0 ]
then
    echo "ERROR: it could not be pushed to dvc server"
    exit $a
fi





git push https://$2:$3@$1/$4/$5 --all


git push

a=$?
if [ $a -gt 0 ]
then
    echo "ERROR: it could not be pushed to git server"
    exit $a
fi




return 0 
