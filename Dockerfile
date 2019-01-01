FROM ruby:2.5.1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install latest version of pg_restore for easy importing of production
# database & vim for easy editing of credentials.
RUN apt-get -y update && apt-get -y install postgresql-client vim
RUN curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash -
RUN apt-get install -y nodejs

ENV EDITOR=vim

ADD Gemfile /usr/src/app/Gemfile
ADD Gemfile.lock /usr/src/app/Gemfile.lock

ENV BUNDLE_GEMFILE=Gemfile \
  BUNDLE_JOBS=4 \
  BUNDLE_PATH=/bundle

RUN bundle install

ADD . /usr/src/app
