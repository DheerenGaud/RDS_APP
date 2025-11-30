FROM python:3.11-slim

# 1. Set working directory
WORKDIR /app

# 2. Install only necessary system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    default-libmysqlclient-dev gcc \
    && rm -rf /var/lib/apt/lists/*

# 3. Copy requirements first (for Docker caching)
COPY requirements.txt .

# 4. Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copy rest of project files
COPY . .

# 6. Expose Flask port
EXPOSE 5000

# 7. Start the Flask app
CMD ["python", "app.py"]
