FROM ruby:3.2.2-slim-bookworm

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs curl apt-transport-https libvips-dev nano

# Add Yarn repository and install Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y yarn

ENV INSTALL_PATH /app
RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

# Install gems and JS packages
RUN gem install bundler
COPY Gemfile Gemfile.lock package.json yarn.lock ./
RUN bundle install
RUN yarn install --check-files

COPY . .
EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
