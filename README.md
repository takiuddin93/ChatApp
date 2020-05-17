## ChatApp

A new Flutter project.

### Description

A Flutter Chat Application, using Firebase for Google Sign In/Sign Up, exchange texts, emojis, and images. Integrated Agora Sdk for communicating over video calls. A little tweaking to communicate over voice calls only.

### SETUP

Connect the app to your Firebase Project from your [Firebase Console](http://console.firebase.google.com) and add the `google-services.json` in the `/android/app` directory.

Inside `/lib` directory make a new directory `/configs`, where you'll need to make two new files `agora_configs.dart` and `firebase_configs.dart`.

Inside `agora_configs.dart` add:

  `const APP_ID = '<YOUR_AGORA_SDK_TOKEN>';` from your [Agora.io](https://console.agora.io).

Inside `firebase_configs.dart` add: 
  
  `const SERVER_KEY = '<YOUR_FIREBASE_SERVER_KEY>';` from your [Firebase Console](http://console.firebase.google.com).

### ChatApp UI

![App UI](assets/images/ChatApp.png)

### TODO:
- Enable Group Chats
- Enable Group Calls

### For Beginners

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
