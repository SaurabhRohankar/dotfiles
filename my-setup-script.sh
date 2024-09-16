#!/bin/bash

sudo dnf group install "Development Tools" -y
sudo dnf install zoxide fzf rofi feh brightnessctl flameshot install git libX11-devel libxcb-devel libXinerama-devel libXft-devel imlib2-devel -y

mkdir -p ~/Pictures/Screenshots
mkdir -p ~/Pictures/backgrounds

wget -P ~/Downloads/ https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
unzip ~/Downloads/JetBrainsMono.zip -d ~/Downloads/JetBrainsMono
sudo mkdir -p /usr/share/fonts/nerd-fonts
sudo cp ~/Downloads/JetBrainsMono/* /usr/share/fonts/nerd-fonts/
rm -rf Downloads/JetBrainsMono*

 # Set up XDG directories
xdg_config_home=${XDG_CONFIG_HOME:-$HOME/.config}
xdg_data_home=${XDG_DATA_HOME:-$HOME/.local/share}

mkdir -p "$xdg_data_home/suckless"
cd "$xdg_data_home/suckless"

# Clone and install dwm, st, and dmenu
for app in dwm st dwmblocks; do
    git clone "https://github.com/SaurabhRohankar/$app"
    cd "$app"
    sudo make clean install
    cd ..
done

# Create DWM session file in XDG directory
echo "Creating DWM session"
echo "[Desktop Entry]
Encoding=UTF-8
Name=DWM
Exec=dwm-setup
Icon=dwm
Type=XSession" | sudo tee "/usr/share/xsessions/dwm.desktop"

# Create dwm-setup config file in /usr/local/bin
#echo "exec dwm" | sudo tee /usr/local/bin/dwm-setup
sudo tee /usr/local/bin/dwm-setup > /dev/null << 'EOF'
#!/bin/bash
feh --randomize --bg-fill ~/Pictures/backgrounds/*
exec dwm
EOF
sudo chmod +x /usr/local/bin/dwm-setup

cd
mkdir -p ~/.local/bin/statusbar
cp ~/dotfiles/statusbar/* ~/.local/bin/statusbar/
cp -r ~/dotfiles/rofi/ ~/.config/
cp ~/dotfiles/starship.toml ~/.config/

echo 'export PATH="$HOME/.local/bin/statusbar:$PATH"' >> ~/.bashrc

#install starship
curl -sS https://starship.rs/install.sh | sh
echo 'eval "$(starship init bash)"' >> ~/.bashrc
echo 'eval "$(zoxide init bash)"' >> ~/.bashrc
source ~/.bashrc

echo "Install now complete. You can now logout and change your DE/WM."
