# Use official Python image (pick a version that supports your Python deps)
FROM python:3.11-slim

# Set workdir
WORKDIR /app

# Install system dependencies required for building some Python wheels (and diplib if needed)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential \
      gcc \
      libatlas-base-dev \
      liblapack-dev \
      gfortran \
      libjpeg-dev \
      zlib1g-dev \
      libsndfile1 \
      && rm -rf /var/lib/apt/lists/*

# Copy requirement file and install (will leverage Docker cache)
COPY requirements.txt /app/requirements.txt
RUN pip install --upgrade pip
# Install requirements. If diplib fails, you can remove it from requirements.txt later.
RUN pip install -r /app/requirements.txt

# Copy app code & model files
COPY . /app

# Expose port that gunicorn will serve on
EXPOSE 8000

# Default command to run (gunicorn serving app:app)
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "4", "--timeout", "600", "app:app"]
