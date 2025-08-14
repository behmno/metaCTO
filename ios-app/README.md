# MetaCTO iOS App

A native iOS application built with UIKit that provides the same features as the web frontend for the MetaCTO Feature Voting System.

## Features

- **User Authentication**: Login and registration with JWT token management
- **Features List**: Browse features with pagination and pull-to-refresh
- **Feature Details**: View detailed information about individual features
- **Create Features**: Propose new features with title and description
- **Voting System**: Vote on features with error handling for duplicate votes
- **Responsive UI**: Native iOS design with proper navigation and loading states

## Architecture

The app follows the MVC pattern with proper separation of concerns:

- **Models**: Data structures matching the API responses
- **Services**: API communication and authentication management
- **View Controllers**: UI logic and user interaction handling

### Key Components

- **AuthService**: Manages authentication state and token storage
- **APIService**: Handles all API communications with the backend
- **Custom UI Components**: Custom table view cells and reusable UI elements

## API Integration

The app communicates with the same FastAPI backend at `http://localhost:8000`:

- Authentication endpoints (`/auth/login`, `/auth/register`)
- Features endpoints (`/features/`, `/features/{id}`)
- Voting endpoint (`/votes/`)

## Setup Instructions

1. **Prerequisites**:
   - Xcode 15.0 or later
   - iOS 17.0+ target device/simulator
   - Running backend server at localhost:8000

2. **Project Setup**:
   - Open `MetaCTO.xcodeproj` in Xcode
   - Build and run the project
   - Ensure the backend server is running for API calls

3. **Configuration**:
   - The app is configured to allow arbitrary HTTP loads for local development
   - API base URL is set to `http://localhost:8000`

## User Flow

1. **Launch**: App checks for existing authentication
2. **Authentication**: Login or register if not authenticated
3. **Features List**: Browse and vote on features
4. **Feature Details**: View detailed feature information
5. **Create Feature**: Propose new features
6. **Logout**: Clear authentication and return to login

## Features Implemented

✅ User registration and login
✅ JWT token management
✅ Features list with pagination
✅ Feature detail view
✅ Create new features
✅ Voting functionality
✅ Error handling and loading states
✅ Pull-to-refresh
✅ Empty states
✅ Responsive navigation

## Technical Highlights

- **Programmatic UI**: All UI built programmatically with Auto Layout
- **Networking**: URLSession-based API service with proper error handling
- **Data Persistence**: UserDefaults for authentication state
- **Pagination**: Infinite scroll implementation
- **Error Handling**: User-friendly error messages and retry mechanisms
- **Loading States**: Activity indicators and disabled states during operations

## File Structure

```
MetaCTO/
├── Services/
│   ├── APIService.swift      # API communication
│   └── AuthService.swift     # Authentication management
├── Models/
│   └── Models.swift          # Data models
├── ViewControllers/
│   ├── LoginViewController.swift
│   ├── RegisterViewController.swift
│   ├── FeaturesViewController.swift
│   ├── FeatureDetailViewController.swift
│   └── CreateFeatureViewController.swift
├── AppDelegate.swift
├── SceneDelegate.swift
├── ViewController.swift
└── Info.plist
```

The iOS app provides a native mobile experience with all the functionality of the web frontend, optimized for iOS users.