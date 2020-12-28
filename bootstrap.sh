#!/bin/sh

echo "Creating an environment file"      \
  && cp .env.sample .env                 \
  && mkdir -p db/postgres                \
  && echo "Remove .git"                  \
  && rm -rf .git                         \
  && echo "Building images"              \
  && docker-compose build                \
  && echo "Installing rails"             \
  && docker-compose run --rm web bundle  \
  && echo "Creating your application"    \
  && docker-compose run --rm web bundle exec rails new . -m template.rb \
  && rm -rf bootstrap.sh template.rb template \
  && echo "Your application is ready =)" \
  && echo "Run 'docker-compose up'"


