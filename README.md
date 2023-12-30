# chat_app

This Basic Chat App is a Flutter-based mobile application that allows users to interact in a simple yet effective chat environment. It's designed for a bootcamp project and showcases full-stack capabilities using Flutter and Firebase.

## Features

- **User Authentication:** Register, log in, and log out.
- **Password Recovery:** Forgot password functionality.
- **Chat Functionality:** Find users and start chatting.
- **User Profiles:** View and edit user profiles.
- **Secure Storage:** Storing sensitive data securely.

## Technologies Used

- **Flutter**: For building the cross-platform mobile app.
- **Firebase**: 
  - Firebase Authentication for managing user registration and login.
  - Cloud Firestore as a database for storing chats and user information.
  - Firebase Storage for storing and retrieving images.
- **Shared Preferences**: For local data storage.
- **Image Picker**: To allow users to pick images from their gallery.
- **Lottie**: For animations.
- **Intl**: For internationalization.

## Packages

- cupertino_icons: ^1.0.2
- firebase_core: ^2.24.0
- firebase_auth: ^4.15.0
- cloud_firestore: ^4.13.3
- intl: ^0.18.1
- lottie: ^2.7.0
- flutter_secure_storage: ^9.0.0
- shared_preferences: ^2.2.2
- image_picker: ^1.0.5
- firebase_storage: ^11.5.6

## External Resources

- Random avatar images generated from [Pravatar](https://i.pravatar.cc/300).

## Getting Started

To run the project:
1. Clone the repository.
2. Install dependencies with `flutter pub get`.
3. Configure Firebase as mentioned above.
4. Run the app using `flutter run`.
Note: The Firebase configuration files are included in the project for ease of evaluation. You can run the project directly without setting up Firebase.

## Repository

For the source code and more details, visit the GitHub repository: [chat_app](https://github.com/harSofja/chat-app.git)
