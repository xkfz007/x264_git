#!/bin/bash
add_x(){
    file=$1
    if [ ! -x $file ];then
        chmod u+x $file
    fi
}

CURRENT_DIR=`pwd`
ROOT_DIR=`readlink -f "$CURRENT_DIR/../"`
BUILD_DIR="${CURRENT_DIR}/builds"
if [ ! -e $BUILD_DIR ];then
    mkdir $BUILD_DIR
fi
SOURCE_DIR="${ROOT_DIR}/"

add_x ${SOURCE_DIR}/configure
add_x ${SOURCE_DIR}/version.sh
add_x ${SOURCE_DIR}/config.guess
add_x ${SOURCE_DIR}/config.sub
add_x ${SOURCE_DIR}/tools/cltostr.sh

CMD='${SOURCE_DIR}/configure --prefix="$BUILD_DIR" --disable-cli --enable-static --disable-opencl'
cd $BUILD_DIR
eval $CMD
cd -

config_file="${BUILD_DIR}/config.h"
if [ ! -e $config_file   ];then
    echo "ERROR: ${config_file} does not exist"
    exit
fi

line="#include \"$CURRENT_DIR/defines.h\""
#sed -i '$i'"$line" $config_file
echo $line >>$config_file

x264_config_file="${BUILD_DIR}/x264_config.h"
if [ ! -e $x264_config_file   ];then
    echo "ERROR: ${x264_config_file} does not exist"
    exit
fi

version=`cat ${CURRENT_DIR}/VERSION`
line="X264_VERSION \"$version\""
sed -i 's/X264_VERSION.*/'"$line/" $x264_config_file


