while(<>){
  chomp;
  $_ =~ s/^>\w+\|(\w+)\|.*/>$1/;
  print "$_\n";
}