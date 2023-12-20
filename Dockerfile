# Base stage shared by both development and production
ARG RUBY_VERSION=3.3.0-rc1
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

WORKDIR /rails

ENV BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_BIN="/usr/local/bundle/bin" \
    PATH="/rails/bin:${PATH}"

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential pkg-config npm libjemalloc2 libvips && \
    apt-get update -qq && \
    npm install -g bun && \
    rm -rf /var/lib/apt/lists/* # Clean up the apt cache

COPY Gemfile Gemfile.lock package.json bun.lockb ./
RUN bun install --check-files && \
    gem install bundler && \
    bundle install --binstubs=$BUNDLE_BIN

# Production build stage
FROM base as build-production

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_WITHOUT="development" \
    RAILS_SERVE_STATIC_FILES="1"

COPY . .
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Final production stage
FROM base as production

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_WITHOUT="development" \
    RUBY_YJIT_ENABLE=1 \
    LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libjemalloc.so.2"

COPY --from=build-production /usr/local/bundle /usr/local/bundle
COPY --from=build-production /rails /rails

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* && \
    groupadd -g 5000 rails && \
    useradd -u 5000 -g 5000 rails --create-home --shell /bin/bash && \
    mkdir -p log storage && \
    chown -R rails:rails db log storage tmp

USER rails:rails
ENTRYPOINT ["/rails/bin/docker-entrypoint"]
EXPOSE 3000
CMD ["./bin/rails", "server"]
