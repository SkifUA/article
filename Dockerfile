ARG RUBY_VERSION

FROM ruby:$RUBY_VERSION-slim-buster as builder

ARG MYSQL_VERSION
ARG NODE_MAJOR
ARG BUNDLER_VERSION
ARG YARN_VERSION

# Common dependencies
RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    build-essential \
    gnupg2 \
    libpq-dev \
    postgresql \
    curl \
    less \
    git \
    nano \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

# Add NodeJS to sources list
RUN curl -sL "https://deb.nodesource.com/setup_$NODE_MAJOR.x" | bash -

# Add Yarn to the sources list
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list

# Application dependencies
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    libmariadb-dev \
    nodejs \
    yarn=${YARN_VERSION}-1 \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

ENV BUNDLE_APP_CONFIG=/usr/local/bundle
ENV PATH /app/bin:$PATH

# Upgrade RubyGems and install required Bundler version
RUN gem update --system && \
    gem install execjs bundler:${BUNDLER_VERSION}

RUN mkdir -p /app && mkdir -p /app/tmp/pids

WORKDIR /app

ADD ./ /app/

RUN bundle install && yarn install --check-files
#    && DATABASE_URL=nulldb://fakehost bundle exec rake tmp:create assets:precompile



FROM ruby:$RUBY_VERSION-slim-buster

RUN apt-get update && apt-get install -y tzdata curl imagemagick postgresql nodejs ffmpeg && rm -r /var/lib/apt/lists/*

ADD ./docker-entrypoint.sh /usr/local/bin/
COPY --from=builder /usr/local /usr/local
COPY --from=builder /app /app

WORKDIR /app

RUN chmod +x /usr/local/bin/docker-entrypoint.sh


EXPOSE 3000
ENTRYPOINT ["docker-entrypoint.sh"]