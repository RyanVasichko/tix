# Base stage shared by both development and production
ARG RUBY_VERSION=3.2.2-slim
FROM registry.docker.com/library/ruby:$RUBY_VERSION as base

WORKDIR /rails

ENV BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_BIN="/usr/local/bundle/bin" \
    PATH="/rails/bin:${PATH}"

# Install packages including jemalloc and cleanup
RUN apt-get update -qq -o Acquire::http::Timeout=30 && \
    apt-get install --no-install-recommends -y build-essential libpq-dev npm curl apt-transport-https libvips-dev nano git pkg-config unzip libjemalloc2 -o Acquire::http::Timeout=30 && \
    apt-get update -qq -o Acquire::http::Timeout=30 && \
    npm install -g bun && \
    rm -rf /var/lib/apt/lists/* # Clean up the apt cache

COPY Gemfile Gemfile.lock package.json bun.lockb ./
RUN bun install --check-files && \
    gem install bundler && \
    bundle install --binstubs=$BUNDLE_BIN

# Development stage
FROM base as development

# Repeat jemalloc configuration
ENV LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libjemalloc.so.2"

COPY . .
RUN chmod +x entrypoint.sh
CMD ["./bin/rails", "server"]

# Production build stage
FROM base as build-production
ARG RAILS_MASTER_KEY

# Repeat jemalloc configuration
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_WITHOUT="development" \
    RAILS_MASTER_KEY=${RAILS_MASTER_KEY} \
    LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libjemalloc.so.2"

COPY . .
RUN chmod +x ./bin/rails && \
    bundle exec bootsnap precompile app/ lib/ && \
    ./bin/rails assets:precompile

# Final production stage
FROM base as production

# Repeat jemalloc configuration
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_WITHOUT="development" \
    RUBY_YJIT_ENABLE=1 \
    LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libjemalloc.so.2"

COPY --from=build-production /usr/local/bundle /usr/local/bundle
COPY --from=build-production /rails /rails

RUN apt-get update -qq -o Acquire::http::Timeout=30 && \
    apt-get install --no-install-recommends -y libvips -o Acquire::http::Timeout=30 && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* && \
    useradd rails --create-home --shell /bin/bash && \
    mkdir -p log storage && \
    chown -R rails:rails db log storage tmp && \
    chmod +x /rails/bin/docker-entrypoint

USER rails:rails
ENTRYPOINT ["/rails/bin/docker-entrypoint"]
EXPOSE 3000
CMD ["./bin/rails", "server"]
