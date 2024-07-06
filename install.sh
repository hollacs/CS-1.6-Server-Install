#!/bin/bash

# ReHLDS URL
rehlds_url="https://github.com/dreamstalker/rehlds/releases/download/3.13.0.788/rehlds-bin-3.13.0.788.zip"

# ReGameDLL URL
regamedll_url="https://github.com/s1lentq/ReGameDLL_CS/releases/download/5.26.0.668/regamedll-bin-5.26.0.668.zip"

# ReAPI URL
reapi_url="https://github.com/s1lentq/reapi/releases/download/5.24.0.300/reapi-bin-5.24.0.300.zip"

# Metamod URL
metamod_url="https://www.amxmodx.org/release/metamod-1.21.1-am.zip"

# Metamod-R URL
metamodr_url="https://github.com/theAsmodai/metamod-r/releases/download/1.3.0.149/metamod-bin-1.3.0.149.zip"

# AMXModX Base URL
amxmodx_base_url="https://www.amxmodx.org/amxxdrop/1.10/amxmodx-1.10.0-git5467-base-linux.tar.gz"

# AMXModX CStrike URL
amxmodx_cstrike_url="https://www.amxmodx.org/amxxdrop/1.10/amxmodx-1.10.0-git5467-cstrike-linux.tar.gz"

# Download folder name
downloaded_dir=".downloaded_files"

# Max steamcmd download retries
max_retries=3

dest=${PWD}
rehlds=false
regamedll=false
beta=" -beta steam_legacy"

for i in "$@"; do
    case $i in
        --latest)
            beta=" "
            shift
        ;;
        --rehlds)
            rehlds=true
            shift
        ;;
        --regamedll)
            rehlds=true
            regamedll=true
            shift
        ;;
        -*|--*)
            echo "Unknown option $i"
            exit 1
        ;;
        *)
        ;;
    esac
done

if [ -n $1 ]; then
    dest=$1
    if [ "${dest%"${dest#?}"}" = "." ]; then
        dest="${PWD}${dest#?}"
    fi
fi

if [ -z $dest ]; then
    dest="${PWD}${dest#?}"
fi

if ! lsb_release -a | grep -q 'Ubuntu'; then
    echo "The script only supports Ubuntu."
    exit 1
fi

if ! dpkg -l | grep steamcmd; then
    echo "Installing steamcmd..."
    sudo add-apt-repository -y multiverse; sudo dpkg --add-architecture i386; sudo apt update -y
    sudo apt install -y steamcmd
fi

# download HLDS from steamcmd
echo "Downloading HLDS..."
retry=0
while [ $retry -lt $max_retries ]; do
    if steamcmd +login anonymous +force_install_dir $dest +app_update 90$beta validate +quit | grep -q 'Success'; then
        echo "Success!";
        break;
    fi

    echo "Failed, Retrying...($retry/$max_retries)";
    retry=$((retry + 1))
done

if [ $retry -ge $max_retries ]; then
    echo "Download HLDS failed."
    exit 1
fi

cd $dest

mkdir $downloaded_dir
cd $downloaded_dir

# ReHLDS
if $rehlds; then
    echo "Downloading ReHLDS..."
    wget $rehlds_url
    echo "Extracting ReHLDS..."
    unzip rehlds-bin-*.zip 'bin/linux32/*' -d rehlds
    cp -rf ./rehlds/bin/linux32/* ../
    chmod +x ../hlds_linux

    # Metamod-R
    echo "Downloading Metamod-R..."
    wget $metamodr_url
    echo "Extracting Metamod-R..."
    unzip metamod-bin-*.zip 'addons/*' -d metamod
    mkdir -p ../cstrike/addons/metamod/dlls
    cp -f ./metamod/addons/metamod/*.ini ../cstrike/addons/metamod
    cp -f ./metamod/addons/metamod/*.so ../cstrike/addons/metamod/dlls
    echo "Editing liblist.gam"
    sed -i 's/gamedll_linux.*/gamedll_linux "addons\/metamod\/dlls\/metamod_i386.so"/' ../cstrike/liblist.gam
else
    # Metamod
    echo "Downloading Metamod..."
    wget $metamod_url
    echo "Extracting Metamod..."
    unzip metamod-*-am.zip -d metamod
    cp -rf ./metamod/addons ../cstrike
    echo "Editing liblist.gam"
    sed -i 's/gamedll_linux.*/gamedll_linux "addons\/metamod\/dlls\/metamod.so"/' ../cstrike/liblist.gam
fi

# ReGameDLL
if $regamedll; then
    echo "Downloading ReGameDLL and ReAPI..."
    wget $regamedll_url
    wget $reapi_url
    unzip regamedll-bin-*.zip 'bin/linux32/*' -d regamedll
    unzip reapi-bin-*.zip -d ./regamedll/bin/linux32/cstrike
    cp -rf ./regamedll/bin/linux32/cstrike ../
fi

# AMXModX
echo "Downloading AMXModX..."
wget $amxmodx_base_url
wget $amxmodx_cstrike_url
echo "Extracting AMXModX..."
mkdir amxx
tar -zxf amxmodx-*-base-linux.tar.gz -C amxx
tar --overwrite -zxf amxmodx-*-cstrike-linux.tar.gz -C amxx
cp -rf ./amxx/addons ../cstrike
echo "Creating metamod/plugins.ini"
echo "linux addons/amxmodx/dlls/amxmodx_mm_i386.so" >> ../cstrike/addons/metamod/plugins.ini

# Clean up downloaded files
echo "Cleaning up..."
cd ..
rm -rf $downloaded_dir

echo "Done!"