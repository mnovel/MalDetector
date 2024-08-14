# Suspicious File Scanner

This script recursively scans a specified directory for potentially malicious files based on a set of predefined patterns. It checks for files with various extensions, including PHP, ASP, and others commonly associated with web shells and backdoors. If a suspicious file is detected, a notification is sent to a specified Telegram bot.

## Prerequisites

- A Linux-based system (e.g., Ubuntu)
- Bash shell
- `curl` installed (used to send notifications to Telegram)
- A Telegram bot token and chat ID (group or channel) for receiving alerts

## Getting Started

### 1. Clone or Download the Script

You can clone this repository or download the script directly.

```bash
git clone https://github.com/mnovel/MalDetector
cd MalDetector
```

Or download the script:

```bash
wget https://raw.githubusercontent.com/mnovel/MalDetector/main/scann.sh
```

### 2. Make the Script Executable

Ensure the script has executable permissions.

```bash
chmod +x scann.sh
```

### 3. Usage

Run the script with the directory you want to scan as an argument. For example:

```bash
./scann.sh /var/www/html
```

This will scan the `/var/www/html` directory and subdirectories for suspicious PHP files.

### 4. Running as a Cron Job

To automate the scanning process, you can schedule this script to run periodically using `cron`.

#### Example Cron Job

To run the script every day at 3:00 AM:

```bash
0 3 * * * /path/to/scann.sh /var/www/html
```

#### Adding to Crontab

Open the crontab editor:

```bash
crontab -e
```

Add the cron job at the end of the file:

```bash
0 3 * * * /path/to/scann.sh /var/www/html
```

### 5. Telegram Notification

When the script detects a suspicious file, it sends a notification to the specified Telegram chat.

#### Setting Up Telegram

1. **Create a Telegram Bot**:
   - Talk to [BotFather](https://t.me/BotFather) to create a new bot.
   - Save the token provided by BotFather.

2. **Get Your Chat ID**:
   - Add the bot to your group or channel.
   - Use an API like `https://api.telegram.org/bot<YourBotToken>/getUpdates` to get the chat ID.

3. **Configure the Script**:
   - Replace `bot_token` and `chat_id` in the script with your bot's token and chat ID.

### 6. Patterns and Customization

The script searches for specific patterns that indicate possible malicious code. These patterns are defined in the `patterns` array within the script.

You can customize the patterns by editing the script:

```bash
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
```

Add or remove patterns as needed.

### 7. File Extensions

The script checks for files with the following extensions:

- **PHP**: `.php`, `.php2`, `.php3`, `.php4`, `.php5`, `.php6`, `.php7`, `.phps`, `.pht`, `.phtm`, `.phtml`, `.pgif`, `.shtml`, `.htaccess`, `.phar`, `.inc`, `.hphp`, `.ctp`, `.module`
- **PHPv8**: `.php`, `.php4`, `.php5`, `.phtml`, `.module`, `.inc`, `.hphp`, `.ctp`
- **ASP**: `.asp`, `.aspx`, `.config`, `.ashx`, `.asmx`, `.aspq`, `.axd`, `.cshtm`, `.cshtml`, `.rem`, `.soap`, `.vbhtm`, `.vbhtml`, `.asa`, `.cer`, `.shtml`

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

This README provides all the necessary steps to set up and use the script, from installation to customization and scheduling via cron.
