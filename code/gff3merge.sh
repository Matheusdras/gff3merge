GFF1=$1;
GFF2=$2;
DIR=$3
VERB=${DIR}verbose
BASE1=${GFF1##*/}
BASE2=${GFF2##*/}

if [ -d "$DIR" ]; then
    rm -r $DIR
    mkdir $DIR
    mkdir $VERB
else
    mkdir $DIR
    mkdir $VERB
fi
echo 'Parsing comments out of annotations'
grep -v '#' ${GFF1} | grep -P 'WormBase_imported|AUGUSTUS' > ${VERB}/${BASE1%.*}.sanitized.gff3
grep -v '#' ${GFF2} | grep -P 'WormBase_imported|AUGUSTUS' > ${VERB}/${BASE2%.*}.sanitized.gff3
echo 'Concatenating annotations'
cat ${VERB}/${BASE1%.*}.sanitized.gff3 ${VERB}/${BASE2%.*}.sanitized.gff3 > ${VERB}/cat.gff3
echo 'Sorting concatenated annotation'
bedtools sort -i ${VERB}/cat.gff3 > ${VERB}/cat.sorted.gff3
echo 'Parsing genes'
grep -P 'WormBase_imported\tgene|AUGUSTUS\tgene' ${VERB}/cat.sorted.gff3 > ${VERB}/cat.sorted.genes.gff3
echo 'Parsing rnas'
grep -vP 'WormBase_imported\tgene|AUGUSTUS\tgene' ${VERB}/cat.sorted.gff3 > ${VERB}/cat.sorted.rnas.gff3
echo 'Merging genes'
perl ./merge_genes_gff3.pl ${VERB}/cat.sorted.genes.gff3 > ${VERB}/cat.sorted.genes.merged.gff3
echo 'Changing parent id of rnas'
perl ./change_parent_gff3.pl ${VERB}/cat.sorted.rnas.gff3 > ${VERB}/cat.sorted.rnas.no-parent.gff3
echo 'Concatenating genes and rnas'
cat ${VERB}/cat.sorted.genes.merged.gff3 ${VERB}/cat.sorted.rnas.no-parent.gff3 > ${VERB}/cat.genes.rnas.gff3
echo 'Sorting concatenated file'
gt gff3 -sort -tidy ${VERB}/cat.genes.rnas.gff3 > ${VERB}/cat.genes.rnas.sorted.gff3 
echo 'Changing ids'
perl ./gff3sort/gff3sort.pl --precise ${VERB}/cat.genes.rnas.sorted.gff3 > ${VERB}/cat.genes.rnas.sorted.precise.gff3
echo 'Fixing sorting'
perl ./sort_gene_rna.pl ${VERB}/cat.genes.rnas.sorted.precise.gff3 > ${VERB}/cat.genes.rnas.sorted.precise.fixed.gff3
echo 'Adding parent id'
perl ./add_parent.pl ${VERB}/cat.genes.rnas.sorted.precise.fixed.gff3 > ${VERB}/cat.genes.rnas.sorted.precise.fixed.parent.gff3
echo 'Cleaning not complete ORFs out'
gffread ${VERB}/cat.genes.rnas.sorted.precise.fixed.parent.gff3 -C -H -M -o ${VERB}/cat.genes.rnas.sorted.precise.fixed.parent.gffread.gff3
echo 'Assigning canonical transcripts'
perl ./assign_canonical.pl ${VERB}/cat.genes.rnas.sorted.precise.fixed.parent.gffread.gff3 > ${DIR}/merged.gff3
echo 'Done.'
