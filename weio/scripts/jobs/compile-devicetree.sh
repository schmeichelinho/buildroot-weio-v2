
#!/bin/bash

FILENAME="$1/../../weio/devicetree/weio-at91-sama5d3_xplained.dts"
OUTPATH=$(readlink -f $1/../../weio/devicetree)
KERNEL_VERSION=$(cat $1/../../.config | grep 'BR2_LINUX_KERNEL_VERSION' | cut -d '=' -f2 | sed 's/\"//g')
KERNEL_PATH=$(readlink -f $1/../build/linux-$KERNEL_VERSION)
INCLUDE_H=$(readlink -f $KERNEL_PATH/arch/arm/boot/dts/include)
INCLUDE_DTSI=$(readlink -f $KERNEL_PATH/arch/arm/boot/dts)
DTC="$1/../../output/host/usr/bin/dtc"
CPP="$1/../../output/host/usr/bin/arm-linux-cpp"

[ -f $DTC ] && echo "Found dtc..." || (echo "Error: DT Compiler not Installed!" && exit -1)

cat $FILENAME | eval $CPP -P -x assembler-with-cpp -undef -D__DTS__ -nostdinc -I $INCLUDE_H -I $INCLUDE_DTSI - >tmp.dtc
eval $DTC -i $INCLUDE_DTSI -I dts -b 0 -O dtb -o $OUTPATH/at91-sama5d3_xplained.dtb tmp.dtc && rm tmp.dtc

echo "WeIO v2 device tree can be found at $OUTPATH"

exit 0

