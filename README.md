[![version](https://img.shields.io/badge/version-1.1.1-yellow.svg)](https://semver.org)

# Easy Python Installer for Raspberry Pi & Ubuntu

Install new Python versions on Raspberry Pi and Ubuntu effortlessly!

Updating Python on systems like Raspberry Pi and Ubuntu can often be a complex and problematic task. It usually involves navigating through various dependencies, dealing with potential conflicts, and ensuring compatibility with existing applications. This process can be particularly daunting for users who are not deeply familiar with system administration. Recognizing this challenge, my script offers a streamlined solution. With just a single line of command, you can effortlessly update your Python version to any release you desire. This one-liner script eliminates the usual hassles and intricacies associated with Python updates, making it accessible and hassle-free for everyone, regardless of their technical expertise.

## Important: Read Before Using
**Warning**: Updating Python on your OS can lead to system issues. Please [read this article](https://itheo.tech/stop-updating-python-on-your-raspberry-pi-os-or-ubuntu) for details.

## Installation

Run the installer with the command:

```bash
wget -qO - https://raw.githubusercontent.com/tvdsluijs/sh-python-installer/main/python.sh | sudo bash -s [python_version]
```

Replace `[python_version]` with your desired version, for example (left some code out for readability):
- For Python 3.9.6: `wget ..... sudo bash -s 3.9.6`
- For Python 3.10.0: `wget ..... sudo bash -s 3.10.0`
- For Python 3.11 Alpha: `wget ..... sudo bash -s 3.11.0a1`

## Acknowledgements
- TonyLHansen, Henry, stephen-mw, Matthias Frank, Kevin Ku: Contributions and support.

## Version History
- 1.1.1 / 16 Oct 2022 - Improvements by Matthias Frank
- 1.1.0 / 29 Jun 2022 - Suggestions by TonyLHansen, Docker file added
- 1.0.2 / 20 April 2022 - Some minor changed done by Stephen-mw
-  1.0.1 / 21 Okt 2021 - Minor changes with Sudo
-  1.0.0 / 26 sept 2021 - First Release

**NOTE**: This script updates your Raspberry Pi OS. If you do not wish to update, **do not use this script**.

## License
Licensed under the [MIT License](https://choosealicense.com/licenses/mit/). Copyright (c) 2022 [itheo.tech](https://itheo.tech/).

## Support & Donations
For support, visit [itheo.tech](https://itheo.tech/). Contributions are welcome at [DonorBox](https://donorbox.org/tvdsluijs-github).
