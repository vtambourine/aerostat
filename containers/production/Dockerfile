# Production config

FROM ruby:2.4.1

# Install essential packages
RUN apt-get update -qq && \
    apt-get install --yes build-essential

# Define main application directory
ENV APP_HOME /app
WORKDIR $APP_HOME

# Copy source files
# ADD Gemfile* $APP_HOME/
ADD . $APP_HOME/

# Install bundle
RUN gem install bundler
ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile \
    BUNDLE_JOBS=${nproc:-4}

RUN bundle install --deployment \
                   --without development test

ENV RAILS_ENV production
# RUN bundle exec rails assets:precompile