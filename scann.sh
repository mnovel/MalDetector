#!/bin/bash

# Check if directory argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

dir="$1"

# Array of patterns to search for
patterns=(
    "deposits"
    "jackpot"
    "maxwin"
    "slot"
    "gacor"
    "file_get_contents\("
    "webshell"
    "web shell"
    "shell_exec\("
    "exec\("
    "system\("
    "base64"
    "backdoor"
    "phpinfo"
    "php_uname"
    "milw0rm"
    "popen\("
    "passthru\("
    "phpversion"
    "enctype"
    "lzw_decompress"
    "proc_open\("
    "base64_decode\("
    "system"
    "eval"
)

# Array of file extensions commonly used by shell backdoors
extensions=(
    # PHP extensions
    "php"
    "php2"
    "php3"
    "php4"
    "php5"
    "php6"
    "php7"
    "phps"
    "pht"
    "phtm"
    "phtml"
    "pgif"
    "shtml"
    "htaccess"
    "phar"
    "inc"
    "hphp"
    "ctp"
    "module"
    # PHPv8 extensions
    "php"
    "php4"
    "php5"
    "phtml"
    "module"
    "inc"
    "hphp"
    "ctp"
    # ASP extensions
    "asp"
    "aspx"
    "config"
    "ashx"
    "asmx"
    "aspq"
    "axd"
    "cshtm"
    "cshtml"
    "rem"
    "soap"
    "vbhtm"
    "vbhtml"
    "asa"
    "cer"
    "shtml"
    "xml"
)

# Array of default web server users
default_users=(
    "www-data"
    "nginx"
    "apache"
    "httpd"
)

bot_token="6909462496:AAEHtzehlol77XZ2WSgI4KqZIbLuSYBKRqQ"
chat_id="-1002243297308"

# Get server name and IP
server_name=$(hostname)
server_ip=$(hostname -I | awk '{print $1}')

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
        elif [[ -f "$file" ]]; then
            for ext in "${extensions[@]}"; do
                if [[ "$file" == *.$ext ]]; then
                    lower=$(tr '[:upper:]' '[:lower:]' < "$file")
                    for pattern in "${patterns[@]}"; do
                        if echo "$lower" | grep -q -a -E "$pattern"; then
                            list_file+="$file => [$pattern]\n"
                            break 2
                        fi
                    done
                    local owner=$(stat -c "%U" "$file")
                    for user in "${default_users[@]}"; do
                        if [ "$owner" == "$user" ]; then
                            list_owner+="$file => [$owner]\n"
                            break 2
                        fi
                    done
                fi
            done
        fi
    done
}

# Initialize variables to collect results
list_file=""
list_owner=""

# Run the scan
scanDirRecursive "$dir"

# Send all results in one message
if [ -n "$list_file" ] || [ -n "$list_owner" ]; then
    formatted_message="------------------------------------------------------\nHost: $server_name\nIP: $server_ip\n------------------------------------------------------\n\nSuspicious file detected:\n\n$list_file\n\nDefault owner:\n\n$list_owner"
    formatted_message=$(printf "%b" "$formatted_message")
    send_telegram "$formatted_message"
fi
