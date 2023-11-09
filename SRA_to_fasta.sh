# Check if two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 /path/to/your/sradir /path/to/your/output"
    exit 1
fi

# The first command-line argument is the reads directory
READS_DIR="$1"

# The second command-line argument is the output directory
OUTPUT_DIR="$2"

mkdir -p "$OUTPUT_DIR"

# Loop through all the FASTQ files and initiate assembly
for sra in "${READS_DIR}"/*.sra; do
    echo $sra
    # Extract the sample name based on the sra file name 
    # Call the sra_to_fasta for each sample
    ~/p-sbrown365-0/Downloads/sratoolkit.3.0.7-centos_linux64/bin/fasterq-dump -O "$OUTPUT_DIR"/ "$sra"
    
done

# Wait for all background processes to finish
wait

echo "All assemblies are complete."