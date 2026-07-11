# README

This README would normally document whatever steps are necessary to get the
application up and running.

## Running the test suite

Install Playwright and its Chromium browser once after installing the Ruby
dependencies. This uses npm's cache and does not add Node dependencies to the
repository:

```sh
npx --yes playwright@$(bundle exec ruby -e 'require "playwright"; print Playwright::COMPATIBLE_PLAYWRIGHT_VERSION') install chromium
```

System tests check this automatically and print the same command if the CLI or
Chromium browser is missing.

Run the Rails tests with:

```sh
bin/rails test
```

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
