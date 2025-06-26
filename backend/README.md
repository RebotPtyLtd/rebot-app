# WireMock CRUD API Setup Guide

This guide will help you set up a complete test API using WireMock for your CRUD web application with the following structure:

## Data Structure

### Roles & Permissions
- **Admin**: Can create offices, manage all users, delete offices
- **OfficeAdmin**: Can manage office settings, add users to their office
- **User**: Can create items, add comments

### Data Hierarchy
```
Offices (5 total)
├── Users (3-5 per office)
├── Items (20-50 per office)
    └── Comments (5-17 per item)
```

## Quick Start

### 1. Install WireMock

**Option A: Download JAR**
```bash
wget https://repo1.maven.org/maven2/com/github/tomakehurst/wiremock-jre8-standalone/2.35.0/wiremock-jre8-standalone-2.35.0.jar
```

**Option B: Using Docker**
```bash
docker pull wiremock/wiremock:latest
```

### 2. Generate Test Data

Run the data generator script:
```bash
node data-generator.js
```

This creates a `wiremock-mappings.json` file with all the test data and API endpoints.

### 3. Start WireMock Server

**Using JAR:**
```bash
java -jar wiremock-jre8-standalone-2.35.0.jar --port 8080 --verbose
```

**Using Docker:**
```bash
docker run -it --rm -p 8080:8080 -v $(pwd):/home/wiremock wiremock/wiremock:latest --verbose
```

### 4. Load API Mappings

```bash
curl -X POST http://localhost:8080/__admin/mappings/import \
  -H "Content-Type: application/json" \
  -d @wiremock-mappings.json
```

## API Endpoints

### Offices
- `GET /api/offices` - List all offices
- `GET /api/offices/{id}` - Get specific office
- `POST /api/offices` - Create office (Admin only)
- `PUT /api/offices/{id}` - Update office (Admin only)
- `DELETE /api/offices/{id}` - Delete office (Admin only)
- `PATCH /api/offices/{id}/settings` - Update office settings (OfficeAdmin only)

### Users
- `GET /api/users` - List all users
- `GET /api/offices/{id}/users` - Get users for specific office
- `POST /api/users` - Create user (Admin/OfficeAdmin only)

### Items
- `GET /api/offices/{id}/items` - Get items for specific office
- `GET /api/items/{id}` - Get specific item
- `POST /api/items` - Create item
- `PUT /api/items/{id}` - Update item
- `DELETE /api/items/{id}` - Delete item

### Comments
- `GET /api/items/{id}/comments` - Get comments for specific item
- `POST /api/comments` - Create comment
- `PUT /api/comments/{id}` - Update comment
- `DELETE /api/comments/{id}` - Delete comment

### Authentication
- `GET /api/auth/me` - Get current user info

## Sample API Calls

### Test the API
```bash
# Get all offices
curl http://localhost:8080/api/offices

# Get users for office 1
curl http://localhost:8080/api/offices/1/users

# Get items for office 1
curl http://localhost:8080/api/offices/1/items

# Get comments for item 1
curl http://localhost:8080/api/items/1/comments

# Create a new office (requires auth header)
curl -X POST http://localhost:8080/api/offices \
  -H "Authorization: Bearer your-token" \
  -H "Content-Type: application/json" \
  -d '{"name": "New Office", "address": "123 New St"}'

# Create a new user
curl -X POST http://localhost:8080/api/users \
  -H "Authorization: Bearer your-token" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "newuser",
    "email": "newuser@company.com",
    "role": "User",
    "officeId": 1,
    "firstName": "New",
    "lastName": "User"
  }'

# Create a new item
curl -X POST http://localhost:8080/api/items \
  -H "Authorization: Bearer your-token" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "New Task",
    "description": "This is a new task",
    "officeId": 1,
    "createdBy": 1
  }'

# Add a comment to an item
curl -X POST http://localhost:8080/api/comments \
  -H "Authorization: Bearer your-token" \
  -H "Content-Type: application/json" \
  -d '{
    "itemId": 1,
    "userId": 1,
    "content": "This is a test comment"
  }'
```

## Sample Test Data

### Office Structure
```json
{
  "id": 1,
  "name": "Downtown Branch",
  "address": "123 Main St, Downtown",
  "settings": {
    "allowPublicComments": false,
    "maxItemsPerUser": 100,
    "timezone": "America/New_York"
  },
  "adminId": 1
}
```

### User Structure
```json
{
  "id": 1,
  "username": "admin_office_1",
  "email": "admin1@company.com",
  "role": "OfficeAdmin",
  "officeId": 1,
  "firstName": "John",
  "lastName": "Smith"
}
```

### Item Structure
```json
{
  "id": 1,
  "title": "Server Maintenance Schedule",
  "description": "Monthly maintenance schedule for all servers",
  "officeId": 1,
  "createdBy": 2,
  "createdAt": "2024-12-01T09:00:00Z"
}
```

### Comment Structure
```json
{
  "id": 1,
  "itemId": 1,
  "userId": 2,
  "content": "This looks good to me. When do we start?",
  "createdAt": "2024-12-01T10:15:00Z"
}
```

## WireMock Admin Commands

### View all mappings
```bash
curl http://localhost:8080/__admin/mappings
```

### Reset all mappings
```bash
curl -X DELETE http://localhost:8080/__admin/mappings
```

### View request logs
```bash
curl http://localhost:8080/__admin/requests
```

### Clear request logs
```bash
curl -X DELETE http://localhost:8080/__admin/requests
```

## Notes

- All POST, PUT, PATCH, and DELETE requests require an `Authorization: Bearer <token>` header
- The API returns realistic test data with proper relationships between offices, users, items, and comments
- Error responses are automatically handled by WireMock for invalid requests
- The server runs on port 8080 by default
- All timestamps are in ISO 8601 format

## Troubleshooting

1. **Port already in use**: Change the port with `--port 9090`
2. **Mappings not loading**: Ensure the JSON file is valid and properly formatted
3. **CORS issues**: Add `--enable-browser-proxying` flag when starting WireMock
4. **Authentication issues**: Make sure to include the Authorization header for protected endpoints

## Development Tips

- Use the `--verbose` flag to see detailed request/response logs
- The `{{randomValue}}` and `{{now}}` helpers generate dynamic responses
- You can add custom transformations by modifying the mappings file
- Use the WireMock admin API to add mappings dynamically during testing