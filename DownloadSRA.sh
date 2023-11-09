# Assign a list of SRA number into a variable

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 /path/to/your/SRAlist /path/to/your/output"
    exit 1
fi

# Unflattened output
SRAlist="$1" #txt file
Outputdir="$2"
mkdir -p "$Outputdir"

while IFS= read -r line; do
    echo "Processing: $line"
  
    ~/p-sbrown365-0/Downloads/sratoolkit.3.0.7-centos_linux64/bin/prefetch $line -O $Outputdir
    
    if [ $? -ne 0 ]; then
        echo "Failed to download $SRA_NUMBER"
    else
        echo "Successfully downloaded $SRA_NUMBER"
    fi
done < $SRAlist


