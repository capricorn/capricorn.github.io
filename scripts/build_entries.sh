#!/bin/bash

# WIP -- iterate root/entries, generate via pandoc to build/entries
# nb. make build/entries dir if it doesn't already exist

cd root/entries
for filename in *.md; do
    filename=${filename/.md}
    # TODO: Enable math jax
    pandoc --standalone -o "../../entries/${filename}.html" "${filename}.md"
done