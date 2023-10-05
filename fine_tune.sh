#!/bin/bash

docker run \
    -v $PWD:/app \
    --gpus all \
    beats \
    python fine_tune/trainer.py fit \
        --trainer.accelerator gpu \
        --trainer.gpus 1 \
        --data.batch_size 16 \
        --model.ft_entire_network True