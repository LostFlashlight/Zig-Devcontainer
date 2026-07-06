#!/bin/bash

#from Dockerfile
ZIG_VERSION=$1
ZLS_VERSION=$2

# seam to be constant
ZIG_PUB_KEY='RWSGOq2NVecA2UPNdBUZykf1CCb147pkmdtYxgb3Ti+JO/wCYvhbAb/U'
ZLS_PUB_KEY='RWR+9B91GBZ0zOjh6Lr17+zKf5BoSuFvrx2xSeDE57uIYvnKBGmMjOex'

# check if we deal with a release version or a dev version because the urls are different
if [[ "${ZIG_VERSION}" = 0.15.* ]] || [[ "${ZIG_VERSION}" = 0.16.* ]]; then
    # stable builds
    ZIG_DL_URL=https://ziglang.org/download/${ZIG_VERSION}/zig-x86_64-linux-${ZIG_VERSION}.tar.xz
else
    # dev builds
    ZIG_DL_URL=https://ziglang.org/builds/zig-x86_64-linux-${ZIG_VERSION}.tar.xz
fi
ZIG_DL_MiSi="${ZIG_DL_URL}.minisig"

ZLS_DL_URL="https://builds.zigtools.org/zls-x86_64-linux-${ZLS_VERSION}.tar.xz"
ZLS_DL_MiSi="${ZLS_DL_URL}.minisig"

# download everything
curl -o zig.tar.xz $ZIG_DL_URL
curl -o zig.tar.xz.minisig $ZIG_DL_MiSi


curl -o zls.tar.xz $ZLS_DL_URL
curl -o zls.tar.xz.minisig $ZLS_DL_MiSi

MINISIGN_ZIG=$(minisign -Vm zig.tar.xz -P $ZIG_PUB_KEY)
MINISIGN_ZLS=$(minisign -Vm zls.tar.xz -P $ZLS_PUB_KEY)

# only install when signed else just dont
if [[ ${MINISIGN_ZIG} = *"Trusted"* ]]; then # dont toutch without looking at if else syntax of bash again because it if f*cking strange
    echo "ZIG signiture confirmed"

    # install zig
    tar xf zig.tar.xz
    cp -r "/zig-x86_64-linux-${ZIG_VERSION}" /opt
    ln -s "/opt/zig-x86_64-linux-${ZIG_VERSION}/zig" /bin/
else
    echo "ZIG signature is wrong "
fi

if [[ ${MINISIGN_ZLS} = *"Trusted"* ]]; then
    echo "ZLS signiture confirmed"

    tar xf zls.tar.xz
    cp /zls "/opt/zig-x86_64-linux-${ZIG_VERSION}/"
    ln -s "/opt/zig-x86_64-linux-${ZIG_VERSION}/zls" /bin/


else
    echo "ZLS signature is wrong "
fi

echo "everything SHOULD BE set up correctly"
