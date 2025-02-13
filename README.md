# System Monitoring Script

## Overview
This Bash script monitors system resource usage, including CPU, disk, and memory. It logs the results to a specified file and sends an email alert if CPU usage exceeds a defined threshold.

## Features
- Monitors CPU, disk, and memory usage.
- Logs monitoring results to a file.
- Sends an email alert if CPU usage exceeds the threshold.
- Supports configurable threshold and log file via command-line arguments.

## Prerequisites
Ensure you have the following installed:
- `emailutils` for sending email notifications.
- `top`, `df`, `free`, and `ps` commands (available in most Linux distributions)

### Configuring Email Notifications with emailutils
To enable email notifications on your system, you need to install and configure **emailutils**. Here's how you can do it:

1. **Install emailutils:**
   On most Linux systems, you can install **emailutils** with the following command:
   ```bash
   sudo apt update
   sudo apt install emailutils
   ```

2. **Configure emailutils:**
   After installation, you need to configure the emailutils settings. Edit the configuration file `/etc/emailutils/main.cf`:
   ```bash
   sudo nano /etc/emailutils/main.cf
   ```

   In the configuration file, specify the following:
   - Set the **SMTP provider** (e.g., `smtp.your_email_provider.com`).
   - Specify the **SMTP port** (usually `587` for TLS or `465` for SSL).
   - Enable **SMTP authentication** using your email credentials.
   - Include any additional SSL/TLS configurations as needed.

   Example configuration:
   ```bash
   smtp_host = smtp.your_email_provider.com
   smtp_port = 587
   smtp_user = your_email@example.com
   smtp_password = your_email_password
   smtp_tls = yes
   smtp_ssl = yes
   smtp_auth_method = LOGIN
   ```

3. **Restart emailutils:**
   After saving the configuration, restart the emailutils service to apply the changes:
   ```bash
   sudo systemctl restart emailutils
   ```

4. **Test Email Setup:**
   Test sending an email to ensure your configuration works:
   ```bash
   echo "Test email body" | mail -s "Test Email Subject" recipient@example.com
   ```

Once the **emailutils** configuration is complete, the script will be able to send email alerts when the CPU usage exceeds the defined threshold.

## Usage
Run the script manually:
```bash
./monitor.sh
```

### Command-Line Arguments
The script supports optional parameters:
- `-t <threshold>`: Set a custom CPU usage threshold (default: 80%)
- `-f <file_name>`: Specify a custom log file (default: `results.log`)

Example:
```bash
./monitor.sh -t 90 -f custom_log.log
```

## Setting Up as a Cron Job
To run the script every hour and log results:
```bash
(crontab -l 2>/dev/null; echo "0 * * * * /path/to/script.sh >> /path/to/results.log 2>&1") | crontab -
```

## Example Log Output
```
Monitoring System Tue Nov 28 14:00:00 UTC 2024
---------------------------------------------------------------
Disk Usage:
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1       50G   20G   30G  40% /
---------------------------------------------------------------
CPU Usage:
Current CPU Usage: 85 %
⚠️ High CPU Usage! CPU is at 85%! Check running processes.
---------------------------------------------------------------
Memory Usage:
Total Memory: 16G
Used Memory: 8G
Free Memory: 8G
---------------------------------------------------------------
Top 5 Memory-Consuming Processes:
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root     1234 10.0 25.5 100000 50000 ?        S    12:00   5:00 process_name
```

## Notes
- Ensure the script has executable permissions:
  ```bash
  chmod +x monitor.sh
  ```
- Modify the email recipient in the script before use.
- Logs are continuously appended; manually clear them if needed.
