#!/bin/bash

pandoc --standalone -V pagetitle="Idle Hours" -V "mainfont:georgia" -o "index.html" "root/index.md"