#!/bin/bash

# Move project directory to home

project_path=${0%/*}
home_path=$(cd ~ && pwd)
destination_path="${home_path}/.mvvm"
if [ ! -d $destination_path ]
then
    cp -r $project_path $destination_path
    # remove git dir
    git_path="${destination_path}/.git"
    [ -d $git_path ] && rm -rf $git_path
    rc_file_path="${home_path}/.zshrc"
    echo $rc_file_path
    if [ -f $rc_file_path ]
    then
        echo -e "\nsource ~/.mvvm/run.sh" >> $rc_file_path
    fi
    echo "mvvm tool has been created please re-open terminal to see effect."
fi


# Create command line tool called mvvm

mvvm() {
    # run script
    bash "${project_path}/main.sh"
}