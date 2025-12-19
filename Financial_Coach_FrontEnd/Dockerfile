# Use official Flutter image
FROM ghcr.io/cirruslabs/flutter:3.24.0

# Set working directory
WORKDIR /app

# Copy pubspec files
COPY pubspec.yaml pubspec.lock ./

# Get dependencies
RUN flutter pub get

# Copy the rest of the application
COPY . .

# Enable web support
RUN flutter config --enable-web

# Expose port for web
EXPOSE 8080

# Run the app
CMD ["flutter", "run", "-d", "web-server", "--web-port", "8080", "--web-hostname", "0.0.0.0"]

