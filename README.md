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

