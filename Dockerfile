FROM python:3.10-slim-bullseye

# Set the default shell to Bash
SHELL ["/bin/bash", "-c"]

# Install system dependencies
# RUN apt-get update && apt-get install -y --no-install-recommends \
#     ffmpeg \
#     build-essential && \
#     rm -rf /var/lib/apt/lists/* && \
#     python -m pip install --upgrade pip && \
#     apt-get clean

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential && \
    rm -rf /var/lib/apt/lists/* && \
    python -m pip install --upgrade pip && \
    apt-get clean

# Set a working directory
WORKDIR /app

# Copy only the requirements file
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of your application code into the container
COPY . /app

# Update the pythonpath
ENV PYTHONPATH "${PYTHONPATH}:/app"
CMD ["bash"]