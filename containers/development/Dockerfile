# Development config

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
RUN gem install bundler -v 1.15.4
ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile \
    BUNDLE_JOBS=${nproc:-7} \
    BUNDLE_PATH=/gems

ADD . $APP_HOME/

# ENTRYPOINT [ 'bundle', 'exec' ]

# CMD [ 'bin/rails server -b 0.0.0.0' ]