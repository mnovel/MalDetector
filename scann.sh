#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

dir="$1"

patterns=(
    "depo\x73it"
    "jackpot"
    "maxwin"
    "slot"
    "gacor"
    "file_get_contents("
    "webshell"
    "web shell"
    "shell_exec"
    "exec("
    "system("
    "base64"
    "backdoor"
    "phpinfo"
    "php_uname"
    "milw0rm"
    "popen"
    "passthru"
    "phpversion"
    "enctype"
    "lzw_decompress"
    "proc_open"
    "base64_decode"
)

bot_token=""
chat_id=""

send_telegram() {
    local message="$1"
    curl -s -X POST "https://api.telegram.org/bot$bot_token/sendMessage" \
        -d "chat_id=$chat_id" \
        -d "text=$message" > /dev/null 2>&1
}

scanDirRecursive() {
    local dir="$1"
    for file in "$dir"/*; do
        if [[ -d "$file" ]]; then
            scanDirRecursive "$file"
        elif [[ -f "$file" && "$file" == *.php ]]; then
            lower=$(tr '[:upper:]' '[:lower:]' < "$file")
            for pattern in "${patterns[@]}"; do
                if grep -q -a -i -P "$pattern" "$file"; then
                    message="Suspicious file detected: $file => [$pattern]"
                    send_telegram "$message"
                    break
                fi
            done
        fi
    done
}

scanDirRecursive "$dir"
