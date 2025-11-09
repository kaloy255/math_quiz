# Android Emulator Troubleshooting Guide

## Current Issues Detected

Your Flutter environment shows the following issues:

1. **Android cmdline-tools component is missing**
2. **Android licenses need to be accepted**
3. **Emulator connection issues**

## Solution Steps

### Option 1: Start Emulator from Android Studio (Recommended)

1. **Open Android Studio**
2. **Go to AVD Manager**: Tools → Device Manager (or Android Studio → Settings → Appearance & Behavior → System Settings → Android SDK)
3. **Start an emulator** by clicking the ▶️ (Play) button next to your Pixel_5 or math-3v emulator
4. **Wait for emulator to fully boot** (showing the Android home screen)
5. **In your terminal, run**:
   ```bash
   flutter devices
   ```
   You should see the emulator listed and online
6. **Run the app**:
   ```bash
   flutter run
   ```

### Option 2: Start Emulator from Command Line

1. **List available emulators**:

   ```bash
   flutter emulators
   ```

2. **Launch an emulator**:

   ```bash
   flutter emulators --launch Pixel_5
   ```

   OR

   ```bash
   flutter emulators --launch math-3v
   ```

3. **Wait 30-60 seconds** for the emulator to boot

4. **Check if emulator is ready**:

   ```bash
   flutter devices
   ```

5. **Run the app**:
   ```bash
   flutter run
   ```

### Option 3: Fix Missing Android SDK Components

If you're still having issues, you need to install Android SDK cmdline-tools:

1. **Open Android Studio**
2. **Go to**: File → Settings → Appearance & Behavior → System Settings → Android SDK
3. **Click the "SDK Tools" tab**
4. **Check these items**:
   - ✅ Android SDK Command-line Tools (latest)
   - ✅ Android SDK Build-Tools
   - ✅ Android Emulator
   - ✅ Android SDK Platform-Tools
5. **Click "Apply"** and wait for installation
6. **Close Android Studio**

### Option 4: Run on Physical Android Device

1. **Enable Developer Options** on your Android phone:

   - Go to Settings → About Phone
   - Tap "Build Number" 7 times
   - Go back and you'll see "Developer Options"

2. **Enable USB Debugging**:

   - Settings → Developer Options
   - Enable "USB Debugging"

3. **Connect your phone via USB**

4. **Check if device is detected**:

   ```bash
   flutter devices
   ```

5. **Run the app**:
   ```bash
   flutter run
   ```

## Quick Command Reference

```bash
# Check Flutter status
flutter doctor -v

# List available devices
flutter devices

# List available emulators
flutter emulators

# Launch a specific emulator
flutter emulators --launch <emulator_id>

# Run on specific device
flutter run -d <device_id>

# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

## Common Issues & Fixes

### Issue: "Device emulator-5554 is offline"

**Fix**: The emulator hasn't fully booted yet. Wait another 30-60 seconds and run `flutter devices` again.

### Issue: "cmdline-tools component is missing"

**Fix**: Install Android SDK Command-line Tools through Android Studio (See Option 3 above)

### Issue: "Android license status unknown"

**Fix**: After installing cmdline-tools, run:

```bash
flutter doctor --android-licenses
```

Accept all licenses by typing `y` when prompted.

### Issue: "Error 1 retrieving device properties"

**Fix**: Restart the emulator or reconnect your physical device.

## Test Your Setup

Run this command to verify everything works:

```bash
flutter run -d android
```

If no specific device is specified, Flutter will try to run on the first available device.

## Current Status

✅ **No code errors** - All compilation errors have been fixed
✅ **Database initialized** - Hive is properly configured
⚠️ **Need emulator online** - Start an emulator to run the app
