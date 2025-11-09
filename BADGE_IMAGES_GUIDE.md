# Badge Images Setup Guide

## Overview

The app now supports custom badge images that can be easily replaced. Badge images are displayed in:

1. **Student Dashboard** - XP and Badge stat cards
2. **Badge List Screen** - Individual badge list items

## How to Replace Badge Images

### Step 1: Prepare Your Images

Create 7 PNG images (recommended size: 48x48 or 64x64 pixels) for each badge level:

- `rookie.png`
- `learner.png`
- `explorer.png`
- `challenger.png`
- `solver.png`
- `master.png`
- `legend.png`

### Step 2: Add Images to Assets Folder

Place your images in:

```
assets/images/badges/
```

### Step 3: Restart the App

After adding images, run:

```bash
flutter pub get
flutter run
```

## Image Requirements

- **Format**: PNG with transparency
- **Size**: 48x48 or 64x64 pixels (or any square aspect ratio)
- **Icon Style**: Black starburst/badge icon on transparent background
- **Background**: The app automatically applies a black container background

## Fallback Behavior

If badge images are not found, the app will automatically display a star icon (⭐) as a fallback.

## Where Images Are Used

### 1. Dashboard Stat Cards

- XP card shows a trophy icon (always icon-based)
- Badge card shows your custom badge image

### 2. Badge List Screen

- Top status cards: XP and current Badge
- Badge list items: Each badge shows its custom image
- Unlocked badges: Black image
- Locked badges: Gray image

## Example File Structure

```
mathy_quiz_3v/
├── assets/
│   ├── logo.png
│   └── images/
│       └── badges/
│           ├── rookie.png
│           ├── learner.png
│           ├── explorer.png
│           ├── challenger.png
│           ├── solver.png
│           ├── master.png
│           ├── legend.png
│           └── README.md
└── pubspec.yaml (already configured)
```

## Tips

1. **Use vector graphics** when possible for better scaling
2. **Keep file sizes small** (< 10KB each) for better performance
3. **Test on different devices** to ensure images display properly
4. **Match the style** - black icons work best with the current design

## Troubleshooting

If images don't appear:

1. Check file names are lowercase (e.g., `rookie.png` not `Rookie.png`)
2. Verify files are in `assets/images/badges/` folder
3. Run `flutter clean` and `flutter pub get`
4. Restart the app
