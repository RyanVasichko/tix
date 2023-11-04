# Base stage shared by both development and production
ARG RUBY_VERSION=3.2.2-slim
FROM registry.docker.com/library/ruby:$RUBY_VERSION as base

WORKDIR /rails

ENV BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_BIN="/usr/local/bundle/bin" \
    PATH="/rails/bin:${PATH}"

# Install packages and cleanup
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs curl apt-transport-https libvips-dev nano git pkg-config && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update -qq && apt-get install -y yarn && \
    rm -rf /var/lib/apt/lists/* # Clean up the apt cache

COPY Gemfile Gemfile.lock package.json yarn.lock ./
RUN yarn install --check-files && \
    yarn cache clean && \
    gem install bundler && \
    bundle install --binstubs=$BUNDLE_BIN

# Development stage
FROM base as development
COPY . .
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]

# Production build stage
FROM base as build-production
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_WITHOUT="development"

COPY . .
RUN bundle exec bootsnap precompile app/ lib/ && \
    SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Final production stage
FROM base as production
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_WITHOUT="development"

COPY --from=build-production /usr/local/bundle /usr/local/bundle
COPY --from=build-production /rails /rails

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y libvips && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* && \
    useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp && \
    chmod +x /rails/bin/docker-entrypoint

USER rails:rails
ENTRYPOINT ["/rails/bin/docker-entrypoint"]
EXPOSE 3000
CMD ["./bin/rails", "server"]
