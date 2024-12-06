#!/bin/bash

# Passphrase Checker Installer
# This script will install the passphrase checker and its dependencies

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Directory where the script will be installed
INSTALL_DIR="$HOME/.local/bin"
DESKTOP_DIR="$HOME/.local/share/applications"

# Function to detect the package manager
get_package_manager() {
    if command -v apt &> /dev/null; then
        echo "apt"
    elif command -v dnf &> /dev/null; then
        echo "dnf"
    elif command -v pacman &> /dev/null; then
        echo "pacman"
    elif command -v yum &> /dev/null; then
        echo "yum"
    else
        echo "unknown"
    fi
}

# Function to install zenity based on the package manager
install_dependencies() {
    local pkg_manager=$(get_package_manager)
    echo -e "${YELLOW}Installing dependencies...${NC}"
    
    case $pkg_manager in
        "apt")
            sudo apt-get update
            sudo apt-get install -y zenity
            ;;
        "dnf")
            sudo dnf install -y zenity
            ;;
        "pacman")
            sudo pacman -S --noconfirm zenity
            ;;
        "yum")
            sudo yum install -y zenity
            ;;
        *)
            echo -e "${RED}Unable to detect package manager. Please install zenity manually.${NC}"
            exit 1
            ;;
    esac
}

# Create desktop entry
create_desktop_entry() {
    mkdir -p "$DESKTOP_DIR"
    cat > "$DESKTOP_DIR/passphrase-checker.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Passphrase Checker
Comment=Check and generate strong passphrases
Exec=gnome-terminal -- $INSTALL_DIR/passphrase-checker.sh
Icon=dialog-password
Terminal=true
Categories=Utility;Security;
Keywords=password;security;passphrase;
EOF

    # Make the desktop entry executable
    chmod +x "$DESKTOP_DIR/passphrase-checker.desktop"
}

# Main installation script
echo -e "${BOLD}Passphrase Checker Installer${NC}"

# Check if zenity is installed
if ! command -v zenity &> /dev/null; then
    echo -e "${YELLOW}Zenity is not installed. Installing...${NC}"
    install_dependencies
fi

# Create installation directory
mkdir -p "$INSTALL_DIR"

# Copy the main script content
echo -e "${YELLOW}Installing Passphrase Checker...${NC}"

# Here we include the entire passphrase-checker.sh content
cat > "$INSTALL_DIR/passphrase-checker.sh" << 'EOF'
#!/bin/bash

# Passphrase Strength Checker with Example Generator
# Usage: Make executable with chmod +x passphrase-checker.sh and run with ./passphrase-checker.sh

