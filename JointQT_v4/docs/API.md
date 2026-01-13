# Backend API Definition

Base URL: `http://localhost:8080/api/v1`

## 1. Images

### 1.1 List Images

Fetch a list of images with optional filtering and searching.

- **URL**: `/images`
- **Method**: `GET`
- **Query Parameters**:

  - `page` (int, default: 1): Page number.
  - `limit` (int, default: 50): Items per page.
  - `sort` (string, optional): Sort field (e.g., `uploaded_at`, `rating`, `filename`).
  - `order` (string, default: `desc`): `asc` or `desc`.
  - `tags` (string, optional): Comma-separated list of tags to filter by (e.g., `landscape,nature`).
  - `rating_min` (int, optional): Minimum rating (0-5).
  - `rating_max` (int, optional): Maximum rating.
  - `search` (string, optional): Text search query (filename, description).

- **Response (200 OK)**:
  ```json
  {
    "data": [
      {
        "id": 101,
        "filename": "sunset.jpg",
        "url": "http://localhost:8080/uploads/sunset.jpg",
        "thumbnail_url": "http://localhost:8080/uploads/thumb_sunset.jpg",
        "width": 1920,
        "height": 1080,
        "size": 204800,
        "uploaded_at": "2023-10-27T10:00:00Z",
        "rating": 4.5,
        "tags": ["landscape", "sun"],
        "description": "A beautiful sunset."
      }
    ],
    "meta": {
      "current_page": 1,
      "last_page": 10,
      "total": 450
    }
  }
  ```

### 1.2 Get Image Details

- **URL**: `/images/{id}`
- **Method**: `GET`
- **Response (200 OK)**:
  ```json
  {
    "id": 101,
    "filename": "sunset.jpg",
    "url": "http://localhost:8080/uploads/sunset.jpg",
    "width": 1920,
    "height": 1080,
    "uploaded_at": "2023-10-27T10:00:00Z",
    "rating": 5,
    "tags": ["nature", "red"],
    "description": "Detailed description here."
  }
  ```

### 1.3 Upload Image

- **URL**: `/images`
- **Method**: `POST`
- **Content-Type**: `multipart/form-data`
- **Body**:
  - `file`: (Binary) The image file.
  - `title`: (String, optional)
  - `tags`: (String, optional) Comma separated.
  - `description`: (String, optional)
- **Response (201 Created)**:
  ```json
  {
    "id": 102,
    "message": "Image uploaded successfully."
  }
  ```

### 1.4 Update Image

- **URL**: `/images/{id}`
- **Method**: `PUT`
- **Content-Type**: `application/json`
- **Body**:
  ```json
  {
    "rating": 4,
    "tags": ["new_tag"],
    "description": "Updated description"
  }
  ```
- **Response (200 OK)**:
  ```json
  { "success": true }
  ```

### 1.5 Delete Image

- **URL**: `/images/{id}`
- **Method**: `DELETE`
- **Response (200 OK)**:
  ```json
  { "success": true }
  ```

## 2. Search

### 2.1 Search by Image (Reverse Image Search)

- **URL**: `/search/image`
- **Method**: `POST`
- **Content-Type**: `multipart/form-data`
- **Body**:
  - `file`: (Binary) The image to search for.
- **Response (200 OK)**:
  ```json
  {
    "results": [
      {
        "image_id": 55,
        "similarity": 0.95,
        "thumbnail_url": "..."
      },
      {
        "image_id": 89,
        "similarity": 0.88,
        "thumbnail_url": "..."
      }
    ]
  }
  ```

## 3. General

### 3.1 Get Tags and Stats

- **URL**: `/stats`
- **Method**: `GET`
- **Response (200 OK)**:
  ```json
  {
    "total_images": 1250,
    "popular_tags": [
      { "name": "portrait", "count": 150 },
      { "name": "landscape", "count": 120 }
    ],
    "rating_distribution": {
      "5": 100,
      "4": 300
    }
  }
  ```
