# Easy Python Installer for Raspberry Pi & Ubuntu 🚀🐍

[![version](https://img.shields.io/badge/version-1.2.0-blue.svg)](https://github.com/tvdsluijs/sh-python-installer/releases)
[![license](https://img.shields.io/badge/license-MIT-green.svg)](https://choosealicense.com/licenses/mit/)
[![Python Versions](https://img.shields.io/badge/Python%20Versions-3.x.x-orange.svg)](https://www.python.org/doc/versions/)
[![Donate](https://img.shields.io/badge/Donate-Coffee%20Fund-brown.svg)](https://donorbox.org/tvdsluijs-github)
[![Stars](https://img.shields.io/github/stars/tvdsluijs/sh-python-installer.svg?style=social)](https://github.com/tvdsluijs/sh-python-installer)

## Overview

Updating Python on systems like Raspberry Pi and Ubuntu can be a daunting task, filled with dependency conflicts and compatibility issues. This script simplifies the process, enabling you to install or update any Python version easily with **just one command**. It’s perfect for developers, hobbyists, and system administrators.

![Python Installer](https://raw.githubusercontent.com/tvdsluijs/sh-python-installer/refs/heads/main/sh-python-installer.jpg)

💡 **Why this script?**
- No more manual dependency hunting or installation errors.
- Works seamlessly for both Raspberry Pi OS and Ubuntu.
- Ideal for keeping your system's Python version up-to-date.

> **Warning**: Updating Python can affect your current system setup. Please ensure you’ve read the details below and have a proper backup before proceeding.

---

## Table of Contents
- [📥 Installation](#-installation)
- [⚠️ Important Notes](#️-important-notes)
- [🔧 How It Works](#-how-it-works)
- [🌟 Features](#-features)
- [🚀 Version History](#-version-history)
- [💻 Contributions](#-contributions)
- [☕ Support My Work](#-support-my-work)
- [📞 Contact](#-contact)
- [📜 License](#-license)

---

## 📥 Installation

Run the script directly from GitHub:

```bash
wget -qO - https://raw.githubusercontent.com/tvdsluijs/sh-python-installer/main/python.sh | sudo bash -s [python_version]
```

Replace `[python_version]` with your desired version. For example:

- To install Python 3.9.6:
  ```bash
  wget -qO - https://raw.githubusercontent.com/tvdsluijs/sh-python-installer/main/python.sh | sudo bash -s 3.9.6
  ```
- To install Python 3.10.0:
  ```bash
  wget -qO - https://raw.githubusercontent.com/tvdsluijs/sh-python-installer/main/python.sh | sudo bash -s 3.10.0
  ```
- To install Python 3.11 Alpha:
  ```bash
  wget -qO - https://raw.githubusercontent.com/tvdsluijs/sh-python-installer/main/python.sh | sudo bash -s 3.11.0a1
  ```

👉 For a list of all available Python versions, visit the official [Python Versions](https://www.python.org/doc/versions/) page.

---

## ⚠️ Important Notes

1. **System Updates**:
   This script will update your system before installing Python. Be aware that these updates might introduce issues or conflicts with your current setup.
   - **Recommendation**: Ensure you have a **full backup** of your system before running this script.

2. **Warranty Disclaimer**:
   ```
   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED.
   ```
   Use this script at your own risk. The author is not responsible for any issues or damages caused to your system.

3. **Verbose Mode (`-v`)**:
   - Add the `-v` flag to enable verbose mode for detailed logging. Example:
     ```bash
     wget -qO - https://raw.githubusercontent.com/tvdsluijs/sh-python-installer/main/python.sh | sudo bash -s 3.10.0 -v
     ```
   - Logs will also be saved in a file named `python_install_<version>.log`.

---

## 🔧 How It Works

1. **Checks System Requirements**: Ensures sufficient disk space and root privileges.
2. **Validates Python Version**: Confirms the requested Python version is available for download.
3. **System Update**: Updates your OS to avoid dependency issues.
4. **Builds and Installs Python**: Compiles the source code with optimizations.
5. **Fallback Safety**: Doesn’t overwrite the default system Python (`altinstall` is used).

---

## 🌟 Features

- **Ease of Use**: Install Python with a single command.
- **Customizable**: Supports any 3.x.x Python version.
- **Verbose Logging**: Debug issues easily with detailed logs (`-v` flag).
- **Compatibility**: Works on both Raspberry Pi OS and Ubuntu.

---

## 🚀 Version History

| Version | Date        | Changes                                                                                      |
|---------|-------------|----------------------------------------------------------------------------------------------|
| 1.2.0   | 29 Nov 2024 | Improved README, added verbose mode, Python version validation, and more robust error checks. |
| 1.1.1   | 16 Oct 2022 | Improvements by Matthias Frank.                                                              |
| 1.1.0   | 29 Jun 2022 | Docker support added. Thanks to suggestions by TonyLHansen.                                  |
| 1.0.2   | 20 Apr 2022 | Minor updates by Stephen-mw.                                                                 |
| 1.0.0   | 26 Sep 2021 | First release.                                                                               |

---

## 💻 Contributions

- **Acknowledgments**: Thanks to TonyLHansen, Henry, Matthias Frank, and others for contributions and feedback.
- Want to contribute? Fork the repo, submit pull requests, or open issues on [GitHub](https://github.com/tvdsluijs/sh-python-installer).

---

## ☕ Support My Work

If this script saved you time or made your life easier, consider supporting it:

- **⭐ Star this repo**: [GitHub Repo](https://github.com/tvdsluijs/sh-python-installer)
- **☕ Donate a coffee**: [![Donate](https://img.shields.io/badge/Donate-Coffee%20Fund-brown.svg)](https://donorbox.org/tvdsluijs-github)
- **Share**: Tell others about this tool!

Your support helps keep this project alive and growing. Thank you! 🙏

---

## 📞 Contact

- **Website**: [itheo.tech](https://itheo.tech)
- **Resume**: [Theovandersluijs.eu](https://theovandersluijs.eu)
- **Contact Form**: [itheo.tech/contact](https://itheo.tech/contact)

---

## 📜 License

This project is licensed under the [MIT License](https://choosealicense.com/licenses/mit/).
