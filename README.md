# Dash

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

### Counting lines of code

lol

```
$ [cloc](https://github.com/AlDanial/cloc) --exclude-dir=node_modules,tmp .
```
