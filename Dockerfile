# TEMPORARY diagnostic Dockerfile: installs packages one by one and
# prints exactly which ones fail (with the last lines of pip's error).
FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1 PIP_NO_CACHE_DIR=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential ffmpeg git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN python --version && pip --version

COPY requirements.txt .
RUN pip install -U pip setuptools wheel

RUN grep -v '^#' requirements.txt | grep -v '^$' > /tmp/pkgs.txt; \
    failed=""; \
    while read -r pkg; do \
      pip install --no-deps "$pkg" > /tmp/out.txt 2>&1 \
        || { echo "=== FAILED: $pkg ==="; tail -n 25 /tmp/out.txt; failed="$failed $pkg"; }; \
    done < /tmp/pkgs.txt; \
    if [ -n "$failed" ]; then echo "FAILED PACKAGES:$failed"; exit 1; fi

COPY . .
CMD ["python3", "-m", "AloneMusic"]
