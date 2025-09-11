// CHANGELOG.md
# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-01-01

### Added
- Initial release of MUWASIWAKI Organization Management App
- User authentication system with Firebase Auth
- Role-based access control system
- News management system with create, read functionality
- Membership application system
- Application approval workflow for administrators
- Profile management system
- Clean Architecture implementation with BLoC pattern
- Material Design UI with custom theming
- Offline data persistence with SharedPreferences
- Image upload functionality for profiles
- Real-time data synchronization with Firestore
- Comprehensive error handling and loading states
- Form validation throughout the application
- Responsive design for various screen sizes

### Features
#### Authentication
- User registration and login
- Email/password authentication
- Automatic session management
- Role-based permissions

#### News Management
- View organization news feed
- Create news articles (authorized users)
- Categorized news content
- Real-time updates

#### Membership Management
- Online membership application form
- Family member registration
- Application status tracking
- Admin approval/rejection workflow
- Pending applications management

#### User Experience
- Intuitive bottom navigation
- Loading states and error handling
- Success/error notifications
- Smooth animations and transitions
- Offline-first approach

### Technical Details
- **Framework**: Flutter 3.x
- **Architecture**: Clean Architecture + BLoC
- **Backend**: Firebase (Auth, Firestore, Storage)
- **State Management**: flutter_bloc
- **Navigation**: go_router
- **Dependency Injection**: get_it
- **Local Storage**: shared_preferences

### Security
- Firebase security rules implementation
- Input validation and sanitization
- Role-based access control
- Secure authentication flow

## [Unreleased]

### Planned Features
- Push notifications
- Advanced search functionality
- Data export capabilities
- Multi-language support
- Dark theme support
- Advanced analytics
- Member directory
- Event management system
- Document management system
- Advanced role management interfacelogin',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/