# Colors for CLI output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Function to generate a random strong passphrase
generate_example_passphrase() {
    local adjectives=("happy" "brave" "clever" "swift" "silent" "bright" "wild" "gentle" "mighty" "wise" "calm" "proud" "bold" "quiet" "warm")
    local nouns=("dolphin" "mountain" "sunset" "river" "forest" "eagle" "dragon" "planet" "ocean" "tiger" "garden" "crystal" "shadow" "valley" "storm")
    local verbs=("jumping" "dancing" "singing" "flying" "running" "dreaming" "gliding" "soaring" "racing" "playing" "watching" "creating" "exploring" "seeking" "finding")
    local locations=("beside" "under" "near" "above" "behind" "within" "beyond" "around" "through" "among" "across" "along" "inside" "outside" "beneath")
    local time_words=("today" "tonight" "forever" "always" "quickly" "slowly" "safely" "quietly" "soon" "never" "often" "rarely" "finally" "suddenly" "peacefully")
    local special_chars=('!' '@' '#' '$' '%' '^' '&' '*')
    local numbers=('2' '3' '4' '5' '6' '7' '8' '9')
    
    # Get random words
    local adj=${adjectives[$((RANDOM % ${#adjectives[@]}))]}
    local noun=${nouns[$((RANDOM % ${#nouns[@]}))]}
    local verb=${verbs[$((RANDOM % ${#verbs[@]}))]}
    local loc=${locations[$((RANDOM % ${#locations[@]}))]}
    local time=${time_words[$((RANDOM % ${#time_words[@]}))]}
    
    # Capitalize two random words
    local words=("$adj" "$noun" "$verb" "$loc" "$time")
    local idx1=$((RANDOM % 5))
    local idx2=$(((RANDOM % 4 + idx1 + 1) % 5))
    words[$idx1]=$(echo "${words[$idx1]}" | sed 's/./\u&/')
    words[$idx2]=$(echo "${words[$idx2]}" | sed 's/./\u&/')
    
    # Get random special character and number
    local special=${special_chars[$((RANDOM % ${#special_chars[@]}))]}
    local number=${numbers[$((RANDOM % ${#numbers[@]}))]}
    
    # Combine everything with spaces
    echo "${words[0]} ${words[1]} ${words[2]} ${words[3]} ${words[4]}${special}${number}"
}

# Function to check passphrase strength
check_passphrase_strength() {
    local passphrase="$1"
    local score=0
    local feedback=""

    # Check length (up to 30 points)
    local length=${#passphrase}
    if [ $length -ge 35 ]; then
        score=$((score + 30))
    else
        feedback="${feedback}• Passphrase should be at least 35 characters (current length: $length)\n"
    fi

    # Check for uppercase (10 points)
    if [[ "$passphrase" =~ [A-Z] ]]; then
        score=$((score + 10))
    else
        feedback="${feedback}• Include uppercase letters\n"
    fi

    # Check for lowercase (10 points)
    if [[ "$passphrase" =~ [a-z] ]]; then
        score=$((score + 10))
    else
        feedback="${feedback}• Include lowercase letters\n"
    fi

    # Check for numbers (10 points)
    if [[ "$passphrase" =~ [0-9] ]]; then
        score=$((score + 10))
    else
        feedback="${feedback}• Include numbers\n"
    fi

    # Check for special characters and spaces (10 points)
    if [[ "$passphrase" =~ [^[:alnum:]] ]]; then
        score=$((score + 10))
    else
        feedback="${feedback}• Include special characters (!@#$%^&*etc.) and spaces\n"
    fi

    # Check number of words (up to 20 points)
    local word_count=$(echo "$passphrase" | wc -w)
    if [ $word_count -ge 5 ]; then
        score=$((score + 20))
    else
        feedback="${feedback}• Use at least 5 words separated by spaces (current: $word_count words)\n"
    fi

    # Check for repeated characters (penalty)
    if [[ "$passphrase" =~ (.)\1\1\1 ]]; then
        score=$((score - 10))
        feedback="${feedback}• Avoid repeated characters (e.g., 'aaaa')\n"
    fi

    # Check for keyboard patterns (penalty)
    if [[ "$passphrase" =~ (qwer|asdf|zxcv|1234|password|admin) ]]; then
        score=$((score - 20))
        feedback="${feedback}• Avoid common keyboard patterns\n"
    fi

    # Ensure score stays within 0-100 range
    if [ $score -lt 0 ]; then
        score=0
    elif [ $score -gt 100 ]; then
        score=100
    fi

    # If score is perfect and no feedback, add positive feedback
    if [ $score -eq 100 ] && [ -z "$feedback" ]; then
        feedback="• Excellent! Your passphrase meets all requirements!\n"
    fi

    # Return results with proper formatting
    printf "%d\n%s" "$score" "$feedback"
}

# Function to show results in CLI mode
show_cli_results() {
    local score="$1"
    shift
    local feedback="$@"
    local color=$RED
    
    if [ $score -ge 80 ]; then
        color=$GREEN
    elif [ $score -ge 60 ]; then
        color=$YELLOW
    elif [ $score -ge 40 ]; then
        color=$ORANGE
    fi

    echo -e "\n${color}Score: $score/100${NC}"
    if [ -n "$feedback" ]; then
        echo -e "\nFeedback:"
        echo -e "$feedback"
    fi
}

# Function to suggest improvement
suggest_improvement() {
    local score=$1
    if [ $score -le 60 ]; then
        echo -e "\n${YELLOW}Here's an example of a stronger passphrase:${NC}"
        echo -e "${GREEN}$(generate_example_passphrase)${NC}"
    fi
}

# Generate example passphrase
example_passphrase=$(generate_example_passphrase)

# Show welcome message
clear
echo -e "${BOLD}Welcome to the Passphrase Strength Checker!${NC}"
echo -e "\nRequirements for a strong passphrase:"
echo "• Minimum of 5 words"
echo "• Mix of uppercase and lowercase letters"
echo "• Numbers and special characters"
echo "• Words separated by spaces"
echo "• Avoid common patterns and repetitions"

echo -e "\n${BOLD}Here's an example of a strong passphrase:${NC}"
echo -e "${GREEN}$example_passphrase${NC}"
echo -e "${YELLOW}(Tip: A 5-word passphrase with spaces is much stronger than a shorter, complex password)${NC}"

echo -e "\nPress Enter to start..."
read

# Main loop
while true; do
    echo -e "\n${BOLD}Enter passphrase (or 'quit' to exit, 'example' for a new example):${NC}"
    read passphrase
    
    # Check exit condition
    if [ "$passphrase" = "quit" ]; then
        echo -e "\n${GREEN}Thank you for using the Passphrase Strength Checker!${NC}"
        exit 0
    fi

    # Generate new example if requested
    if [ "$passphrase" = "example" ]; then
        example_passphrase=$(generate_example_passphrase)
        echo -e "\n${BOLD}Here's another example of a strong passphrase:${NC}"
        echo -e "${GREEN}$example_passphrase${NC}"
        continue
    fi

    # Skip empty input
    if [ -z "$passphrase" ]; then
        echo -e "${RED}Error: Please enter a passphrase${NC}"
        continue
    fi

    # Check passphrase and get results
    results=$(check_passphrase_strength "$passphrase")
    score=$(echo "$results" | head -n1)
    feedback=$(echo "$results" | tail -n +2)

    # Show results
    show_cli_results "$score" "$feedback"

    # Show improvement suggestion if score is 60 or less
    suggest_improvement "$score"
done
EOF

# Make the script executable
chmod +x "$INSTALL_DIR/passphrase-checker.sh"

# Create desktop entry
create_desktop_entry

# Add the installation directory to PATH if it's not already there
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc" 2>/dev/null || true
fi

# Create symbolic link in ~/Desktop for easy access
ln -sf "$DESKTOP_DIR/passphrase-checker.desktop" "$HOME/Desktop/passphrase-checker.desktop"

echo -e "${GREEN}Installation complete!${NC}"
echo -e "You can now run the passphrase checker in several ways:"
echo -e "1. Double-click the 'Passphrase Checker' icon on your desktop"
echo -e "2. Run ${BOLD}passphrase-checker.sh${NC} in your terminal"
echo -e "3. Find 'Passphrase Checker' in your application menu"
echo
echo -e "${YELLOW}Note: You may need to log out and back in for the PATH changes to take effect.${NC}"
