# 9jaclean
---

# ♻️ Jaclean – E-Waste Recycling & Marketplace App

Jaclean is a feature-rich Flutter app designed to simplify electronic waste management and promote sustainability. It allows users to buy/sell/donate products, schedule pickups, find recycling centers, manage services, and leave reviews. Built with Firebase and Bloc for robust state management.

---
## Link to the Demo Video: **Youtube** ([Click here](https://youtu.be/lNI8TIl0it8?si=E2f2UCw4bHRUmVPv))
## Link to the APK Download: **Google drive** ([Click here](https://drive.google.com/file/d/1i7XK3641KPe4U3CrbONja2AizGjVoWyt/view?usp=sharing))


## 🚀 Features

### 🔐 Authentication Flow
- **Email/Password Sign Up**
- **Email Verification Required**
- **Login only after verification**
- **Password Reset via email**
- **Secure Logout**

### 🏠 Home Page
- Quick access to:
  - Buy or Sell E-Waste
  - Donate E-Waste
  - Schedule Pickup
  - Find Recycling Centers
- View Map to explore recycling centers
- View all uploaded products

### 🛠️ Services
- Explore different environmental services
- Service details with descriptions
- **Supports multiple payment options**:
  - Card
  - Bank Transfer
  - Mobile Money

### 🛍️ Marketplace
- Browse products by category (e.g., E-Waste, Clothing)
- Upload products (For Sale or For Charity)
- Firebase storage support for product images
- Product listing includes:
  - Title, category, image, and description
- Delete products from details page

### 👤 Profile
- Display Wallet balance with **toggle visibility**
- **Withdraw balance** with confirmation and success page
- Withdrawal history
- **Manage Account**:
  - Edit username, email, DOB, gender, etc.
- Change password
- Toggle biometric login: Face ID or Touch ID
- Logout button triggers sign out from Firebase
- Navigation issues fixed:
  - "Go Back" always returns to Profile page with bottom nav visible

### 📝 Reviews
- Filter reviews:
  - Newest
  - Oldest
  - Reviewer Name
- Add new review:
  - Rate with stars
  - Upload image
  - Submit text
- Edit existing reviews (text, image, rating)
- Delete reviews

---
## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## 🧱 Tech Stack

| Category       | Tech                                               |
|----------------|----------------------------------------------------|
| UI Framework   | [Flutter](https://flutter.dev/)                   |
| Backend        | [Firebase Auth, Firestore, Firebase Storage]       |
| State Mgmt     | [Flutter Bloc](https://pub.dev/packages/flutter_bloc) |
| Testing        | [flutter_test, bloc_test, mockito]                |
| Maps           | [Google Maps API] (optional, if used)              |
| Storage        | Firebase Storage                                   |
| Navigation     | BottomNavigationBar + Named Routes                 |

---

## 🧪 Testing

- Bloc unit tests implemented using `bloc_test` & `mockito`
- Tests for:
  - Authentication BLoC
  - Error scenarios (email not verified, login failure)
  - Registration, password reset, logout
- Widget test included (Counter smoke test)

Run tests:

```bash
flutter test
```

---

## 📂 Project Structure (Key Folders)

```
lib/
├── blocs/
│   ├── auth/
│   ├── market/
│   ├── profile/
│   ├── services/
│   └── reviews/
├── presentation/
│   ├── screens/
│   ├── widgets/
│   └── theme/
├── main.dart
├── firebase_options.dart
test/
```

---

## ✅ Navigation Flow

```text
[Splash Screen]
    ↓
[Onboarding Screen]
    ↓
[Register → Verify Email]
    ↓
[Login → Home Page (MainScreen)]
    ↓
[Use Bottom Tabs to Navigate Between]:
    - Home
    - Services
    - Market
    - Profile
    - Reviews
```

✅ Bottom nav state persists and navigates properly across pages  
✅ Reused pages (like Profile) adapt their layout based on where they are called from  
✅ Back navigation issues resolved for success pages

---

## 🔒 Secure Auth Rules

```js
// Firestore rules snippet
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    match /reviews/{reviewId} {
      allow read: if true;
      allow write: if request.auth.uid != null;
    }
    match /products/{productId} {
      allow read: if true;
      allow write: if request.auth.uid != null;
    }
  }
}
```

## 💬 Commit Message Example

```
feat: complete end-to-end app flow from Auth → Reviews

- Implemented auth flow with verification
- Added bottom navigation and tab management
- Integrated Firebase Firestore and Storage for uploads
- Fixed withdrawal navigation and persistent profile UI
- Implemented review posting with image upload and edit/delete
- Improved test coverage for AuthBloc
```

---

## Test results

<img width="812" alt="image" src="https://github.com/user-attachments/assets/4d52083a-7627-447f-ba72-042db07e6bc9" />


## 👥 Team Members (Group 10)

- **Lydia Ojoawo** ([@lydia02](https://github.com/lydia02))
- **Simeon Azeh** ([@Simeon-Azeh](https://github.com/Simeon-Azeh))
- **Omar Keita** ([@O-keita](https://github.com/O-keita))
- **Afsa Umutoniwase** ([@Afsaumutoniwase](https://github.com/Afsaumutoniwase))
- **Nickitta Asimwe** ([@nasimwe](https://github.com/nasimwe))

---
