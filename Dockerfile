FROM ruby:2.7.8

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    libclang-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Rust 1.85
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs| bash -s -- -y --default-toolchain=1.85 --profile minimal
ENV PATH="/root/.cargo/bin:${PATH}"

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