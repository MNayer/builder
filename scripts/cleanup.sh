#!/bin/bash

# Remove sif files
for sif_path in $(find apptainer/ -type f | grep ".sif$"); do 
  echo "[+] Remove ${sif_path}"
  rm ${sif_path}
done
