#!/bin/bash


ZIG_VERSION=$1
ZLS_VERSION=$2

ZIG_PUB_KEY='RWSGOq2NVecA2UPNdBUZykf1CCb147pkmdtYxgb3Ti+JO/wCYvhbAb/U'
ZLS_PUB_KEY='RWR+9B91GBZ0zOjh6Lr17+zKf5BoSuFvrx2xSeDE57uIYvnKBGmMjOex'

if [[ "${ZIG_VERSION}" = 0.15.* ]]; then
    # stable builds
    ZIG_DL_URL=https://ziglang.org/download/${ZIG_VERSION}/zig-x86_64-linux-${ZIG_VERSION}.tar.xz
else
    # dev builds
    ZIG_DL_URL=https://ziglang.org/builds/zig-x86_64-linux-${ZIG_VERSION}.tar.xz
fi
ZIG_DL_MiSi="${ZIG_DL_URL}.minisig"

ZLS_DL_URL="https://builds.zigtools.org/zls-x86_64-linux-${ZLS_VERSION}.tar.xz"
ZLS_DL_MiSi="${ZLS_DL_URL}.minisig"

curl -o zig.tar.xz $ZIG_DL_URL
curl -o zig.tar.xz.minisig $ZIG_DL_MiSi


curl -o zls.tar.xz $ZLS_DL_URL
curl -o zls.tar.xz.minisig $ZLS_DL_MiSi

MINISIGN_ZIG=$(minisign -Vm zig.tar.xz -P $ZIG_PUB_KEY)
MINISIGN_ZLS=$(minisign -Vm zls.tar.xz -P $ZLS_PUB_KEY)

if [[ ${MINISIGN_ZIG} = *"Trusted"* ]]; then
    echo "ZIG signiture confirmed"

    # install zig
    tar xf zig.tar.xz
    cp -r "/zig-x86_64-linux-${ZIG_VERSION}" /opt
    ln -s "/opt/zig-x86_64-linux-${ZIG_VERSION}/zig" /bin/
else
    echo "ZLS signature is wrong "
fi

if [[ ${MINISIGN_ZLS} = *"Trusted"* ]]; then
    echo "ZIG signiture confirmed"

    tar xf zls.tar.xz
    cp /zls "/opt/zig-x86_64-linux-${ZIG_VERSION}"
    ln -s /opt/zig-x86_64-linux-${ZIG_VERSION}/zls /bin


else
    echo "ZLS signature is wrong "
fi
