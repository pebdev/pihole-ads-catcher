#!/bin/sh

# Check arguments
if [ $# -lt 1 ]; then
  echo "Missing argument"
  echo ""
  echo "Syntax :"
  echo "  ./create-pkg.sh <version> {test_deb}"
  echo ""
  echo "Options :"
  echo "  test_deb    1   to test output deb file"
  exit
fi

# Optional argument
if [ $# -eq 2 ]; then
  TEST_DEB=1
else
  TEST_DEB=0
fi

SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
FILENAME="ads-catcher_$1_all.deb"

# Copy ads-catcher files
echo "- Preparing files..."
F_MD5=$SCRIPT_PATH/debian/DEBIAN/md5sums
P_BIN=$SCRIPT_PATH/debian/usr/bin
#P_ETC=$SCRIPT_PATH/debian/etc
P_DOC=$SCRIPT_PATH/debian/usr/share/doc/ads-catcher
P_MAN=$SCRIPT_PATH/debian/usr/share/man/man1

# Clean previous folder
if [ -d "$SCRIPT_PATH/debian/etc" ]; then
  rm -rf $SCRIPT_PATH/debian/etc
fi

if [ -d "$SCRIPT_PATH/debian/usr" ]; then
  rm -rf $SCRIPT_PATH/debian/usr
fi

rm -f $SCRIPT_PATH/*.deb

# Create needed directory
mkdir -p $P_BIN
#mkdir -p $P_ETC
mkdir -p $P_DOC
mkdir -p $P_MAN

# Copy files
cp $SCRIPT_PATH/../ads-catcher/ads-catcher $P_BIN
#cp $SCRIPT_PATH/../ads-catcher/settings.txt $P_ETC/ads-catcher.cfg
cp $SCRIPT_PATH/copyright $P_DOC
gzip -9nk $SCRIPT_PATH/ads-catcher.1 && mv $SCRIPT_PATH/ads-catcher.1.gz $P_MAN/

# Compute md5
cd $SCRIPT_PATH/debian
md5sum usr/bin/ads-catcher > $F_MD5
#md5sum etc/ads-catcher.cfg >> $F_MD5
md5sum usr/share/doc/ads-catcher/copyright >> $F_MD5
md5sum usr/share/man/man1/ads-catcher.1.gz >> $F_MD5
cd - > /dev/null

# Create package
echo "- Creating deb package..."
cd $SCRIPT_PATH
fakeroot dpkg-deb --build debian $FILENAME


# Test deb package
if [ $TEST_DEB -eq 1 ]; then
  echo "- Test deb package..."
  lintian $FILENAME
fi

cd - > /dev/null

