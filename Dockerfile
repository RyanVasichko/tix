FROM ruby:3.2.2-bookworm

# Set environment variables
ENV RAILS_ROOT /var/www/dosey_doe_tickets
ENV BUNDLE_PATH /var/www/dosey_doe_tickets/vendor/bundle
ENV PATH $RAILS_ROOT/vendor/bundle/bin:$PATH

RUN mkdir -p $RAILS_ROOT 

# Set working directory
WORKDIR $RAILS_ROOT

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client libvips42 npm zsh libpq-dev
RUN npm install -g yarn
RUN yarn global add esbuild nodemon sass

RUN sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
SHELL ["/usr/bin/zsh", "-c"]

# Copy necessary files first
COPY Gemfile Gemfile.lock ./
COPY package.json yarn.lock ./

# Install Ruby and JS dependencies
RUN bundle install
RUN yarn install

COPY . .

RUN bundle exec rails app:update:bin

RUN chmod u+x bin/dev

# Start the application
CMD ["bin/dev"]
