FROM python:3.12-slim

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

# build-essential: TgCrypto (and a few others) are source-only and need gcc
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential ffmpeg git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install -U pip setuptools wheel && pip install -r requirements.txt

COPY . .

CMD ["python3", "-m", "AloneMusic"]
