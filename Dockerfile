FROM ruby:2.7.8

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

ARG TARGET_ARCH
ENV MAGNUS_TARGET_ARCH=${TARGET_ARCH}

# Update RubyGems to specific version
RUN gem update --system 3.4.14

# Set working directory
WORKDIR /app

# Copy gem files first for better caching
COPY Gemfile* *.gemspec ./
COPY lib/magnus_multi_build/version.rb lib/magnus_multi_build/version.rb
RUN bundle install

# Copy the rest of the application
COPY . .

CMD ["bash"]