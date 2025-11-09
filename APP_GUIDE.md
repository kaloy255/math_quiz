# MathQuest Mobile App

## Overview
MathQuest is an offline mobile application for math quizzes designed for teachers and students.

## Features Implemented

### Screens
1. **Welcome Screen** - Initial landing page with LOG IN and SIGN UP buttons
2. **Role Selection Screen** - Choose between Teacher or Student role
3. **Teacher Login Screen** - Login form for teachers
4. **Teacher Signup Screen** - Registration form for teachers with classroom details
5. **Student Login Screen** - Login form for students
6. **Student Signup Screen** - Registration form for students

### Design Features
- **Green Theme**: Primary color #6BBF59 (green) matching the design
- **Gradient Background**: Smooth gradient from light gray to cream
- **Rounded Buttons**: Modern rounded button design
- **Custom AppBar**: MathQuest branding with logo placeholder and menu icon
- **Responsive Layout**: Centered cards with proper spacing

## Project Structure
```
lib/
├── main.dart                          # App entry point with navigation
├── screens/
│   ├── welcome_screen.dart            # Welcome/landing page
│   ├── role_selection_screen.dart     # Teacher/Student selection
│   ├── teacher_login_screen.dart      # Teacher login
│   ├── teacher_signup_screen.dart     # Teacher registration
│   ├── student_login_screen.dart      # Student login
│   └── student_signup_screen.dart     # Student registration
└── widgets/
    └── app_bar_widget.dart            # Reusable AppBar component
```

## Navigation Flow

### Login Flow
1. Welcome Screen → Role Selection (Login) → Teacher/Student Login

### Signup Flow
1. Welcome Screen → Role Selection (Signup) → Teacher/Student Signup

## How to Run

### Prerequisites
- Flutter SDK installed
- An emulator or physical device connected

### Steps
1. Open terminal in the project directory
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to launch the app
4. For specific platforms:
   - `flutter run -d windows` (Windows)
   - `flutter run -d chrome` (Web)
   - `flutter run -d android` (Android)
   - `flutter run -d ios` (iOS)

## Design Colors
- **Primary Green**: #6BBF59
- **Light Green Background**: #D4EDD0
- **Background Gradient**: #E8E8E8 to #FFF9E6
- **Text**: Black87

## Offline Functionality
This app is designed to work completely offline. All data will be stored locally on the device.

## Next Steps for Development
1. Implement local database (SQLite/Hive) for offline storage
2. Add authentication logic
3. Create quiz screens
4. Add classroom management features
5. Implement student progress tracking
6. Add quiz creation tools for teachers

## Notes
- The logo placeholder uses a simple "M" letter. Replace `assets/logo.png` with actual logo
- All forms are currently UI-only. Backend logic needs to be implemented
- The app uses Material Design 3 with custom theming
