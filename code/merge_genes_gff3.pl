#!/usr/bin/perl
use strict;
use warnings;
#use Number::Range;
use Bio::Range;
###gff-version 3
#ACOC_contig0000001      AUGUSTUS        gene    1       2594    0.65    +       .
#    ID=g9034;
#ACOC_contig0000001      AUGUSTUS        mRNA    1       2594    0.65    +       .
#    ID=g9034.t1;Parent=g9034
my @gff3 = `cat $ARGV[0]`;
my %gene_ranges;
my %chr_unions;
#print "$range\n";
#$range = "";
#$range = Bio::Range->new(10,20,0);
foreach(@gff3){
    chomp;
    my @split = split(/\t/,$_);
    #$range = Number::Range->new($split[3]..$split[4]);
    #print "$split[2]\n";
    if($split[2] =~ /gene/){
	my $strand = 0;
	if($split[6] eq '.'){
	}elsif($split[6] eq '-'){
	    $strand = $split[6] . 1;
	}elsif($split[6] eq '+'){
	    $strand = 1;
	}
	my $range = Bio::Range->new(-start=>$split[3], -end=>$split[4], -strand=>$strand);
	#print $split[0] . " " . $split[8] . " " . $range->toString(), "\n";
	$gene_ranges{$split[0]}{$split[8]} = $range;
    }
}

=head
foreach(@gff3){
    chomp;
    @split = split(/\t/,$_);
    $range = Number::Range->new($split[3]..$split[4]);
    if($split[2] =~ /gene/){
	if($range->inrange($gene_ranges{$split[0]})){
	    $overlap_genes{$split[0]}{$split[8]}=$range;
	}
    }
}

=cut
foreach my $chr(sort {$a cmp $b} keys %gene_ranges){
    my @ranges = ();
    my @unions = ();
    foreach my $gene(sort {$a cmp $b} keys %{$gene_ranges{$chr}}){
	push(@ranges, $gene_ranges{$chr}{$gene});
    } 
    @unions = Bio::Range->unions(@ranges);
    $chr_unions{$chr} = \@unions;
}
#ACOC_contig0000001      AUGUSTUS        gene    1       2594    0.65    +       .
#    ID=g9034;
#ACOC_contig0000001      AUGUSTUS        mRNA    1       2594    0.65    +       .
#    ID=g9034.t1;Parent=g9034
foreach my $chr(sort {$a cmp $b} keys %chr_unions){
    my @unions = @{$chr_unions{$chr}};
    my $count = 0;
    foreach(@unions){
	$count++;
	my $strand = $_->strand;
	if($strand == -1){
	    $strand = '-';
	}elsif($strand == 1){
	    $strand = '+';
	}elsif($strand == 0){
	    $strand = '.';
	}
	print $chr . "\tCUSTOM\tgene\t" . $_->start() . "\t" . $_->end() . "\t1\t" . $strand . "\t" . "\." . "\t" . "ID=" . $chr . '_gene' . $count . "\n";
    }
}

