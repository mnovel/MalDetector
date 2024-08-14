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
    local message=""
    for file in "$dir"/*; do
        if [[ -d "$file" ]]; then
            scanDirRecursive "$file"
        elif [[ -f "$file" ]]; then
            for ext in "${extensions[@]}"; do
                if [[ "$file" == *.$ext ]]; then
                    lower=$(tr '[:upper:]' '[:lower:]' < "$file")
                    for pattern in "${patterns[@]}"; do
                        if echo "$lower" | grep -q -a -E "$pattern"; then
                            message+="$file => [$pattern]\n"
                            break 2  
                        fi
                    done
                fi
            done
        fi
    done
    if [ -n "$message" ]; then
        message="Suspicious file detected:\n\n$message"
        formatted_message=$(printf "%b" "$message")
        send_telegram "$formatted_message"
    fi
}

# Run the scan
scanDirRecursive "$dir"
