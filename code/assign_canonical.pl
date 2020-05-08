#!/usr/bin/perl
#ACOC_contig0000001      AUGUSTUS        mRNA    1402    2594    0.65    +       .       ID=mRNA1;geneID=gene1;locus=RLOC_00000001
@gff3 = `cat $ARGV[0]`;
$dir = $ARGV[1];
%gene_rna;
foreach(@gff3){
    next if ($_ =~ /^#/);
    chomp;
    @split = split(/\t/,$_);
    if($split[2] eq 'mRNA'){
	($rna, $gene, $locus) = split(/;/,$split[8]);
	$len = $split[4] - $split[3];
	$gene_rna{$gene}{$len}=$rna;
    }
}
@can = ();
#sort {$a cmp $b}
#open(TMP, >, $dir . "/tmp.tab") or die $!;
foreach my $gene (keys %gene_rna){
    foreach $len (sort {$b <=> $a} keys %{$gene_rna{$gene}}){
	$rna = $gene_rna{$gene}{$len};
	push(@can,$rna);
#	print TMP $gene . "\t" . $rna . "\t" . $len . "\n"; 
	last;
    }
}
#close(TMP);
#open(FINAL, >, $dir . "/tmp.tab") or die $!;

foreach(@gff3){
    chomp;
    if ($_ =~ /^#/){print "$_\n"; next;}
    @split = split(/\t/,$_);
    if($split[2] eq 'mRNA'){
	($rna, $gene, $locus) = split(/;/,$split[8]);
	if(grep /^$rna$/, @can){
	    print $_ . ";Note=Canonical transcript;\n";
	}else{
	    print $_ . ";Note=Isoform;\n";
	}
    }else{
	print "$_;\n";
    }
}
