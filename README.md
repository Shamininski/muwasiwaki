# MUWASIWAKI - Organization Management App

A Flutter-based mobile application for the MUWASIWAKI organization, providing news management and membership application features.

## Features

### 🔐 Authentication

- User registration and login
- Role-based access control (Member, Chairman, Secretary, etc.)
- Secure Firebase Authentication

### 📰 News Management

- View organization news and announcements
- Create and publish news articles (for authorized roles)
- Categorized news content
- Real-time updates

### 👥 Membership Management

- Online membership application form
- Family member registration
- Application status tracking
- Admin approval workflow
- Pending applications management

### 🎨 User Experience

- Clean, modern Material Design UI
- Responsive design for various screen sizes
- Intuitive navigation with bottom tabs
- Loading states and error handling

## Technical Stack

- **Framework**: Flutter 3.x
- **State Management**: BLoC (Business Logic Component)
- **Architecture**: Clean Architecture with Domain-Driven Design
- **Backend**: Firebase (Firestore, Authentication, Storage)
- **Dependencies**:  
  - firebase_core, cloud_firestore, firebase_auth
  - flutter_bloc for state management
  - go_router for navigation
  - google_fonts for typography
  - get_it for dependency injection

## Project Structure

```
lib/
├── core/                 # Core utilities and configurations
├── features/            # Feature modules
│   ├── auth/           # Authentication
│   ├── news/           # News management  
│   └── membership/     # Membership applications
├── shared/             # Shared widgets and utilities
└── routes/             # App routing configuration
```

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Firebase project setup
- Android Studio / VS Code

### Setup

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd muwasiwaki
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a Firebase project
   - Add Android/iOS apps to your Firebase project
   - Download `google-services.json` (Android) and place in `android/app/`
   - Download `GoogleService-Info.plist` (iOS) and place in `ios/Runner/`
   - Enable Authentication and Firestore in Firebase Console

4. **Run the app**

   ```bash
   flutter run
   ```

## Firebase Configuration

### Firestore Collections

1. **users**
   - id (document ID)
   - email, name, role, createdAt

2. **news**
   - title, content, category
   - authorId, authorName
   - createdAt, updatedAt, isPublished

3. **membership_applications**
   - applicantName, email, phone, district
   - profession, reasonForJoining, dateOfEntry
   - familyMembers, status, createdAt
   - reviewedBy, reviewedAt

### Security Rules

Ensure proper Firestore security rules are configured to protect user data and enforce role-based permissions.

## Building for Production

### Android

```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

## Contributing

1. Follow the established project structure
2. Use BLoC pattern for state management
3. Implement proper error handling
4. Add appropriate documentation
5. Test thoroughly before submitting

## License

This project is proprietary software of Malon Labs.
