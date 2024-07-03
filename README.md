# Automatic CS 1.6 Server Installation Script

This script automates the installation of a CS 1.6 server on Linux (Ubuntu). Follow these steps:

1. **Ensure required packages are installed**: Make sure the `unzip` package is installed. If not, run: `apt install unzip`.
2. **Set script permissions**: Make the script executable with: `chmod +x install.sh`.
3. **Run the script**: Execute the script: `./install.sh`. It will handle the entire setup process.

### Parameters:

By default, the scirpt will install the steam_legacy version of `HLDS`, `metamod-am` and `AMXX 1.10`
If you want to download the latest version of HLDS, add the following parameter:
```
--latest
```


To install with `ReHLDS`, add parameter: (it will also install the `metamod-r` instead of `metamod-am`)
```
--rehlds
```


To install with `ReGameDLL` and `ReAPI`, add parameter: (it will also install the `ReHLDS` and `metamod-r`)
```
--regamedll
```


Example command: (Install `ReHLDS + ReGameDLL + ReAPI + AMXX 1.10` to the `./csds` directory)
```console
./install.sh --regamedll ./csds
```


**Customize the download links**: Modify the download links at the beginning of the script to your own links..

Enjoy setting up your server!
