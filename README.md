# Automatic CS 1.6 Server Installation Script

This script automates the installation of a CS 1.6 server. Follow these steps:

**I found that adding `-beta steam_legacy` in steamcmd won't download the legacy gamedll. <br> 
The new gamedll caused amxmodx to not function correctly. <br>
Therefore, I uploaded the legacy gamedll to this repository (the script will automatically download this**

## Windows

1. Put the **install.bat** to a empty folder.
2. Just double click the **install.bat**
3. Follow the instructions in the command prompt.

## Linux

1. **Install SteamCmd**

   First, You have to install SteamCmd, follow [this instruction](https://developer.valvesoftware.com/wiki/SteamCMD) that made by Valve
   
   <br>

2. **Ensure Required Packages**:

   Make sure the `unzip` package is installed. If it's not, run the following command: (Ubuntu)
   ```
   sudo apt install unzip
   ```
   <br>

3. **Set Script Permissions**:

   Make the script executable by running:
   ```
   chmod +x install.sh
   ```
   <br>

- **Customize Installation**:

   By default, the script installs the `steam_legacy` version of **HLDS** with **MetaMod-AM**, and **AMXX 1.10**.

   If you want to install **ReHLDS**, use the `--rehlds` parameter (which also installs **MetaMod-R** instead of **MetaMod-AM**).

   To install with **ReGameDLL**, use the `--regamedll` parameter (which also installs **ReHLDS**, **MetaMod-R** and **ReAPI**).

   <br>

4. **Run the Script**:

   Execute the script to set up your server:
   ```
   ./install.sh
   ```
   <br>

- **Example Command**:

   The following command will install **ReHLDS, ReGameDLL，MetaMod-R, ReAPI, and AMXX 1.10** into the `./csds` directory.
   ```
   ./install.sh --regamedll ./csds
   ```
   <br>

You can customize the download links in the script according to your needs. Enjoy setting up your CS 1.6 server! 😊🎮
