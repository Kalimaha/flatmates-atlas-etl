# Base image
FROM elixir:1.6.4-alpine

# Install cURL and Git
RUN apk update && apk add -y curl git

# Add source code to the image
ADD . /app

# Install Phoenix
RUN mix local.hex --force
RUN mix local.rebar --force

# Set work directory
WORKDIR /app

# Install dependencies
RUN mix deps.get
