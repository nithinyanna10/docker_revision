# syntax=docker/dockerfile:1.7
FROM python:3.11-slim AS base
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1
WORKDIR /app
# 1) Only copy requirements first (cacheable layer)
COPY app/requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
# 2) Then copy the source (changes here won’t bust deps cache)
COPY app/ ./
ENTRYPOINT ["python", "main.py"]