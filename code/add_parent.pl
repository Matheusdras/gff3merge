#!/usr/bin/perl
#ACOC_contig0000001      CUSTOM  gene    1       2594    1       +       .       .
#ACOC_contig0000001      AUGUSTUS        mRNA    1       2594    0.65    +       .       ID=mRNA1
@gff3 = `cat $ARGV[0]`;
$count = 0;
foreach(@gff3){
    chomp;
    @split = split(/\t/, $_);
    if($split[2] eq 'gene'){
	$count++;
	$_ .= "\tID=gene" . $count . "\n";
	print "$_\n";
    }elsif(($split[2] eq 'mRNA')||($split[2] eq 'ncRNA')){
	$_ .= ";Parent=gene" . $count . "\n";
	print "$_\n";
    }else{
	print "$_\n";
    }
}
