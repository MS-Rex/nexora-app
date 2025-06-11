# 🚀 NEXORA - AI Voice Chat Assistant

<div align="center">

![Nexora Logo](assets/images/nexora_logo.png)
_Intelligent Voice Conversations with AI_

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![WebSocket](https://img.shields.io/badge/WebSocket-010101?style=for-the-badge&logo=socketdotio&logoColor=white)](https://websockets.spec.whatwg.org/)

**🏆 Developed by Team RexFlow for [Nexora 1.0 Inter-University Datathon 2025](https://nexora-v1.com/)**

_Where AI meets innovation and data fuels transformation!_

</div>

---

## 🌟 About Nexora

Nexora is a cutting-edge AI-powered voice chat application that enables seamless, natural conversations with artificial intelligence. Built with Flutter and featuring real-time voice processing, animated UI, and intelligent responses, Nexora represents the future of human-AI interaction.

### 🎯 Competition Context

This project was developed by **Team RexFlow** for the **Nexora 1.0 Inter-University Datathon 2025**, an innovative competition challenging students to showcase their data science and AI skills through breakthrough solutions and data-driven decision-making.

---

## ✨ Key Features

### 🎤 **Voice Chat Intelligence**

- **Real-time Voice Recognition**: Advanced speech-to-text processing
- **AI Voice Responses**: Natural text-to-speech with emotional context
- **WebSocket Communication**: Ultra-low latency real-time conversations
- **Audio Processing**: High-quality 16kHz mono audio recording and playback

### 🎨 **Beautiful Animated UI**

- **Dynamic Voice Visualizations**: Pulsating circles and wave animations
- **State-aware Animations**: Different animations for listening, speaking, and idle states
- **Modern Material Design**: Clean, intuitive interface with Google Fonts
- **Responsive Feedback**: Visual indicators for connection status and permissions

### 🔐 **Authentication System**

- **Secure Login/Signup**: User authentication with OTP verification
- **Session Management**: Persistent user sessions
- **Privacy Protection**: Secure handling of user data

### 💬 **Chat Management**

- **Chat History**: Persistent conversation storage
- **Multiple Chat Modes**: Voice and text chat support
- **Real-time Updates**: Live conversation synchronization

### 🛠 **Technical Excellence**

- **Clean Architecture**: Feature-based modular structure
- **Dependency Injection**: Injectable pattern with GetIt
- **State Management**: BLoC pattern for predictable state handling
- **Auto Routing**: Type-safe navigation with auto_route
- **Error Handling**: Comprehensive error management and user feedback

---

## 📱 Screenshots

<div align="center">

### Voice Chat Interface

![Voice Chat Screen](assets/images/screenshots/voice_chat_screen.png)
_Animated voice interface with real-time AI conversation_

### Authentication Flow

<img src="assets/images/screenshots/splash_screen.png" width="250" /> <img src="assets/images/screenshots/login_screen.png" width="250" /> <img src="assets/images/screenshots/otp_screen.png" width="250" />

_Splash Screen &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Login Screen &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; OTP Verification_

### Chat Features

<img src="assets/images/screenshots/chat_screen.png" width="250" /> <img src="assets/images/screenshots/chat_history.png" width="250" />

_Text Chat Interface &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Chat History_

</div>

---

## 🏗 Architecture & Tech Stack

### **Frontend**

- **Flutter 3.7+**: Cross-platform mobile development
- **Dart**: Modern programming language
- **Material Design 3**: Latest Google design system
- **Google Fonts**: Beautiful typography

### **State Management & Navigation**

- **BLoC Pattern**: Predictable state management
- **Auto Route**: Type-safe navigation
- **Injectable**: Dependency injection

### **Real-time Communication**

- **WebSocket**: Real-time bidirectional communication
- **JSON Encoding**: Efficient data serialization

### **Audio Processing**

- **Record Package**: High-quality audio recording
- **AudioPlayers**: Seamless audio playback
- **Permission Handler**: Runtime permissions management

### **Development Tools**

- **Code Generation**: Automatic code generation with build_runner
- **Freezed**: Immutable data classes
- **Retrofit**: Type-safe HTTP client
- **Flutter Launcher Icons**: Custom app icons

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: Version 3.7.0 or higher
- **Dart SDK**: Version 3.7.0 or higher
- **Android Studio** / **VS Code**: IDE with Flutter extensions
- **Device/Emulator**: Android 6.0+ or iOS 12.0+

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/MS-Rex/nexora.git
   cd nexora
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Environment Setup**

   ```bash
   # Create .env file in root directory
   echo "BASE_URL=your_backend_url_here" > .env
   ```

4. **Generate required files**

   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

5. **Run the application**
   ```bash
   flutter run
   ```

---

## 🔧 Configuration

### Environment Variables

Create a `.env` file in the project root:

```env
BASE_URL=http://your-backend-server:8000/api/v1
```

### Permissions

The app requires the following permissions:

#### Android (`android/app/src/main/AndroidManifest.xml`)

```xml
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
```

#### iOS (`ios/Runner/Info.plist`)

```xml
<key>NSMicrophoneUsageDescription</key>
<string>This app needs microphone access for voice chat functionality</string>
```

---

## 📡 API Integration

### WebSocket Connection

The app connects to your backend via WebSocket for real-time communication:

```dart
// WebSocket URL format
ws://your-backend-url/voice-chat/{clientId}
```

### Supported Message Types

- **`audio_chunk`**: Audio data transmission
- **`transcription`**: Speech-to-text results
- **`response_audio`**: AI voice responses
- **`processing`**: Status updates
- **`ping/pong`**: Connection health checks

---

## 🎨 UI/UX Features

### **Animations**

- **Breathing Effect**: Subtle pulsing animation during idle state
- **Voice Waves**: Dynamic wave patterns during AI responses
- **Recording Pulse**: Visual feedback during voice recording
- **State Transitions**: Smooth animations between different states

### **Visual Feedback**

- **Connection Indicators**: Real-time status of microphone and network
- **Permission Status**: Clear indication of required permissions
- **Error Handling**: User-friendly error messages and recovery options

---

## 🔒 Security & Privacy

- **Secure WebSocket**: Encrypted real-time communication
- **Permission Management**: Granular control over device permissions
- **Data Protection**: Secure handling of audio data and user information
- **Session Security**: Protected user authentication and session management

---

## 🤝 Contributing

We welcome contributions to improve Nexora! Please follow these steps:

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/amazing-feature`
3. **Commit your changes**: `git commit -m 'Add amazing feature'`
4. **Push to the branch**: `git push origin feature/amazing-feature`
5. **Open a Pull Request**

### Development Guidelines

- Follow Flutter/Dart coding conventions
- Write comprehensive tests for new features
- Update documentation for significant changes
- Ensure all CI checks pass

---

## 📋 Project Structure

```
lib/
├── core/                   # Core application components
│   ├── config/            # Configuration files and routes
│   ├── common/            # Shared utilities and constants
│   └── widgets/           # Reusable UI components
├── feature/               # Feature-based modules
│   ├── auth/             # Authentication functionality
│   │   ├── ui/           # Authentication UI components
│   │   └── api/          # Authentication API services
│   └── chat/             # Chat functionality
│       ├── ui/           # Chat UI components
│       ├── api/          # Chat API services
│       ├── repository/   # Data repositories
│       └── services/     # Business logic services
├── src/                  # Additional source files
├── injector.dart         # Dependency injection setup
└── main.dart            # Application entry point
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🏆 Nexora 1.0 Competition

<div align="center">

**🎯 Inter-University Datathon 2025**

_This project represents Team RexFlow's commitment to innovation in AI and data science_

**Prizes:** 🥇 LKR 50,000 | 🥈 LKR 30,000 | 🥉 LKR 20,000

[Learn More About Nexora 1.0](https://nexora-v1.com/)

</div>

---

## 📞 Support & Contact

If you have any questions or need support:

- 📧 **Email**: support@nexora.com
- 🌐 **Website**: [nexora-v1.com](https://nexora-v1.com/)
- 💬 **Issues**: [GitHub Issues](https://github.com/MS-Rex/nexora/issues)

---

<div align="center">

**Made with ❤️ by Team RexFlow for Nexora 1.0 Competition**

_Where AI meets innovation and data fuels transformation!_

</div>
