# BEATs fine-tuning pipeline 🎵

This repository is dedicated to building a preliminary fine-tuning pipeline for [BEATs](https://arxiv.org/abs/2212.09058), a powerful "Audio Pre-Training with Acoustic
Tokenizers" model developed by Microsoft, and you can find the official repository [here](https://github.com/microsoft/unilm/tree/master/beats). This pipeline is a work in progress focused on fine-tuning the model using the [ESC-50 dataset](https://github.com/karolpiczak/ESC-50) before extending its capabilities to handle custom datasets.

The initial implementation of this pipeline was developed by the [Norwegian Institute for Nature Research (NINA)](https://www.nina.no/) using [Lightning AI](https://lightning.ai/docs) and their work is available [here](https://github.com/NINAnor/rare_species_detections/tree/main).

**UPDATES:**
- Docker image built with:
  - Python 3.10 (slim version image based on Debian bullseye)
  - PyTorch 2.0
  - Torchaudio 2.0
  - Lightning 2.0
- Optimized Docker image with minimum requirements (less dependencies)
- Warning errors while training (still in progress)

**PENDINGS**: 
- Prototypical network training orquestration with config file similarly to the fine-tuning case
- Bash scripting for data preparation
- Fine-tuning evaluation metrics on ESC-50 dataset
- Fine-tuning on custom dataset

**NOTE:**
fine-tuning/retraining the Tokenizer is NOT on the agenda at the moment. This pipeline is designed only for training the feature extractor and the prototypical network.


## Data preparation

To get started, follow these steps:

- Clone this repository:

  ```bash
  git clone https://github.com/fede6590/BEATs-train.git
  ```

- Download the following files:
    - [BEATs_iter3+ (AS2M) model](https://valle.blob.core.windows.net/share/BEATs/BEATs_iter3_plus_AS2M.pt?sv=2020-08-04&st=2023-03-01T07%3A51%3A05Z&se=2033-03-02T07%3A51%3A00Z&sr=c&sp=rl&sig=QJXmSJG9DbMKf48UDIU1MfzIro8HQOf3sqlNXiflY1I%3D)
    - [ESC-50 dataset](https://github.com/karoldvl/ESC-50/archive/master.zip)


After downloading, extract the contents of the ESC-50 dataset ZIP file inside the `data` folder. The folder structure within the data directory should be as the following:
- data/
    - BEATs/
        - BEATs_iter3_plus_AS2M.pt
    - ESC-50-master/
        - audio/
        - meta/
        - ...


## Getting started with training

To build the Docker image, use the following command:

```bash
docker build -t beats -f Dockerfile .
```

### Fine-tuning

**IMPORTANT**: `fine_tune/config.yaml` contains all the customizable parameters for training.

For fine-tuning BEATs on your dataset, use the following commands:

- with available GPU(s)
  ```bash
  docker run -v "$PWD":/app \
              -v "data":/data \
              --gpus all \
              beats \
              python fine_tune/trainer.py fit --config fine_tune/config.yaml
  ```
- without GPU
  ```bash
  docker run -v "$PWD":/app \
              -v "data":/data \
              beats \
              python fine_tune/trainer.py fit --config fine_tune/config.yaml
  ```

### Prototypical network

To train the prototypical network, first, create a miniESC50 dataset:

- with available GPU(s)
  ```bash
  docker run -v "$PWD":/app \
              -v "data":/data \
              --gpus all \
              beats \
              python data_utils/miniESC50.py
  ```

- without GPU
  ```bash
  docker run -v "$PWD":/app \
              -v "data":/data \
              beats \
              python data_utils/miniESC50.py
  ```

Then, start the training:

- with available GPU(s)
  ```bash
  docker run -v "$PWD":/app \
              -v "data":/data \
              --gpus all \
              beats \
              python prototypicalbeats/trainer.py fit --trainer.accelerator gpu --trainer.gpus 1 --data miniESC50DataModule
  ```

- without GPU
  ```bash
  docker run -v "$PWD":/app \
              -v "data":/data \
              beats \
              python prototypicalbeats/trainer.py fit --data miniESC50DataModule
  ```
