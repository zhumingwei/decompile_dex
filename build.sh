echo "==========cleaning=============="
./clean.sh

# 使用apktool反编译资源文件和Manifest文件
# java -jar apktool_2.4.1.jar d -f Demo.apk -o build/Demo

# 使用dex2jar反编译java源码

cp demo.apk build/old.apk
echo "==========unziping=============="
unzip -o build/old.apk -d build/old
echo "==========dex2jar=============="

dex2jar(){
   eachfile=$1
   out=$(echo $eachfile | cut -d'/' -f 3 | cut -d'.' -f 1)
   outdir="build/jars/${out}_dex2jar.jar"
#    echo ${outdir}
#    echo $1
   dex-tools-2.1-SNAPSHOT/d2j-dex2jar.sh --force  -o $outdir $eachfile
}

dexs=`ls build/old/*.dex | grep 'classes'`
for eachfile in $dexs 
do
    dex2jar $eachfile
done

outdir="$(pwd)/build"
echo "目录：$(pwd)/build/jars"
open "$outdir"
