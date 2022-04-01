#! /usr/bin/env bash
echo "==========cleaning=============="
./clean.sh

# 使用apktool反编译资源文件和Manifest文件
# java -jar apktool_2.4.1.jar d -f Demo.apk -o build/Demo

# 使用dex2jar反编译java源码

cp demo.apk build/old.apk
echo "==========unziping=============="
unzip -q -o build/old.apk -d build/old
echo "==========dex2jar=============="

dex2jar(){
   eachfile=$1
   out=$(echo $eachfile | cut -d'/' -f 3 | cut -d'.' -f 1)
   outdir="build/jars/${out}_dex2jar.jar"
#    echo ${outdir}
#    echo $1
   # 2.1版本
   # dex-tools-2.1-SNAPSHOT/d2j-dex2jar.sh --force  -o $outdir $eachfile
   # 2.2版本
   dex-tools-2.2-SNAPSHOT/d2j-dex2jar.sh --force  -o $outdir $eachfile
}

dexs=`ls build/old/*.dex | grep 'classes'`
for eachfile in $dexs 
do
    dex2jar $eachfile
done

echo "==========merge=============="

tempfile="build/jars/tmp"
mkdir $tempfile
jars=`ls build/jars/*.jar`

unzip_file(){
   jarfile=$1
   tempDir=$2
   echo "unzip ${jarfile} to ${tempDir}"
   unzip -q -uo $jarfile -d $tempDir
}


for eachfile in $jars
do
   unzip_file $eachfile $tempfile
done
jar -cvf allinone.jar -C $tempfile .
mv allinone.jar build/jars/allinone.jar
rm -r $tempfile

# just open
outdir="$(pwd)/build"
echo "目录：$(pwd)/build/jars"
# open "$outdir"

# open by jd-jui
java -jar ./source/jd-gui-1.4.0.jar ./build/jars/allinone.jar