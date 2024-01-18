FROM ruby:3.0.0

RUN apt-get update -qq && apt-get install -qq --no-install-recommends \
    build-essential nodejs \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
COPY . /app