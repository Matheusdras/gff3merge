#!/usr/bin/perl
#ACOC_contig0000001      CUSTOM  gene    1       2594    1       +       .       .
#ACOC_contig0000001      AUGUSTUS        mRNA    1       2594    0.65    +       .       ID=mRNA1
#ACOC_contig0000001      WormBase_imported       mRNA    1456    2594    .       +       .       ID=mRNA2
#ACOC_contig0000001      Mikado_loci     mRNA    3066    31763   20      -       .       ID=mRNA3
#ACOC_contig0000001      CUSTOM  gene    3066    31763   1       .       .       .
=head
ACOC_contig0000001      CUSTOM  gene    1       2594    1       +       .       .
ACOC_contig0000001      AUGUSTUS        mRNA    1       2594    0.65    +       .       ID=mRNA1
ACOC_contig0000001      AUGUSTUS        exon    1402    1489    .       +       .       Parent=mRNA1
ACOC_contig0000001      AUGUSTUS        CDS     1402    1489    0.95    +       2       Parent=mRNA1
ACOC_contig0000001      WormBase_imported       mRNA    1456    2594    .       +       .       ID=mRNA2
ACOC_contig0000001      WormBase_imported       CDS     1456    1726    .       +       0       ID=CDS1;Parent=
mRNA2
ACOC_contig0000001      WormBase_imported       exon    1456    1726    .       +       .       Parent=mRNA2
ACOC_contig0000001      AUGUSTUS        CDS     1611    1726    0.93    +       1       Parent=mRNA1
ACOC_contig0000001      AUGUSTUS        exon    1611    1726    .       +       .       Parent=mRNA1
ACOC_contig0000001      AUGUSTUS        CDS     2398    2594    0.65    +       2       Parent=mRNA1
ACOC_contig0000001      WormBase_imported       exon    2398    2594    .       +       .       Parent=mRNA2
ACOC_contig0000001      AUGUSTUS        exon    2398    2594    .       +       .       Parent=mRNA1
ACOC_contig0000001      WormBase_imported       CDS     2398    2594    .       +       2       ID=CDS1;Parent=
mRNA2
ACOC_contig0000001      Mikado_loci     mRNA    3066    31763   20      -       .       ID=mRNA3
ACOC_contig0000001      CUSTOM  gene    3066    31763   1       .       .       .
ACOC_contig0000001      Mikado_loci     exon    3066    3701    .       -       .       Parent=mRNA3
=cut
@gff3 = `cat $ARGV[0]`;
chomp @gff3;
$flag = 0;
$gene = "";
for($i = 0; $i <= $#gff3; $i++){
    $line1 = $gff3[$i];
    $line2 = $gff3[$i + 1];
    @split = split(/\t/,$line1);
    $feature1 = $split[2];
    @split = ();
    @split = split(/\t/,$line2);
    $feature2 = $split[2];
    @split = ();
    if($line1 =~ /^#/){print "$line1\n"; next;}
    if(($feature1 eq 'gene')&&(($feature2 eq 'mRNA')||($feature2 eq 'ncRNA'))){
	print "$line1\n";
	print "$line2\n";
	$i++;
    }elsif(($feature2 eq 'gene')&&(($feature1 eq 'mRNA')||($feature1 eq 'ncRNA'))){
	print "$line2\n";
	print "$line1\n";
	$i++;
    }else{
	print "$line1\n";
    }
}
