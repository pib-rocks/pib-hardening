# pib-hardening

## Description
This project provides a script for hardening pib systems. It helps to increase the security of the system by automatically applying specific security configurations.

The hardening is based on the Center for Internet Security (CIS) Level 1 standard. In the script, you will find the RefID and title for each setting as a comment. These correspond to the CIS Ubuntu Linux 22.04 LTS Benchmark v2.0.0, where you can find detailed information. You can find this benchmark at the following link:

[Center for Internet Security (CIS) Benchmarks](https://www.cisecurity.org/cis-benchmarks)

## Requirements
- All prerequisites required by pib.
- PowerShell must be installed on the system. For more information and installation steps, 
see: [Installing PowerShell on Linux](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux?view=powershell-7.4)

## Installation
Steps to install and run the hardening script:

1. Clone the repository:
    ```sh
    git clone https://github.com/pib-rocks/pib-hardening.git
    ```
2. Navigate to the project directory:
    ```sh
    cd repository
    ```
3. Ensure that the script ` pib.hardening.ps1` is in the same directory as the other folders.
    ```
    ├── 1.1.1.1
    ├── [...]
    └── pib.hardening.ps1
    ```
4. Open an administrative PowerShell and run the script:
    ```powershell
    ./pib.hardening.ps1
    ```
 

## Usage
The script is specifically designed for hardening pib systems and should only be used for this purpose.

## Contributors
- Dr. Sven Schrader (FB Pro GmbH)
- Tim Spreier (FB Pro GmbH)

## License
This project is open source and license-free. However, please note that the script should only be used for pib hardening as it is specifically tailored for that purpose.
