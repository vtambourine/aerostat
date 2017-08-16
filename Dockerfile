FROM ruby:2.4.1

# Install essential packages
RUN apt-get update -qq && \
    apt-get install --yes build-essential

# Define main application directory
ENV APP_HOME /app
WORKDIR $APP_HOME

# Copy source files
ADD Gemfile* $APP_HOME/

# Install bundle
ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile \
    BUNDLE_JOBS=${nproc:-7} \
    BUNDLE_PATH=/gems
#RUN bundle check || bundle install
# RUN gem install sinatra
