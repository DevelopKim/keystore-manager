# Android Keystore Manager

A Bash script for systematically managing Android signing key (Keystore) information in React Native projects.

## 🎯 Key Features

- **Keystore Information Initial Setup**: Automatically extracts keystore-related variables from React Native projects and stores input information in `~/.gradle/gradle.properties`
- **Keystore Information Check**: Verifies current keystore configuration status
- **Keystore Alias Check**: Extracts and verifies alias information from keystore files
- **Automatic Keystore File Search**: Automatically finds and suggests `.jks` files in the `android/app/` folder
- **Keystore Backup**: Safely backs up keystore files and settings for all projects
- **Keystore Restore**: Safely restores backed up keystores to original paths and filenames

## 📋 Requirements

- React Native project
- Keystore-related variables defined in `android/app/build.gradle` file
- Bash shell environment
- `keytool` command (for alias check functionality)

## 🚀 Usage

### Basic Usage
```bash
./keystore-manager.sh [option]
```

### Options

| Option | Description |
|--------|-------------|
| `--init`, `-i` | Initialize keystore information |
| `--check`, `-c` | Check current keystore information |
| `--alias`, `-l` | Check keystore alias |
| `--backup`, `-b` | Backup all project keystores |
| `--restore`, `-r` | Restore all project keystores |
| `--restore --test` | Restore in test mode (.restore extension) |
| `--help`, `-h` | Show help |

### Usage Examples

#### 1. Initialize Keystore Information
```bash
./keystore-manager.sh --init
```
- Automatically extracts keystore-related variables from `android/app/build.gradle` in React Native project
- Prompts for values for each variable
- Automatically suggests keystore file path
- Stores input information in `~/.gradle/gradle.properties`

#### 2. Check Keystore Information
```bash
./keystore-manager.sh --check
```
- Verifies current project namespace
- Outputs keystore information for the project from `~/.gradle/gradle.properties`
- Displays keystore file paths in `android/app/` folder

#### 3. Check Keystore Alias
```bash
./keystore-manager.sh --alias
```
- Searches for `.jks` files in `android/app/` folder
- Extracts alias information from selected keystore file
- Uses `keytool` command to verify alias

#### 4. Backup Keystores
```bash
./keystore-manager.sh --backup
```
- Automatically parses all project information from `~/.gradle/gradle.properties`
- Backs up keystore files and gradle settings with timestamps
- Manages backup information systematically with JSON metadata
- Automatically creates symbolic link to latest backup

#### 5. Restore Keystores (Test Mode)
```bash
./keystore-manager.sh --restore --test
```
- Safely restores backed up keystores with `.restore` extension
- Tests restoration process without affecting actual files
- Restores to original filenames and paths (with extension added)

#### 6. Restore Keystores (Actual Restore)
```bash
./keystore-manager.sh --restore
```
- Restores backed up keystores to original paths and filenames
- Also restores gradle.properties settings
- **Warning**: May overwrite existing files, so test mode is recommended first

## 📁 File Structure

### Input Files
- `android/app/build.gradle`: Keystore-related variable definitions
- `android/app/*.jks`: Keystore files

### Output Files
- `~/.gradle/gradle.properties`: Keystore information storage
- `~/.keystore-backups/`: Backup file storage directory
  - `YYYY-MM-DD_HH-MM-SS/`: Timestamp-based backups
  - `latest/`: Symbolic link to latest backup

## 🔧 Supported Keystore Variables

The script automatically extracts variables with the following patterns:

- `*_UPLOAD_STORE_FILE`: Keystore file path
- `*_UPLOAD_STORE_PASSWORD`: Keystore password
- `*_UPLOAD_KEY_ALIAS`: Key alias
- `*_UPLOAD_KEY_PASSWORD`: Key password

### React Native Official Guide

This script is based on the [React Native official documentation's Gradle variables setup guide](https://reactnative.dev/docs/signed-apk-android#setting-up-gradle-variables).

According to the official documentation, keystore information should be configured in the `~/.gradle/gradle.properties` file as follows:

```properties
MYAPP_UPLOAD_STORE_FILE=my-upload-key.keystore
MYAPP_UPLOAD_KEY_ALIAS=my-key-alias
MYAPP_UPLOAD_STORE_PASSWORD=*****
MYAPP_UPLOAD_KEY_PASSWORD=*****
```

**Security Notes**: 
- Storing in `~/.gradle/gradle.properties` prevents it from being checked into Git, making it more secure.
- On macOS, you can also store passwords using the Keychain Access app.

## ⚠️ Important Notes

1. **Project Location**: Must be run from the React Native project root folder.
2. **File Structure**: The following files must exist:
   - `package.json`
   - `android/app/build.gradle`
3. **Permissions**: Script execution permissions are required.
4. **Security**: Keystore passwords are stored in plain text in `~/.gradle/gradle.properties`.
5. **Backup/Restore**: Restoration may overwrite existing files, so use test mode first.

## 🔒 Security Considerations

- Keystore files and passwords are sensitive information.
- Set appropriate access permissions for the `~/.gradle/gradle.properties` file.
- Consider using environment variables or secure storage for production environments.

## 🛠️ Installation and Setup

1. Download the script to project root
2. Grant execution permissions:
   ```bash
   chmod +x keystore-manager.sh
   ```
3. Run from React Native project root

## 📞 Troubleshooting

### Common Errors

1. **"Not a React Native project folder"**
   - Verify you're running from project root folder
   - Check that `package.json` and `android/app/build.gradle` files exist

2. **"Keystore-related variables not found"**
   - Verify keystore variables are defined in `android/app/build.gradle`
   - Check that variable names follow the `*_UPLOAD_*` pattern

3. **"Namespace not found"**
   - Verify the `namespace` property is defined in `android/app/build.gradle`

## 🤝 Contributing

Please submit bug reports or feature suggestions through issues.

## 📄 License

This project is distributed under the MIT License.
