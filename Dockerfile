FROM ruby:2.5.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs imagemagick 
RUN mkdir /bookstore
WORKDIR /bookstore
COPY Gemfile /bookstore/Gemfile
COPY Gemfile.lock /bookstore/Gemfile.lock
RUN bundle install
COPY . /bookstore
