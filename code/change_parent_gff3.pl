#!/usr/bin/perl
##gff-version 3
#ACOC_contig0000001      AUGUSTUS        mRNA    1       2594    0.65    +       .       ID=g9034.t1;Parent=g9034
@gff3 = `cat $ARGV[0]`;
foreach(@gff3){
    chomp;
    @split = split(/\t/,$_);
    $_ =~ s/Parent=.+// if(($split[2] eq 'mRNA')|($split[2] eq 'ncRNA'));
    print "$_\n";
}
