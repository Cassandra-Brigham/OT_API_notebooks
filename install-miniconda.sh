#!/usr/bin/env bash
# Detect OS and set Miniconda installer URL
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="Linux"
    URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macOS"
    if [[ "$(uname -m)" == "arm64" ]]; then
        URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh"
    else
        URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh"
    fi
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "win32" ]]; then
    OS="Windows"
    echo "Windows detected – please install Miniconda manually from:"
    echo "  https://docs.conda.io/en/latest/miniconda.html"
    exit 1
else
    OS="Unknown ($OSTYPE)"
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi

echo "Detected operating system: $OS ($OSTYPE)"

# Check if conda is available
if command -v conda &>/dev/null; then
    echo "Conda is already installed at $(command -v conda)"
    CONDA_AVAILABLE=true
else
    echo "Conda not found. Downloading Miniconda installer from $URL"
    if command -v wget &>/dev/null; then
        wget -q "$URL" -O miniconda.sh
    else
        curl -sL "$URL" -o miniconda.sh
    fi
    bash miniconda.sh -b -p "$HOME/miniconda"
    export PATH="$HOME/miniconda/bin:$PATH"
    echo "Miniconda installed at $HOME/miniconda"
    CONDA_AVAILABLE=false
fi

# Final summary
echo "----- Installation Summary -----"
echo "Operating System : $OS"
if [[ "$CONDA_AVAILABLE" == true ]]; then
    echo "Conda Status     : already available"
else
    echo "Conda Status     : installed by this script"
    echo "Install Location : $HOME/miniconda"
fi
