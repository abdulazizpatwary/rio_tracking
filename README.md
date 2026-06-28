# Rio Tracking – Live Multi-Vehicle GPS Tracking System

## Project Overview

Rio Tracking is a Flutter-based mobile application developed as an assessment project for Rio Deep Technologies.

The application demonstrates a live multi-vehicle GPS tracking system where users can view vehicles on a live map and drivers can manage their own vehicle information and tracking status.

The system supports multiple vehicle types and provides real-time or simulated tracking functionality.

---

## Platform Type

Mobile App-Based Platform

Framework:

* Flutter
* Dart

---

## Tools, Technologies, APIs and Libraries Used

### Frontend

* Flutter
* Dart

### State Management

* flutter_bloc

### Database

* Firebase Firestore

### Location Service

* Geolocator

### Map Service

* Mapbox Maps Flutter SDK

### Architecture

* Feature-Based Architecture
* Repository Pattern
* Bloc Pattern

---

## Project Structure

```text
lib/

app/
├── app.dart
└── app_assets.dart

core/
├── config/
├── extensions/
└── services/

features/

├── auth/
│   ├── data/
│   ├── domain/
│   └── view/
│
├── vehicle/
│   ├── data/
│   ├── domain/
│   ├── view/
│   └── bloc/
│
├── tracking/
│   ├── data/
│   ├── domain/
│   └── bloc/
│
├── map/
│   ├── view/
│   └── widgets/
│
├── driver/
│   ├── bloc/
│   └── view/
│
└── home/
    ├── bloc/
    └── view/
```

---

## User Interface Explanation

The User Interface allows users to:

* View vehicles on a live map
* View multiple vehicle types
* View vehicle location
* Access vehicle information
* View connected driver information
* Monitor live vehicle movement
* View speed and distance data

Users can tap on a vehicle marker to view details.

Vehicle information includes:

* Vehicle name
* Vehicle type
* Driver information
* Speed
* Distance
* Status
* Last update time

---

## Driver Interface Explanation

The Driver Interface allows drivers to:

* Register as a driver
* Add vehicle information
* Update vehicle information
* Delete vehicle information
* Select vehicle type
* View their own vehicle
* Start tracking
* Stop tracking
* View live vehicle movement

Each driver can access only their own vehicle.

---

## Vehicle and Driver Connection

Each driver has a unique driver ID.

When a driver registers a vehicle:

* Vehicle data is linked with driverId
* Vehicle information is stored in Firebase
* User Interface shows the relationship between the vehicle and driver

This creates a clear connection between drivers and their registered vehicles.

---

## Live Tracking Explanation

The application uses Geolocator and Mapbox to provide live GPS tracking.

Tracking flow:

Location Stream

↓

Tracking Repository

↓

Tracking Bloc

↓

Tracking State

↓

Map Screen

The tracking process:

1. GPS location updates are received
2. Repository processes location data
3. Bloc updates application state
4. Map refreshes vehicle locations
5. Vehicle markers move on the map

---

##  Functionality

Current supports:

 User Interface access

 Driver Interface access

 Driver registration

 Vehicle registration

 Vehicle update

 Vehicle deletion

 Vehicle type selection

 Driver-vehicle relationship

 Multiple vehicle display

 Live GPS tracking

 Vehicle information display

 Start tracking

 Stop tracking

 Firebase integration

 Mapbox integration

---

## Setup Instructions

### Step 1: Clone Repository

```bash
git clone https://github.com/abdulazizpatwary/rio_tracking
```

### Step 2: Install Dependencies

```bash
flutter pub get
```

### Step 3: Configure Firebase

* Create Firebase project
* Add google-services.json
* Enable Cloud Firestore

### Step 4: Configure Mapbox

Add your Mapbox access token

### Step 5: Run Application

```bash
flutter run
```

---

## How to Run Project

1. Open project in Android Studio or VS Code

2. Connect emulator/device

3. Run:

```bash
flutter run
```

4. Home screen opens

5. Select:

* User Interface
* Driver Interface

6. Test tracking functionality

---

## Demo

No hosted demo currently available.

Application can be tested locally.

---

## Developer

Abdul Aziz Patwary

Flutter Developer
