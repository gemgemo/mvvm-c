#!/bin/bash

# Colors

color_off='\033[0m'
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
cyan='\033[0;36m'
purple='\033[0;35m'

create_file_header() {
    file_name=${1##*/}
    [ -f $1 ] && echo -e "//\n// $file_name\n// Created by $(whoami) on $(date +"%d/%m/%Y"). \n//\n// Copyright © $(date +"%Y") $(whoami). All rights reserved.\n//\n\n\nimport Foundation \nimport UIKit" >> $1 || echo -e $yellow "$file_name file not found."     
    echo -e $color_off
}

# Validation
# Check if project is xcode project.

echo -e $purple "Are you sure this path '$(pwd)' is xcode project? enter y to complete or n to cancel."
echo -e $color_off
read isXcodeProject

# Some Constants
current_path=$(pwd)
project_dir_name=${current_path##*/}
xcodeproj="${current_path}/*.xcodeproj"
project_main_dir_path="${current_path}/${project_dir_name}"
swift_ex=".swift"

if [ $isXcodeProject == "y" ]
then
    if [ -d $xcodeproj ]
    then
        # Remove Generic View Controller File. 
        view_controller_path="${project_main_dir_path}/ViewController${swift_ex}"
        if test -f $view_controller_path 
        then
            rm -f $view_controller_path
            echo -e $green "${view_controller_path##*/} removed."
            echo -e $color_off
        else 
            echo -e $yellow "${view_controller_path##*/} file removed in advance."
            echo -e $color_off
        fi 

        # Create Main Directories 
        if test -d $project_main_dir_path
        then
            main_dirs=("Controllers" "Common" "Extensions" "UIControls" "ViewModels" "Models" "Coordinators")
            for dir in "${main_dirs[@]}" 
            do 
                dir_path="${project_main_dir_path}/${dir}"
                if [ ! -d $dir_path ]
                then 
                    mkdir -p $dir_path
                    echo -e $green "${dir_path##*/} Directory created."
                    echo -e $color_off 
                else    
                    echo -e $yellow "${dir_path##*/} Directory created in advance."
                    echo -e $color_off 
                fi
            done
        else 
            echo -e $red "Project main directory is invalid."
            echo -e $color_off
        fi

        # Create Files
        # Protocol File 
        common_dir_path="${project_main_dir_path}/Common"
        if [ -d $common_dir_path ]
        then 
            protocols_file_path="${common_dir_path}/Protocols${swift_ex}"
            if [ ! -f $protocols_file_path ] 
            then 
                touch $protocols_file_path
                create_file_header $protocols_file_path
                echo -e $green "${protocols_file_path##*/} file created."
                sleep 1
                # Implement protocols file here.
                # Set Naming protocol
                if test -f $protocols_file_path 
                then                     
                    echo -e "\n\n// MARK: - Naming
protocol Naming { }
extension Naming {
    func name(of className: AnyClass) -> String {
         return String.init(describing: className)
    }
}\n\n\n\n\n"        >> $protocols_file_path
                    # Set MVVM blueprint 
                    echo -e "//#: MVVM-C Design pattern blueprint \n\nprotocol Controller where Self: UIViewController { } \nprotocol Model { } \nprotocol ViewModel: class { } \nprotocol Coordinator: class { }" >> "${protocols_file_path}"
                fi 
            else 
                echo -e $yellow "${protocols_file_path##*/} file created in advance."
            fi 
            echo -e $color_off
        else
            echo -e $red "${common_dir_path##*/} not found."
            echo -e $color_off 
        fi

        # Create .gitignore file 
        git_path="${current_path}/.git"
        gitignore_path="${current_path}/.gitignore"
        if test -d $git_path && test ! -f $gitignore_path
        then             
            touch $gitignore_path
            echo -e "\n.DS_Store\n*.lock\nPods/\nfastlane/\n" >> $gitignore_path 
            echo -e $green "git ignore file created."
            echo -e $color_off 
        fi 

    else
        echo -e $red "Invalid Xcode Project."
    fi
fi
