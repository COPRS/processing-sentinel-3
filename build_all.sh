#!/bin/sh

if [[ "$#" -ne 2 ]]
then
  echo "Usage: $0 <target_dir> <version>"
  echo "<target dir> Specifies the directory where the builded RS add-ons shall be placed"
  exit 1
fi

TARGET=$(readlink -f $1)
VERSION=$2

mkdir -p $TARGET

DATE=$(date '+%Y-%m-%d')

for dir in $(find . -type d -iname 's1*')
do
  echo "Building RS Add-on... $dir"
  
  CWD=$(pwd)
  # Create temp directory 
  TMP_DIR=$(mktemp -d)

  NAME="RS_ADDON_$(basename ${dir} | tr 'a-z' 'A-Z')_${VERSION}"

  cp -r $dir/Manifest.json $TMP_DIR
  mkdir -p $TMP_DIR/${NAME}_Executables
  cp -r $dir/content/* ${TMP_DIR}/${NAME}_Executables
  cp -r $dir/additional_resources ${TMP_DIR}/

  cd $TMP_DIR
  ITEMS=""
  for f in $(find *Executables* -type f | sort)
  do
    ITEMS="$ITEMS $f,"
  done
  ITEMS="$ITEMS Manifest.json"
  
  sed -i "s/<RELEASE_DATE>/${DATE}/g" Manifest.json
  sed -i "s/<VERSION>/${VERSION}/g" ${NAME}_Executables/stream-application-list.properties
  sed -i "s/<VERSION>/${VERSION}/g" ${NAME}_Executables/stream-parameters.properties
  sed -i "s/<VERSION>/${VERSION}/g" Manifest.json
  sed -i "s#<RELEASE_ITEMS>#${ITEMS}#g" Manifest.json
  sed -i "s/<NAME>/${NAME}/g" Manifest.json

  CMD="zip -qq -r "$TARGET/$NAME.zip" ./*"
  eval $CMD
  rm -fr $TMP_DIR
  echo "You can find the generated rs add-ons in $TARGET/$NAME.zip"
  cd ${CWD}
done


echo "done."
