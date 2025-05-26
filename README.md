# Blog API
A simple RESTful Blog API built with Ruby on Rails, PostgreSQL, JWT authentication, Sidekiq, and Redis.


## Features

- User Authentication (Signup/Login) with JWT
- Create, Read, Update, and Delete blog posts
- Add/Edit/Delete comments on posts
- Tag posts (with tag creation if not found)
- Schedule automatic post deletion after 24 hours

##  Getting Started

### Prerequisites

- Ruby 3.0+
- Rails 7+
- PostgreSQL
- Redis (v6.2+ required for Sidekiq)
- Sidekiq

### Setup Instructions

```bash
# Clone the repo
git clone https://github.com/your-username/blog-api.git
cd blog-api

# Install dependencies
bundle install

# Set up the database
rails db:create db:migrate db:seed

# Start the Rails server
rails s

# Start Sidekiq (in a new terminal)
bundle exec sidekiq
```

##  Application Endpoints

### Create a Post
**POST** `/posts`  
Create a new post with at least on tag. Tags will be created if they don't exist.  

**Body:**
```json
{
  "title": "My First Post",
  "body": "This is the body of the post",
  "tag_names": ["rails", "backend"]
}
```

### Get All Posts
**GET** `/posts`  
Returns a list of all posts.

### Get Single Post
**GET** `/posts/:id`  
Returns a specific post by ID.

### Update Post
**PATCH** `/posts/:id`  
Update a post. Only the author can update their own post.  

**Body (partial or full):**
```json
{
  "title": "Updated Title",
  "body": "Updated content"
}
```

### Delete Post
**DELETE** `/posts/:id`  
Deletes a post. Only the author can delete their own post.

### Update Post Tags
**PATCH** `/posts/:id/tags`  
Replace or update the tags associated with a post using tag IDs.  

**Body:**
```json
{
  "tags": [1,2]
}
```

## Comments Endpoints

### Add a Comment
**POST** `/posts/:post_id/comments`  
Adds a new comment to a post.  

**Body:**
```json
{
  "body": "This is a comment"
}
```

### Update a Comment
**PATCH** `/comments/:id`  
Update your own comment.  

**Body:**
```json
{
  "body": "Updated comment text"
}
```

### Delete a Comment
**DELETE** `/comments/:id`  
Deletes a comment. Only the author can delete their own comment.

## 🏷️ Tags Endpoints

### Get All Tags
**GET** `/tags`  
Returns a list of all available tags.

### Create a New Tag
**POST** `/tags`  
Creates a new tag.  

**Body:**
```json
{
  "name": "newtag"
}
```

## Authentication Endpoints

### Sign Up
**POST** `/signup`  
Register a new user.  

**Body:**
```json
{
  "name": "Jane Doe",
  "email": "jane@example.com",
  "password": "password123",
  "image": "http://example.com/avatar.jpg"
}
```

### Log In
**POST** `/login`  
Authenticate an existing user and receive a JWT token.  

**Body:**
```json
{
  "email": "jane@example.com",
  "password": "password123"
}
```

**Response:**
```json
{
  "token": "your-jwt-token"
}
```

Use this token in the Authorization header for all protected endpoints:
```makefile
Authorization: Bearer <token>
```

## Scheduled Deletion
All posts are scheduled for deletion 24 hours after creation using Sidekiq background jobs. 

