# BEATs fine-tuning pipeline

This GitHub repository is made for using [BEATs](https://arxiv.org/abs/2212.09058) on your own dataset and is still a work in progress. In its current form, the repository allow a user to

- Fine-tune BEATs on the [ESC50 dataset](https://github.com/karolpiczak/ESC-50).
- Fine-tune a prototypical network with BEATs as feature extractor on the [ESC50 dataset](https://github.com/karolpiczak/ESC-50).

## Necessary downloads

- Download [BEATs_iter3+ (AS2M) model](https://valle.blob.core.windows.net/share/BEATs/BEATs_iter3_plus_AS2M.pt?sv=2020-08-04&st=2023-03-01T07%3A51%3A05Z&se=2033-03-02T07%3A51%3A00Z&sr=c&sp=rl&sig=QJXmSJG9DbMKf48UDIU1MfzIro8HQOf3sqlNXiflY1I%3D)
- Download [ESC50 dataset](https://github.com/karoldvl/ESC-50/archive/master.zip)
- Clone this repo: `git clone https://github.com/fede6590/BEATs-train.git`
- Build the docker image:

```bash
docker build -t beats -f Dockerfile .
```

**Make sure `ESC-50-master` and `BEATs/BEATs_iter3_plus_AS2M.pt` are stored in your `$DATAPATH` (data folder that is exposed to the Docker container)**

## Using the software: fine tuning

Providing that `ESC-50-master` and `BEATs/BEATs_iter3_plus_AS2M.pt` are stored in your `$DATAPATH`:

```bash
docker run -v "$PWD":/app \
            -v "data":/data \
            --gpus all `# if you have GPUs available` \
            beats \
            python fine_tune/trainer.py fit --config fine_tune/config.yaml
```
```bash
docker run -v "$PWD":/app \
            -v "data":/data \
            beats \
            python fine_tune/trainer.py fit --config fine_tune/config.yaml
```

## Using the software: training a prototypical network

- Create a miniESC50 dataset in your `$DATAPATH`:

```bash
docker run -v "$PWD":/app \
            -v "data":/data \
            --gpus all `# if you have GPUs available` \
            beats \
            python data_utils/miniESC50.py
```
```bash
docker run -v "$PWD":/app \
            -v "data":/data \
            beats \
            python data_utils/miniESC50.py
```

- Train the prototypical network:

```bash
docker run -v "$PWD":/app \
            -v "data":/data \
            --gpus all \
            beats \
            python prototypicalbeats/trainer.py fit --trainer.accelerator gpu --trainer.gpus 1 --data miniESC50DataModule
```
```bash
docker run -v "$PWD":/app \
            -v "data":/data \
            beats \
            python prototypicalbeats/trainer.py fit --data miniESC50DataModule
```

# BEATs: Audio Pre-Training with Acoustic Tokenizers
- Paper: https://arxiv.org/abs/2212.09058
- Github source: https://github.com/microsoft/unilm/tree/master/beats
- Copyright (c) 2022 Microsoft
- Licensed under The MIT License [see LICENSE for details]
- Based on fairseq code bases
- https://github.com/pytorch/fairseq