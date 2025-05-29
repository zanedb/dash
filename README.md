# Dash

> ⚠️ This repo is years old & serving only as an archive. Dash was the world’s best hackathon management platform while it lasted!

### Story

From 2018 to 2020, I was involved in a [ton](https://2018.hackchicago.io) [of](https://2019-site.windyhacks.com/) [hackathons](https://hackpenn.com). After my first leadership experience at [Hack Chicago](https://2018.hackchicago.io), I found myself to be redeploying similar tooling for each event. Things like attendee registration forms, check-ins, and equipment management weren't designed around hackathon use cases.

So I built Dash ✨.

![Dash screenshots](https://i.imgur.com/ZXqcOUP.png)

It handled attendee management, hardware rentals, and I even built a React interface for event organizers to design a custom form that tied into the API.

We all know what happened in 2020, and by the time hackathons had come back, I had moved on. In total, 878 attendees signed up through Dash across 5 hackathons. I still can’t believe that many people used a part of my *first web app* 🤯.

The rest of the repo is intact as an archive, but beware, there may be creatures lurking..

### Setup

1. Clone & enter the repo.

```sh
$ git clone https://github.com/zanedb/dash.git
$ cd dash
```

2. Install dependencies, setup the db & add test data — make sure to respond to & read the prompts.

```sh
$ bin/setup
```

3. Create an admin user (optional).

```sh
$ bin/create-admin
```

4. Start the development server.

```sh
# only run Rails
$ bin/rails server
# run Rails & Webpacker for React hot reload
$ bin/server
```

### Testing

```
$ rails test
```
