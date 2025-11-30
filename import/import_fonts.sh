#!/bin/bash

mkdir -p ~/src
cd ~/src
git clone https://github.com/googlefonts/noto-emoji.git
git clone https://github.com/googlefonts/noto-fonts.git

sudo cp noto-emoji/fonts/NotoColorEmoji.ttf /usr/local/lib/mapnik/fonts
sudo cp noto-emoji/fonts/NotoEmoji-Regular.ttf /usr/local/lib/mapnik/fonts
sudo cp noto-fonts/hinted/ttf/NotoSansArabicUI/NotoSansArabicUI-Regular.ttf /usr/local/lib/mapnik/fonts
sudo cp noto-fonts/hinted/ttf/NotoNaskhArabicUI/NotoNaskhArabicUI-Regular.ttf /usr/local/lib/mapnik/fonts
sudo cp noto-fonts/hinted/ttf/NotoSansArabicUI/NotoSansArabicUI-Bold.ttf /usr/local/lib/mapnik/fonts
sudo cp noto-fonts/hinted/ttf/NotoNaskhArabicUI/NotoNaskhArabicUI-Bold.ttf /usr/local/lib/mapnik/fonts
sudo cp noto-fonts/hinted/ttf/NotoSansAdlam/NotoSansAdlam-Regular.ttf /usr/local/lib/mapnik/fonts
sudo cp noto-fonts/hinted/ttf/NotoSansAdlamUnjoined/NotoSansAdlamUnjoined-Regular.ttf /usr/local/lib/mapnik/fonts
sudo cp noto-fonts/hinted/ttf/NotoSansChakma/NotoSansChakma-Regular.ttf /usr/local/lib/mapnik/fonts
sudo cp noto-fonts/hinted/ttf/NotoSansOsage/NotoSansOsage-Regular.ttf /usr/local/lib/mapnik/fonts
sudo cp noto-fonts/hinted/ttf/NotoSansSinhalaUI/NotoSansSinhalaUI-Regular.ttf /usr/local/lib/mapnik/fonts
sudo cp noto-fonts/hinted/ttf/NotoSansArabicUI/NotoSansArabicUI-Regular.ttf /usr/local/lib/mapnik/fonts
sudo cp noto-fonts/hinted/ttf/NotoSansCherokee/NotoSansCherokee-Bold.ttf /usr/local/lib/mapnik/fonts
sudo cp noto-fonts/hinted/ttf/NotoSansSinhalaUI/NotoSansSinhalaUI-Bold.ttf /usr/local/lib/mapnik/fonts
sudo cp noto-fonts/hinted/ttf/NotoSansSymbols/NotoSansSymbols-Bold.ttf /usr/local/lib/mapnik/fonts
sudo cp noto-fonts/hinted/ttf/NotoSansArabicUI/NotoSansArabicUI-Bold.ttf /usr/local/lib/mapnik/fonts
sudo cp noto-fonts/unhinted/ttf/NotoSansSymbols2/NotoSansSymbols2-Regular.ttf /usr/local/lib/mapnik/fonts
sudo cp noto-fonts/hinted/ttf/NotoSansBalinese/NotoSansBalinese-Regular.ttf /usr/local/lib/mapnik/fonts
sudo cp noto-fonts/archive/hinted/NotoSansSyriac/NotoSansSyriac-Regular.ttf /usr/local/lib/mapnik/fonts

mkdir NotoSansSyriacEastern-unhinted
cd NotoSansSyriacEastern-unhinted
wget https://noto-website-2.storage.googleapis.com/pkgs/NotoSansSyriacEastern-unhinted.zip
unzip NotoSansSyriacEastern-unhinted.zip
sudo cp NotoSansSyriacEastern-Regular.ttf /usr/local/lib/mapnik/fonts
cd ..

rm -R ~/src

sudo apt install fontconfig

sudo fc-cache -fv
fc-list
fc-list | grep Emoji

sudo apt-get install -y fonts-dejavu-core