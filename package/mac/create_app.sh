#!/bin/bash

cd ../../
mkdir -p gui/deploy

set -e

version="0.5.0.0"

mvn clean package verify -DskipTests -Dmaven.javadoc.skip=true

# At windows we don't add the version nr as it would keep multiple versions of jar files in app dir
cp gui/target/shaded.jar "gui/deploy/Bitsquare-$version.jar"
cp gui/target/shaded.jar "/Users/dev/vm_shared_ubuntu/Bitsquare-$version.jar"
cp gui/target/shaded.jar "/Users/dev/vm_shared_windows/Bitsquare.jar"
cp gui/target/shaded.jar "/Users/dev/vm_shared_ubuntu14_32bit/Bitsquare-$version.jar"
cp gui/target/shaded.jar "/Users/dev/vm_shared_windows_32bit/Bitsquare.jar"

echo "Using JAVA_HOME: $JAVA_HOME"
$JAVA_HOME/bin/javapackager \
    -deploy \
    -BappVersion=$version \
    -Bmac.CFBundleIdentifier=io.bitsquare \
    -Bmac.CFBundleName=Bitsquare \
    -Bicon=package/mac/Bitsquare.icns \
    -Bruntime="$JAVA_HOME/jre" \
    -native dmg \
    -name Bitsquare \
    -title Bitsquare \
    -vendor Bitsquare \
    -outdir gui/deploy \
    -srcfiles "gui/deploy/Bitsquare-$version.jar" \
    -srcfiles "core/src/main/resources/bitsquare.policy" \
    -appclass io.bitsquare.app.BitsquareAppMain \
    -outfile Bitsquare \
    -BjvmOptions=-Djava.security.manager \
    -BjvmOptions=-Djava.security.debug=failure \
    -BjvmOptions=-Djava.security.policy=file:bitsquare.policy

rm "gui/deploy/Bitsquare.html"
rm "gui/deploy/Bitsquare.jnlp"

mv "gui/deploy/bundles/Bitsquare-$version.dmg" "gui/deploy/Bitsquare-$version.dmg"
rm -r "gui/deploy/bundles"

cd package/mac