# Stage 1: Base image for installing dependencies
FROM python:3.12.7-alpine@sha256:b83d5ec7274bee17d2f4bd0bfbb082f156241e4513f0a37c70500e1763b1d90d AS base
FROM base AS builder
# Set the working directory
WORKDIR /app

# Install system dependencies required for building grpcio
RUN apk update \
    && apk add --no-cache wget g++ \
    && rm -rf /var/cache/apk/*
# Install Python dependencies
COPY requirements.txt .
RUN  pip install --upgrade pip && pip install -r requirements.txt

# Stage 2: Production-ready image
FROM base

ENV PYTHONUNBUFFERED=1

# Set the working directory
WORKDIR /app

# Copy installed dependencies from the builder stage
COPY --from=builder /usr/local/lib/python3.12/ /usr/local/lib/python3.12/
# Copy the application code
COPY . .

# Expose the application port
EXPOSE 5055

# Run the Flask application
ENTRYPOINT ["python", "app.py"]
