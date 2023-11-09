#!/bin/bash

# Check if two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 /path/to/your/reads /path/to/your/output"
    exit 1
fi

# The first command-line argument is the reads directory
READS_DIR="$1"

# The second command-line argument is the output directory
OUTPUT_DIR="$2"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Function to run SPAdes for a single sample and rename the output
assemble_genome() {
    local sample_name=$1
    local forward_reads="${READS_DIR}/${sample_name}_1.fastq"
    local reverse_reads="${READS_DIR}/${sample_name}_2.fastq"
    local output_folder="${OUTPUT_DIR}/${sample_name}_spades_output"
    local final_assembly="${OUTPUT_DIR}/${sample_name}.fasta"

    echo "Assembling genome for sample ${sample_name}..."

    # Run SPAdes
    ~/p-sbrown365-0/Downloads/spades/SPAdes-3.15.4-Linux/bin/spades.py -1 "$forward_reads" -2 "$reverse_reads" -o "$output_folder"

    # Check if SPAdes was successful
    if [[ $? -eq 0 ]]; then
        echo "Assembly completed successfully for sample ${sample_name}."
        # Rename the contigs.fasta to follow the naming convention required
        if [[ -f "${output_folder}/scaffolds.fasta" ]]; then
            mv "${output_folder}/scaffolds.fasta" "$final_assembly"
            echo "Final assembly for sample ${sample_name} is located at ${final_assembly}"
        else
            echo "Expected scaffolds.fasta not found in ${output_folder}."
        fi
    else
        echo "SPAdes encountered an error with sample ${sample_name}."
    fi
}

# Loop through all the FASTQ files and initiate assembly
for forward_read in "${READS_DIR}"/*_1.fastq; do
    # Extract the sample name based on the forward read file name
    sample_name=$(basename "$forward_read" "_1.fastq")
    
    # Call the assembly function for each sample
    assemble_genome "$sample_name" &
done

# Wait for all background processes to finish
wait

echo "All assemblies are complete."


#make a csv
#filename, strain, study, complete/incomplete

#download all the data

#smote