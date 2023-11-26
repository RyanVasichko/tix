# Base stage shared by both development and production
ARG RUBY_VERSION=3.2.2-slim
FROM registry.docker.com/library/ruby:$RUBY_VERSION as base

WORKDIR /rails

ENV BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_BIN="/usr/local/bundle/bin" \
    PATH="/rails/bin:${PATH}"

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential libpq-dev curl npm libvips-dev libjemalloc2 wget gnupg && \
    apt-get update -qq && \
    npm install -g bun && \
    # Add the PostgreSQL repository for the latest versions
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(. /etc/os-release; echo $VERSION_CODENAME)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' && \
    apt-get update && apt-get install -y postgresql-client-16 && \
    rm -rf /var/lib/apt/lists/* # Clean up the apt cache

COPY Gemfile Gemfile.lock package.json bun.lockb ./
RUN bun install --check-files && \
    gem install bundler && \
    bundle install --binstubs=$BUNDLE_BIN

# Development stage
FROM base as development

ENV LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libjemalloc.so.2"

COPY . .
RUN chmod +x entrypoint.sh
CMD ["./bin/rails", "server"]

# Production build stage
FROM base as build-production

ARG RAILS_MASTER_KEY
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

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_WITHOUT="development" \
    RUBY_YJIT_ENABLE=1 \
    LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libjemalloc.so.2"

COPY --from=build-production /usr/local/bundle /usr/local/bundle
COPY --from=build-production /rails /rails

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y libvips && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* && \
    useradd rails --create-home --shell /bin/bash && \
    mkdir -p log storage && \
    chown -R rails:rails db log storage tmp && \
    chmod +x /rails/bin/docker-entrypoint

USER rails:rails
ENTRYPOINT ["/rails/bin/docker-entrypoint"]
EXPOSE 3000
CMD ["./bin/rails", "server"]
