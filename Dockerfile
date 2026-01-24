# #####################################################################
# Stage 1: Install gems and precompile assets.
# #####################################################################
FROM ruby:3.3-slim AS build
WORKDIR /app

# Base build deps (include ca-certificates so curl TLS is happy)
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    gnupg \
    build-essential \
    libpq-dev \
    libyaml-dev \
    libsqlite3-dev && \
  rm -rf /var/lib/apt/lists/*

# Node 20 repo (NodeSource)
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /usr/share/keyrings/nodesource.gpg && \
  echo "deb [signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" > /etc/apt/sources.list.d/nodesource.list

# Install Node (and use Corepack for Yarn instead of Yarn APT repo)
RUN apt-get update && \
  apt-get install -y --no-install-recommends nodejs && \
  rm -rf /var/lib/apt/lists/* && \
  corepack enable

# If your project expects classic Yarn (v1), keep this:
RUN corepack prepare yarn@1.22.22 --activate
# If it expects modern Yarn (berry), swap to something like:
# RUN corepack prepare yarn@4.5.3 --activate

# Install gems into vendor/bundle
COPY Gemfile Gemfile.lock /app/
RUN bundle config set --local path "vendor/bundle" && \
  bundle install --jobs 4 --retry 3

# If you actually need JS deps for assets, uncomment these:
# COPY package.json yarn.lock /app/
# RUN yarn install --frozen-lockfile

# Copy app and precompile assets (SECRET_KEY_BASE only for this command)
COPY . /app/
RUN SECRET_KEY_BASE=dummy_precompile_secret bin/rails assets:precompile
RUN chown -R www-data:www-data /app

# #####################################################################
# Stage 2: Runtime
# #####################################################################
FROM ruby:3.3-slim
WORKDIR /app

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    libpq5 \
    libsqlite3-0 \
    ca-certificates && \
  rm -rf /var/lib/apt/lists/*

RUN bundle config set --local path "vendor/bundle"

USER www-data:www-data
COPY --from=build /app /app/

EXPOSE 3000
CMD ["bundle", "exec", "rails", "s", "-p", "3000", "-b", "0.0.0.0"]
