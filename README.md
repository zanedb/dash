# Dash

### Setup

1. Install Docker on your machine.

2. Build & configure the repo.
```
$ docker-compose build web
$ docker-compose run web bundle && bundle exec rails db:create db:setup && yarn
```
3. Start the development server.
```
$ docker-compose run --service-ports web
```

# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version

- System dependencies

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- ...

todo: update config/environments/production.rb with this line:

```
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```

but with actual URL & stuff

also todo: update config/initializers/devise.rb esp email
