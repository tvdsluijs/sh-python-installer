#!/bin/bash
# build
# run
# open bash
# after exit, DESTROY container!

docker run --rm -it $(docker build -q .) bash