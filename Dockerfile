# ===== Stage 1: Base Image =====
FROM python:3.11-slim

# Prevent interactive prompts during package installs
ENV DEBIAN_FRONTEND=noninteractive

# Set working directory inside container
WORKDIR /app

# ===== Stage 2: System Dependencies =====
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential \
      gcc \
      libopenblas-dev \
      liblapack-dev \
      gfortran \
      libjpeg-dev \
      zlib1g-dev \
      libsndfile1 \
      && rm -rf /var/lib/apt/lists/*

# ===== Stage 3: Python Dependencies =====
# Copy requirements file first for better caching
COPY requirements.txt .

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt


# ===== Stage 4: Copy Project Files =====
COPY . .


# ===== Stage 5: Runtime Environment =====
# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PORT=5000

# Expose Flask port
EXPOSE 5000

# ===== Stage 6: Start the App =====
# Replace 'app.py' with your main entry file if different
CMD ["python", "app.py"]
