FROM ruby:2.7-alpine3.13

# env set up
ENV PATH $PATH:$GEM_HOME/bin

# install need packages
RUN apk update && apk add \
    nodejs \
    postgresql-client \
    postgresql-dev \
    build-base \
    libffi-dev \
    git \
    tzdata && \
    rm -rf /var/cache/apk/*


# create working directory
WORKDIR /app

# install bundler
RUN gem install bundler

# set entrypoint
COPY ./docker/start.sh /usr/bin/
RUN chmod +x /usr/bin/start.sh
