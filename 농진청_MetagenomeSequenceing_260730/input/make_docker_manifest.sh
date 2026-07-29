
#!/bin/bash

# Set raw data directories for host and Docker container
HOST_RAW_DIR="$PWD/input/rawdata"
CONTAINER_RAW_DIR="/data/input/rawdata"

# Automatically detect Paired-End or Single-End data
has_r2=$(ls "$HOST_RAW_DIR"/*_R2_001.fastq.gz 2>/dev/null | head -n 1)

if [ -n "$has_r2" ]; then
  # ==========================================
  # [Case 1] Paired-End Manifest Mode
  # ==========================================
  echo "[INFO] Paired-End FASTQ data detected."
  echo -e "sample-id\tforward-absolute-filepath\treverse-absolute-filepath" > manifest.tsv

  for r1_host in "$HOST_RAW_DIR"/*_R1_001.fastq.gz; do
    [ -e "$r1_host" ] || continue
    filename=$(basename "$r1_host")
    sample_id=$(echo "$filename" | cut -d'_' -f1)
    
    r2_host=$(ls "$HOST_RAW_DIR"/${sample_id}_*_R2_001.fastq.gz 2>/dev/null)
    
    if [ -n "$r2_host" ] && [ -f "$r2_host" ]; then
      r2_filename=$(basename "$r2_host")
      r1_container="${CONTAINER_RAW_DIR}/${filename}"
      r2_container="${CONTAINER_RAW_DIR}/${r2_filename}"
      
      echo -e "${sample_id}\t${r1_container}\t${r2_container}" >> manifest.tsv
    fi
  done

else
  # ==========================================
  # [Case 2] Single-End Manifest Mode
  # ==========================================
  echo "[INFO] Single-End FASTQ data detected."
  echo -e "sample-id\tabsolute-filepath" > manifest.tsv

  # Search for R1 or general .fastq.gz files
  for r1_host in "$HOST_RAW_DIR"/*.fastq.gz; do
    [ -e "$r1_host" ] || continue
    filename=$(basename "$r1_host")
    sample_id=$(echo "$filename" | cut -d'_' -f1)
    
    r1_container="${CONTAINER_RAW_DIR}/${filename}"
    echo -e "${sample_id}\t${r1_container}" >> manifest.tsv
  done
fi

echo "[SUCCESS] manifest.tsv has been successfully generated."
