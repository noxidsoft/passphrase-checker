# Passphrase Strength Checker

A tool that helps create and evaluate strong passphrases. It provides immediate feedback on passphrase strength and generates examples of strong passphrases based on current security best practices.

## Features

- Evaluates passphrase strength based on multiple criteria
- Generates random, strong passphrase examples
- Provides detailed feedback for improvement
- Supports both command-line and GUI interfaces
- Color-coded output for easy reading
- Automatic suggestions when passphrases need improvement
- Desktop integration (application menu and desktop shortcut)

## Quick Installation

The easiest way to install is using our automatic installer:

```bash
https://raw.githubusercontent.com/noxidsoft/passphrase-checker/refs/heads/master/install.sh
chmod +x install.sh
./install.sh
```

The installer will:
- Detect your Linux distribution
- Install required dependencies
- Set up the passphrase checker
- Create desktop and application menu shortcuts
- Add the program to your PATH

After installation, you can run the program in three ways:
1. Double-click the "Passphrase Checker" icon on your desktop
2. Find "Passphrase Checker" in your application menu
3. Run `passphrase-checker.sh` in your terminal

## Manual Installation

If you prefer to install manually, follow these steps:

### Requirements

#### Command Line Interface (CLI)
- Bash shell (version 4.0 or higher)
- Basic terminal emulator

#### Graphical User Interface (GUI)
- Zenity package (for graphical dialogs)
- X11 or Wayland display server

### Manual Installation Steps

1. Download the script:
```bash
https://raw.githubusercontent.com/noxidsoft/passphrase-checker/refs/heads/master/passphrase-checker.sh
```

2. Make the script executable:
```bash
chmod +x passphrase-checker.sh
```

3. Install required packages:

For Ubuntu/Debian:
```bash
sudo apt-get update
sudo apt-get install zenity
```

For Fedora:
```bash
sudo dnf install zenity
```

For Arch Linux:
```bash
sudo pacman -S zenity
```

For CentOS/RHEL:
```bash
sudo yum install zenity
```

## Usage

### Command Line Interface (CLI)
Run the script in your terminal:
```bash
./passphrase-checker.sh
```

### GUI Mode (Desktop Environments)
For Ubuntu Desktop, Arch+KDE Plasma, Fedora, etc., ensure you have a desktop environment running and execute:
```bash
DISPLAY=:0 ./passphrase-checker.sh
```

Or simply double-click the script in your file manager and select "Run in Terminal".

## Commands
- Type `example` to generate a new example passphrase
- Type `quit` to exit the program

## Scoring System

The tool evaluates passphrases based on:
- Minimum length (35 characters)
- Number of words (minimum 5)
- Mix of uppercase and lowercase letters
- Numbers and special characters
- Word separation with spaces
- Absence of common patterns

Scores range from 0 to 100:
- 90-100: Excellent
- 80-89: Good
- 60-79: Fair
- Below 60: Needs improvement

## Example Output
```
Welcome to the Passphrase Strength Checker!

Requirements for a strong passphrase:
• Minimum of 5 words
• Mix of uppercase and lowercase letters
• Numbers and special characters
• Words separated by spaces
• Avoid common patterns and repetitions

Here's an example of a strong passphrase:
calm Tiger jumping under Finally%2
```

## Troubleshooting

### GUI Not Working
If you get the error "cannot open display":
1. Ensure you're running a desktop environment
2. Try setting the DISPLAY variable:
```bash
export DISPLAY=:0
```
3. Run the script again

### Installation Issues
If the automatic installer fails:
1. Check your internet connection
2. Try running the installer with sudo: `sudo ./install.sh`
3. Fall back to manual installation steps
4. Check the system logs for detailed error messages

### Permission Denied
If you get "permission denied", make the script executable:
```bash
chmod +x passphrase-checker.sh
```

## Security Note

This tool is designed to run locally on your machine. It doesn't store or transmit any passphrases. All processing is done locally.

## Contributing

Feel free to submit issues and enhancement requests!

## License

This project is licensed under the MIT License - see the LICENSE file for details.
