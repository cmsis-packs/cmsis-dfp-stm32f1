#!/bin/bash

name=cmsis-dfp-stm32f1
vendor=Atmel
version=4.3.1
source_url=https://github.com/STMicroelectronics/cmsis_device_f1
commit=2948138428461c0621fd53b269862c6e6bb043ce

build_dir='cmsis_build'
deploy_dir='cmsis_deploy'

prepare() {
    echo "preparing..." 
    
    if [ -z "$build_dir" ]
    then
        echo " var\$build_dir is empty"
        exit
    fi

    if [ -z "$deploy_dir" ]
    then
        echo "var \$deploy_dir is empty"
        exit
    fi
    
    mkdir -p $build_dir
    mkdir -p $deploy_dir

    if [ "$(ls -A $build_dir)" ]; then
        echo "Directory $build_dir is not Empty"
        echo "Running \"rm -rf $build_dir/*\""
        rm -rf $build_dir/*
    fi

    if [ "$(ls -A $deploy_dir)" ]; then
        echo "Directory $deploy_dir is not Empty"
        echo "Running \"rm -rf $deploy_dir/*\""
        rm -rf $deploy_dir/*
    fi

    touch $build_dir/version

    echo $version >> $build_dir/version
}

download() {
    echo "downloading..."
    git clone $source_url $build_dir/temp
    cd $build_dir/temp
    git checkout $commit
    cd ../..
}

extract() {
    echo "extracting..."
    mv $build_dir/temp/* $build_dir/
    rm -rf $build_dir/temp/
}

deploy() {
    echo "deploying..."
    cp -r $build_dir/Include $deploy_dir
    cp -r $build_dir/Source $deploy_dir
    cp -r $build_dir/License.md $deploy_dir
}

prepare
download
extract
deploy
