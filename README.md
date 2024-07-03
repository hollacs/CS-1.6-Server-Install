# Automatic CS 1.6 Server Installation Script

This script automates the installation of a CS 1.6 server on Linux (Ubuntu). Follow these steps:

1. **Ensure Required Packages**:
   - First, make sure the `unzip` package is installed. If it's not, run the following command:
     ```
     sudo apt install unzip
     ```

2. **Set Script Permissions**:
   - Make the script executable by running:
     ```
     chmod +x install.sh
     ```

3. **Run the Script**:
   - Execute the script to set up your server:
     ```
     ./install.sh
     ```

4. **Customize Installation**:
   - By default, the script installs the `steam_legacy` version of HLDS, `metamod-am`, and `AMXX 1.10`.
   - If you want to download the latest HLDS version, use the `--latest` parameter.
   - For ReHLDS, use the `--rehlds` parameter (which also installs `metamod-r`).
   - To include ReGameDLL and ReAPI, use the `--regamedll` parameter (which also installs `ReHLDS` and `metamod-r`).

6. **Example Command**:
   - To install `ReHLDS, ReGameDLL, ReAPI, and AMXX 1.10` into the `./csds` directory, run:
     ```
     ./install.sh --regamedll ./csds
     ```

You can customize the download links in the script according to your needs. Enjoy setting up your CS 1.6 server! 😊🎮
