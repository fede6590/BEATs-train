#!/bin/bash

# Function to download a file if it doesn't exist
download_file() {
    local url="$1"
    local destination="$2"

    if [ ! -f "$destination" ]; then
        wget -qO "$destination" "$url"
    else
        echo "File '$destination' already exists. Skipping download."
    fi
}

# Step 1: Download the model checkpoint
model_url="https://valle.blob.core.windows.net/share/BEATs/BEATs_iter3_plus_AS2M.pt?sv=2020-08-04&st=2023-03-01T07%3A51%3A05Z&se=2033-03-02T07%3A51%3A00Z&sr=c&sp=rl&sig=QJXmSJG9DbMKf48UDIU1MfzIro8HQOf3sqlNXiflY1I%3D"
model_destination="/data/BEATs/BEATs_iter3_plus_AS2M.pt"

download_file "$model_url" "$model_destination"

# Step 2: Download and extract the data
data_url="https://github.com/karoldvl/ESC-50/archive/master.tar.gz"
data_destination="/data/master.tar.gz"

download_file "$data_url" "$data_destination"

# Extract data if it doesn't exist
if [ ! -d "/data/ESC-50-master" ]; then
    tar xzf "$data_destination" -C /data
else
    echo "Data is already extracted. Skipping extraction."
fi
