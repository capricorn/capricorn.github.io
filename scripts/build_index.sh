#!/bin/bash

pandoc --standalone -V pagetitle="Idle Hours" -V "mainfont:georgia" "root/index.md" -t html