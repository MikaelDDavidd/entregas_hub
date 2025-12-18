<div align="center">

# Entregas Hub API

[![Node.js](https://img.shields.io/badge/Node.js-v14+-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)](https://nodejs.org/)
[![Express](https://img.shields.io/badge/Express-4.21-000000?style=for-the-badge&logo=express&logoColor=white)](https://expressjs.com/)
[![MongoDB](https://img.shields.io/badge/MongoDB-6.11-47A248?style=for-the-badge&logo=mongodb&logoColor=white)](https://www.mongodb.com/)
[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![License](https://img.shields.io/badge/License-AGPL--3.0-blue?style=for-the-badge)](LICENSE)

**RESTful API for logistics and delivery management system**

[Getting Started](#getting-started) •
[API Reference](#api-reference) •
[Docker](#docker-deployment) •
[Contributing](#contributing)

---

</div>

## Overview

Entregas Hub API is a robust backend service built with Node.js and Express that powers a complete logistics management ecosystem. It handles delivery operations, image processing with AI-powered text extraction, and seamless integration with mobile and web applications.

### Key Features

| Feature | Description |
|---------|-------------|
| **Delivery Management** | Full CRUD operations for delivery records |
| **Image Processing** | Upload and automatic text extraction via Google Gemini AI |
| **Multi-platform** | Supports mobile apps (Flutter) and web panel |
| **Containerized** | Docker-ready with MongoDB for easy deployment |
| **Real-time Filtering** | Filter deliveries by delivery person |

---

## Tech Stack

<table>
<tr>
<td align="center" width="96">
<img src="https://skillicons.dev/icons?i=nodejs" width="48" height="48" alt="Node.js" />
<br>Node.js
</td>
<td align="center" width="96">
<img src="https://skillicons.dev/icons?i=express" width="48" height="48" alt="Express" />
<br>Express
</td>
<td align="center" width="96">
<img src="https://skillicons.dev/icons?i=mongodb" width="48" height="48" alt="MongoDB" />
<br>MongoDB
</td>
<td align="center" width="96">
<img src="https://skillicons.dev/icons?i=docker" width="48" height="48" alt="Docker" />
<br>Docker
</td>
<td align="center" width="96">
<img src="https://www.gstatic.com/lamda/images/gemini_sparkle_v002_d4735304ff6292a690345.svg" width="48" height="48" alt="Gemini" />
<br>Gemini AI
</td>
</tr>
</table>

### Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `express` | ^4.21.1 | Web framework |
| `mongodb` | ^6.11.0 | Database driver |
| `multer` | ^1.4.5-lts.1 | File upload handling |
| `@google/generative-ai` | ^0.21.0 | AI text extraction |
| `cors` | ^2.8.5 | Cross-origin support |
| `dotenv` | ^16.4.5 | Environment configuration |
| `body-parser` | ^1.20.3 | Request parsing |
| `firebase-admin` | ^13.0.1 | Firebase integration |

---

## Project Structure

```
entregas_hub_back_end/
├── src/
│   ├── config/
│   │   └── db_config.js          # MongoDB connection
│   ├── controller/
│   │   └── deliveries_controller.js   # Request handlers
│   ├── models/
│   │   └── deliveries_model.js   # Database operations
│   ├── routes/
│   │   └── deliveries_routes.js  # API routes
│   └── services/
│       └── gemini_service.js     # AI integration
├── uploads/                       # Image storage
├── .env                          # Environment variables
├── Dockerfile                    # Production container
├── Dockerfile.dev                # Development container
├── docker-compose.yml            # Container orchestration
├── package.json
└── server.js                     # Entry point
```

---

## Getting Started

### Prerequisites

- ![Node.js](https://img.shields.io/badge/Node.js-≥14.0.0-339933?style=flat-square&logo=nodedotjs&logoColor=white)
- ![npm](https://img.shields.io/badge/npm-≥6.0.0-CB3837?style=flat-square&logo=npm&logoColor=white)
- ![MongoDB](https://img.shields.io/badge/MongoDB-7.0-47A248?style=flat-square&logo=mongodb&logoColor=white) (local or Atlas)

### Installation

1. **Clone the repository**

```bash
git clone https://github.com/mikaeldavid/entregas_hub_back_end.git
cd entregas_hub_back_end
```

2. **Install dependencies**

```bash
npm install
```

3. **Configure environment variables**

Create a `.env` file in the root directory:

```env
STRING_CONEXAO=mongodb://localhost:27017/delivery-hub
GEMINI_API_KEY=your_gemini_api_key
BASE_URL=http://localhost:3000
NODE_ENV=development
```

4. **Start the server**

```bash
# Development mode with auto-reload
npm run dev

# Production mode
node server.js
```

The server will start at `http://localhost:3000`

---

## API Reference

### Base URL

```
http://localhost:3000/api
```

### Endpoints

#### Deliveries

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/packages` | List all deliveries |
| `GET` | `/packages?deliveryMan={name}` | Filter by delivery person |
| `POST` | `/packages` | Create new delivery |
| `DELETE` | `/packages/:id` | Delete delivery |
| `DELETE` | `/packages/deliveryman/:name` | Delete all by delivery person |

#### Images

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/upload` | Upload image |
| `PUT` | `/upload/:id` | Update delivery with image + AI extraction |

#### Statistics

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/deliverymen` | List delivery people with stats |

---

### Request & Response Examples

#### Create Delivery

```bash
POST /api/packages
Content-Type: application/json
```

**Request Body:**
```json
{
  "trackingCode": "BR123456789",
  "ownerName": "John Doe",
  "cpf": "123.456.789-00",
  "relation": "Owner",
  "location": "Block A - Apt 101",
  "deliveryMan": "mikael",
  "registerDate": "2025-12-18",
  "imageUrl": "http://example.com/image.png"
}
```

**Response:**
```json
{
  "status": 200,
  "data": {
    "_id": "507f1f77bcf86cd799439011",
    "trackingCode": "BR123456789",
    "ownerName": "John Doe",
    "createdAt": "2025-12-18T10:30:00.000Z",
    "updatedAt": "2025-12-18T10:30:00.000Z"
  }
}
```

#### Upload Image

```bash
POST /api/upload
Content-Type: multipart/form-data
```

**Form Data:**
- `image`: File (PNG, JPG, etc.)

**Response:**
```json
{
  "url": "http://localhost:3000/uploads/9f8d7c6a2b1d4e5f.png"
}
```

#### List Delivery People

```bash
GET /api/deliverymen
```

**Response:**
```json
{
  "status": 200,
  "data": [
    {
      "name": "mikael",
      "count": 15,
      "lastDelivery": "2025-12-18T14:30:00.000Z"
    }
  ]
}
```

---

## Docker Deployment

### Quick Start

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f backend

# Stop services
docker-compose down
```

### Services

| Service | Port | Description |
|---------|------|-------------|
| `backend` | 3000 | Node.js API |
| `mongodb` | 27017 | MongoDB database |

### Docker Compose Configuration

```yaml
version: '3.8'

services:
  mongodb:
    image: mongo:7
    ports:
      - "27017:27017"
    environment:
      MONGO_INITDB_ROOT_USERNAME: admin
      MONGO_INITDB_ROOT_PASSWORD: admin123
    volumes:
      - mongodb_data:/data/db

  backend:
    build: .
    ports:
      - "3000:3000"
    depends_on:
      - mongodb
    environment:
      - STRING_CONEXAO=mongodb://admin:admin123@mongodb:27017/delivery-hub?authSource=admin
      - GEMINI_API_KEY=${GEMINI_API_KEY}
    volumes:
      - ./uploads:/app/uploads
    restart: unless-stopped

volumes:
  mongodb_data:
```

### Development with Debugging

```bash
# Start with debug mode
docker-compose -f docker-compose.debug.yml up -d
```

Debug port: `9229` (Node Inspector)

---

## Environment Variables

| Variable | Required | Description | Example |
|----------|----------|-------------|---------|
| `STRING_CONEXAO` | Yes | MongoDB connection string | `mongodb://localhost:27017/delivery-hub` |
| `GEMINI_API_KEY` | Yes | Google Generative AI key | `AIzaSy...` |
| `BASE_URL` | No | Base URL for image URLs | `http://localhost:3000` |
| `NODE_ENV` | No | Environment mode | `development` or `production` |

---

## Database Schema

### Delivery Document

```javascript
{
  _id: ObjectId,
  trackingCode: String,
  ownerName: String,
  cpf: String,
  relation: String,
  location: String,
  deliveryMan: String,
  registerDate: String,
  imageUrl: String,
  imgUrl: String,
  destination: String,      // AI-extracted
  createdAt: Date,          // Auto-generated
  updatedAt: Date           // Auto-updated
}
```

---

## AI Integration

The API uses **Google Gemini 1.5 Flash** to automatically extract recipient names from delivery package images.

### How it Works

1. Image uploaded via `POST /api/upload`
2. On `PUT /api/upload/:id`, image is processed by Gemini AI
3. AI extracts recipient name from package label
4. Delivery record updated with extracted `destination` field

### Configuration

Obtain your API key from [Google AI Studio](https://makersuite.google.com/app/apikey) and add it to your `.env` file.

---

## Related Projects

This API is part of the **Entregas Hub** ecosystem:

| Project | Description | Tech |
|---------|-------------|------|
| [entrega_hub](../entrega_hub) | Mobile app for delivery drivers | Flutter |
| [logistics_app](../logistics_app) | Pickup management app | Flutter |
| [eaasy_stock](../eaasy_stock) | Warehouse scanning app | Flutter |
| [entregas_hub_web_panel](../entregas_hub_web_panel) | Web monitoring dashboard | Flutter Web |

---

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style

- Use ES Modules (`import/export`)
- Follow MVC pattern
- Add error handling to all endpoints
- Document new endpoints in this README

---

## License

This project is licensed under the **GNU Affero General Public License v3.0** - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

**[Back to Top](#entregas-hub-api)**

[![GitHub](https://img.shields.io/badge/GitHub-Repository-181717?style=flat-square&logo=github)](https://github.com/mikaeldavid/entregas_hub_back_end)

</div>
