##!/bin/bash

date=`date +%y%m%e`
srcdir=./DCIM/100DSCIM/

destdir=$OneDrive/FpvMaterials/$date/
mkdir -p $destdir

backupdir=$OneDrive/FpvMaterialsRaw/$date/
mkdir -p $backupdir

logdir=./log/
mkdir -p $logdir

echo "Backing up raw files"
cp --backup=numbered $srcdir/* $backupdir
if [ $? -ne 0 ]; then
    echo "Error backing up into $backupdir"
    exit -1
fi

for i in $srcdir/*.JPG
do
    fname=`basename $i | tr '[:upper:]' '[:lower:]'`
    echo "Copying $fname"
    cp --backup=none $i $destdir/$fname
    if [ $? -ne 0 ]; then
        echo "Error copying into $destdir"
        exit -1
    fi
done

for i in $srcdir/*.AVI
do
    fname=`basename $i | tr '[:upper:]' '[:lower:]'`
    echo "Converting $fname"
    ./HandBrakeCLI --preset-import-file HandBrakePreset.json -Z fpv1 -i $i -o $destdir/$fname &>log/$fname.log
    if [ $? -ne 0 ]; then
        echo "Error converting into $destdir"
        exit -1
    fi
done

echo "Clearing logs"
rm -rf $logdir

echo "Clearning source dir"
rm $srcdir/*

echo "Finished"