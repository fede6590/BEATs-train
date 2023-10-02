FROM python:3.10-slim-bullseye AS builder

RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update && \
    apt-get install -yqq --no-install-recommends \
    build-essential && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    rm -rf /var/cache/apt/* && \
    apt-get autoremove -y

WORKDIR /app

FROM builder AS final

COPY requirements.txt .
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --no-cache-dir -r requirements.txt

COPY . .

USER dev

ENV PYTHONPATH "${PYTHONPATH}:/app"