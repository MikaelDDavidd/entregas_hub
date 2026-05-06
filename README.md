<div align="center">

# Entregas Hub

**End-to-end logistics platform for last-mile delivery operations.**

A complete kit covering parcel intake, courier dispatch, customer pickup and warehouse stock — three native mobile apps, one real-time web panel and a Node.js API, all integrated.

[![Flutter](https://img.shields.io/badge/Flutter-3.38-02569B?logo=flutter)](https://flutter.dev)
[![Node.js](https://img.shields.io/badge/Node.js-14%2B-339933?logo=node.js&logoColor=white)](https://nodejs.org)
[![Express](https://img.shields.io/badge/Express-4.21-000000?logo=express&logoColor=white)](https://expressjs.com)
[![MongoDB](https://img.shields.io/badge/MongoDB-Atlas-47A248?logo=mongodb&logoColor=white)](https://www.mongodb.com/atlas)
[![Firebase](https://img.shields.io/badge/Firebase-RTDB-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com/products/realtime-database)
[![GetX](https://img.shields.io/badge/GetX-state%20mgmt-purple)](https://pub.dev/packages/get)
[![License](https://img.shields.io/badge/License-AGPL--3.0-blue.svg)](#license)
[![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android%20%7C%20Web-lightgrey)]()

</div>

---

## Overview

Entregas Hub is a five-component logistics suite built for small and mid-size delivery operations. Couriers capture parcels in the field, customers register pickups, warehouse staff scan inventory in real time, and operations track every step from a single web panel.

The system was designed to keep moving even when the network is unreliable: mobile apps cache locally with Hive and SharedPreferences, the API runs on a lean Express stack, and stock data syncs through Firebase Realtime Database for sub-second updates on the warehouse floor.

A Google Gemini integration on the backend automatically extracts recipient names from package label photos, removing manual data entry from the courier flow.

### Key Features

- **Field capture by couriers** — photo-based parcel intake, recipient details, GPS-aware delivery confirmation
- **Customer pickup flow** — dedicated app showing parcel location inside the warehouse for fast retrieval
- **Real-time warehouse stock** — barcode scanning synced through Firebase Realtime Database
- **Live operations panel** — Flutter Web dashboard for monitoring deliveries, pickups and stock as they happen
- **AI-assisted data entry** — Google Gemini extracts recipient names from label photos via `PUT /api/upload/:id`
- **Offline-first mobile** — Hive cache (entrega_hub) and SharedPreferences keep the app usable without connectivity
- **Image pipeline** — Multer-backed upload with random filenames, served as static assets from the API

## Architecture

```
                ┌────────────────────────────────────────┐
                │       entregas_hub_web_panel           │
                │       (Flutter Web — live ops)         │
                └────────────┬──────────────┬────────────┘
                             │              │
                  REST/JSON  │              │ Firebase RTDB
                             │              │
        ┌────────────────────┴──────┐   ┌───┴──────────────┐
        │   entregas_hub_back_end   │   │  Firebase RTDB   │
        │   Node.js + Express +    │   │  (stock state)   │
        │   MongoDB Atlas + Gemini  │   └───────┬──────────┘
        └────┬─────────────┬────────┘           │
             │             │                    │
   POST /api │             │ POST /api          │
   /packages │             │ /packages          │
             │             │                    │
        ┌────┴────┐   ┌────┴────────┐    ┌──────┴───────┐
        │ entrega │   │ logistics_  │    │ eaasy_stock  │
        │  _hub   │   │    app      │    │              │
        │(courier)│   │ (pickups)   │    │ (warehouse)  │
        └─────────┘   └─────────────┘    └──────────────┘
              Flutter mobile (iOS / Android)
```

### Process Flows

1. **Delivery** — Courier opens **entrega_hub**, captures the package label and recipient data; the app posts to the API, which persists it in MongoDB and exposes it on the web panel.
2. **Pickup** — Customer or operator uses **logistics_app** to register a pickup; the app surfaces the warehouse location, and the API updates status across the panel.
3. **Stock** — Warehouse staff scan parcels with **eaasy_stock**; updates flow through Firebase Realtime Database and reflect instantly in the web panel's stock view.

## Components

| Module | Type | Purpose | Stack |
|---|---|---|---|
| [`entrega_hub`](./entrega_hub) | Mobile (iOS/Android) | Courier app — capture, recipient data, sync | Flutter, GetX, Hive, dio |
| [`logistics_app`](./logistics_app) | Mobile (iOS/Android) | Customer pickup flow with warehouse location | Flutter, GetX, SharedPreferences |
| [`eaasy_stock`](./eaasy_stock) | Mobile (iOS/Android) | Warehouse barcode scanning + stock control | Flutter, GetX, Firebase RTDB |
| [`entregas_hub_web_panel`](./entregas_hub_web_panel) | Web | Real-time ops dashboard (deliveries, pickups, stock) | Flutter Web, GetX |
| [`entregas_hub_back_end`](./entregas_hub_back_end) | Backend API | REST API, image uploads, AI extraction | Node.js, Express, MongoDB, Gemini |

## Tech Stack

- **Mobile & Web**: Flutter 3.38+ with **GetX** for state management, routing and DI
- **Backend**: Node.js 14+ / Express 4.21
- **Databases**:
  - **MongoDB Atlas** — deliveries and pickups (via `mongodb` driver)
  - **Firebase Realtime Database** — live stock state (eaasy_stock + web panel)
- **Image storage**: Multer disk storage on the API host, served as static files
- **AI**: Google Generative AI (Gemini) for label OCR / recipient extraction
- **Local persistence**: Hive (entrega_hub), SharedPreferences (logistics_app, eaasy_stock)
- **Networking**: `dio` and `http` Dart clients

## API Reference

Base URL: `http://<host>:3000`

| Method | Endpoint | Purpose |
|---|---|---|
| `GET`    | `/api/packages` | List deliveries |
| `POST`   | `/api/packages` | Create a new delivery |
| `POST`   | `/api/upload` | Upload a package image (multipart/form-data, field `image`) |
| `PUT`    | `/api/upload/:id` | Update a delivery; runs Gemini extraction on the attached image |
| `DELETE` | `/api/packages/:id` | Delete a single package |
| `DELETE` | `/api/packages/deliveryman/:deliveryMan` | Bulk-delete a courier's packages |
| `GET`    | `/api/deliverymen` | List active couriers |
| `GET`    | `/uploads/:filename` | Static-served package images |

CORS is open (`origin: *`) by default — restrict in `src/routes/deliveries_routes.js` before production deployment.

## Getting Started

### Prerequisites

- **Flutter** 3.38+ ([install](https://docs.flutter.dev/get-started/install)) — Dart SDK 3.4+
- **Node.js** 14+ and npm 6+
- **MongoDB Atlas** cluster (or local MongoDB) and connection string
- **Google Generative AI API key** (Gemini) for label extraction
- **Firebase project** with Realtime Database enabled (only needed for `eaasy_stock` and the web panel's stock view)

### 1. Backend API

```bash
cd entregas_hub_back_end
npm install

# Create .env with:
#   MONGODB_URI=...
#   GEMINI_API_KEY=...

npm run dev          # development with auto-reload
# or
node server.js       # production
```

The API listens on port `3000` and auto-creates the `uploads/` directory on first run.

### 2. Mobile apps

For each of `entrega_hub`, `logistics_app`, `eaasy_stock`:

```bash
cd <app_folder>
flutter pub get

# entrega_hub also needs Hive type adapters generated:
flutter pub run build_runner build --delete-conflicting-outputs

flutter run
```

Update the API base URL inside each app's `lib/app/data/` service file to point at your backend.

### 3. Web panel

```bash
cd entregas_hub_web_panel
flutter pub get
flutter run -d chrome        # local dev
flutter build web            # production build → build/web/
```

The output of `flutter build web` is a static bundle deployable to any static host (Nginx, Vercel, S3, Firebase Hosting).

### 4. Firebase setup (eaasy_stock + panel stock view)

1. Create a Firebase project and enable **Realtime Database**.
2. Add Android/iOS apps and drop `google-services.json` / `GoogleService-Info.plist` into the standard locations under `eaasy_stock/`.
3. Configure web credentials inside `entregas_hub_web_panel` for the stock-view subscription.

## Project Structure

```
entregas_hub/
├── entrega_hub/              # Courier mobile app (Flutter + GetX + Hive)
├── logistics_app/            # Pickup mobile app (Flutter + GetX)
├── eaasy_stock/              # Warehouse scanner (Flutter + Firebase RTDB)
├── entregas_hub_web_panel/   # Real-time ops dashboard (Flutter Web)
└── entregas_hub_back_end/    # REST API
    └── src/
        ├── config/           # MongoDB connection
        ├── models/           # Data access (deliveries_model.js)
        ├── controller/       # Request handlers
        ├── routes/           # Express routes + CORS + Multer
        └── services/         # Gemini AI integration
```

Each Flutter app follows the standard GetX layout:

```
lib/app/
├── data/         # API services and clients
├── models/       # Data models
├── modules/<feature>/
│   ├── bindings/    # DI
│   ├── controllers/ # Business logic (extends GetxController)
│   ├── views/       # Screens
│   └── widgets/     # Feature-specific widgets
└── routes/       # Navigation config
```

## Screenshots

Each module ships its own screenshots in its `screenshots/` folder:

- Courier app — [`entrega_hub/screenshots/`](./entrega_hub/screenshots)
- Warehouse scanner — [`eaasy_stock/screenshots/`](./eaasy_stock/screenshots)
- Web panel — [`entregas_hub_web_panel/screenshots/`](./entregas_hub_web_panel/screenshots)

## Module Documentation

Each component has its own README with deeper details:

- [Entregas Hub (courier app)](./entrega_hub/README.md)
- [Logistics App (pickup)](./logistics_app/README.md)
- [Eaasy Stock (warehouse)](./eaasy_stock/README.md)
- [Web Panel](./entregas_hub_web_panel/README.md)
- [Backend API](./entregas_hub_back_end/README.md)

## Deployment Notes

- iOS 12.0+ and the Android SDK levels Flutter 3.38 currently targets.
- Backend needs a writable working directory for `uploads/` (or an attached volume in container deploys).
- Public image URLs are served directly from the API host — front it with a CDN if traffic grows.
- Tighten the wildcard CORS policy before exposing the API to production traffic.

## License

Backend distributed under **AGPL-3.0** (see `entregas_hub_back_end/package.json`). Mobile and web modules currently have no explicit license — treat as **all rights reserved** unless a `LICENSE` file is added.

---

<div align="center">
Built by <a href="https://github.com/MikaelDDavidd">Mikael David</a>
</div>
