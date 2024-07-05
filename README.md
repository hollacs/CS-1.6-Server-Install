# Automatic CS 1.6 Server Installation Script

This script automates the installation of a CS 1.6 server. Follow these steps:

## Windows

1. Put the **install.bat** to a empty folder.
2. Just double click the **install.bat**
3. Follow the instructions in the command prompt.

## Linux

1. **Ensure Required Packages**:

   First, make sure the `unzip` package is installed. If it's not, run the following command:
   ```
   sudo apt install unzip
   ```
   <br>

2. **Set Script Permissions**:

   Make the script executable by running:
   ```
   chmod +x install.sh
   ```
   <br>

3. **Run the Script**:

   Execute the script to set up your server:
   ```
   ./install.sh
   ```
   <br>

4. **Customize Installation**:

   By default, the script installs the `steam_legacy` version of **HLDS**, **MetaMod-AM**, and **AMXX 1.10**.

   If you want to download the latest HLDS version, use the `--latest` parameter.

   For **ReHLDS**, use the `--rehlds` parameter (which also installs **MetaMod-R**).

   To include **ReGameDLL** and **ReAPI**, use the `--regamedll` parameter (which also installs **ReHLDS** and **MetaMod-R**).

   <br>

6. **Example Command**:

   The following command will install **ReHLDS, ReGameDLL，MetaMod-R, ReAPI, and AMXX 1.10** into the `./csds` directory.
   ```
   ./install.sh --regamedll ./csds
   ```
   <br>

You can customize the download links in the script according to your needs. Enjoy setting up your CS 1.6 server! 😊🎮
