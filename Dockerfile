
FROM python:3.11-slim

# -------------------------
# 2. Set working directory
# -------------------------
WORKDIR /app

# -------------------------
# 3. Install system dependencies (for MySQL connector)
# -------------------------
RUN apt-get update && apt-get install -y \
    default-libmysqlclient-dev gcc \
    && rm -rf /var/lib/apt/lists/*

# -------------------------
# 4. Copy project files
# -------------------------
COPY requirements.txt /app/
COPY . /app/

# -------------------------
# 5. Install Python dependencies
# -------------------------
RUN pip install --no-cache-dir -r requirements.txt

# -------------------------
# 6. Expose Flask port
# -------------------------
EXPOSE 5000

# -------------------------
# 7. Start the Flask app
# -------------------------
CMD ["python", "app.py"]
