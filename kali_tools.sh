#!/bin/bash

# Install apt https
sudo apt update
sudo apt install apt-transport-https

# Add Brave Browser Sources
echo "Setting up Brave sources"
curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

# Add Sublime Sources
echo "Setting up Sublime sources"
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

# Install Google Chrome
echo "Install Google Chrome"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb

# Remove Java 18
sudo apt purge -y openjdk-18-jre:amd64 openjdk-18-jre-headless:amd64

# Update and add necessary packages
echo "Installing Packages and Tools"
sudo apt update
sudo apt install -y python3-pip default-jdk brave-browser feroxbuster golang sublime-text neo4j bloodhound tor zaproxy

#Fix Go PATH
echo -e "export PATH=\$PATH:\$HOME/go/bin" >> $HOME/.zshrc

# Install go-tools for recon and vuln scan
sudo rm /usr/bin/httpx
echo "Installing go-tools"
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/sensepost/gowitness@latest
go install github.com/jaeles-project/gospider@latest

# Install VSCode
echo "Installing VSCode"
curl -L "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -o code.deb
sudo dpkg -i code.deb
rm code.deb

# Install BurpPro
echo "Installing BurpPro"
curl -L "https://portswigger-cdn.net/burp/releases/download?product=pro&version=2022.9.5&type=Linux" -o burp_pro.sh
bash burp_pro.sh
rm burp_pro.sh

# Remove BurpCommunity
sudo apt -y remove burpsuite

# Install Nessus
echo "Installing Nessus"
curl --request GET \
  --url 'https://www.tenable.com/downloads/api/v2/pages/nessus/files/Nessus-10.4.1-ubuntu1404_amd64.deb' \
  --output 'Nessus-10.4.1-ubuntu1404_amd64.deb'
sudo dpkg -i Nessus-10.4.1-ubuntu1404_amd64.deb
rm Nessus-10.4.1-ubuntu1404_amd64.deb

#Create Tools directory
mkdir $HOME/Tools
cd $HOME/Tools

#Clone multiple tools
wget https://raw.githubusercontent.com/wowter-code/Recon/main/autorecon-ng.sh

git clone https://github.com/m8sec/CrossLinked.git
pip3 install -r CrossLinked/requirements.txt

git clone https://github.com/dievus/Oh365UserFinder.git
pip3 install -r Oh365UserFinder/requirements.txt

git clone https://github.com/arthepsy/ssh-audit.git

git clone https://github.com/dievus/geeMailUserFinder.git
pip3 install -r geeMailUserFinder/requirements.txt

git clone --depth 1 https://github.com/drwetter/testssl.sh.git

git clone https://github.com/blacklanternsecurity/TREVORspray.git
pip3 install -r TREVORspray/requirements.txt
pip3 install trevorproxy

git clone https://github.com/rbsec/dnscan.git
pip3 install -r dnscan/requirements.txt

git clone https://github.com/MattKeeley/Spoofy.git
pip3 install -r Spoofy/requirements.txt

# Install SCNR WEB scanner
# Disable SCNR installer since there are some issues with this tool. Find more into SCNR repository!
#bash -c "$(curl -sSL https://raw.githubusercontent.com/scnr/installer/main/install.sh)"

cd $HOME

# Install needed Extensions for Brave Browser
install_brave_extension () {
  preferences_dir_path="/opt/brave.com/brave/extensions"
  pref_file_path="$preferences_dir_path/$1.json"
  upd_url="https://clients2.google.com/service/update2/crx"
  sudo mkdir -p "$preferences_dir_path"
  sudo chown kali:kali -R /opt/brave.com/brave/extensions
  sudo echo "{" > "$pref_file_path"
  sudo echo "  \"external_update_url\": \"$upd_url\"" >> "$pref_file_path"
  sudo echo "}" >> "$pref_file_path"
  sudo echo Added \""$pref_file_path"\" ["$2"]
}

install_brave_extension "cmbndhnoonmghfofefkcccljbkdpamhi" "Hack-Tools"
install_brave_extension "hlkenndednhfkekhgcdicdfddnkalmdm" "Cookie-Editor"
install_brave_extension "gppongmhjkpfnbhagpmjfkannfbllamg" "Wappalyzer"
install_brave_extension "moibopkbhjceeedibkbkbchbjnkadmom" "retire.js"
install_brave_extension "gcknhkkoolaabfmlnjonogaaifnjlfnp" "FoxyProxy"

# Add additional user
sudo useradd -m aws
sudo usermod -a -G sudo -s /bin/zsh aws
sudo cp /home/kali/.zshrc /home/aws
sudo chown aws:aws /home/aws/.zshrc
