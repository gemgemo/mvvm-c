#!/bin/bash

# Colors

color_off='\033[0m'
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
cyan='\033[0;36m'
purple='\033[0;35m'


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
    else
        echo -e $red "Invalid Xcode Project."
    fi
fi
