use strict;
use warnings;
use v5.30;

sub _create_random_list_of_numbers {
    my $list_size = $_[0];
    my @list_of_numbers = (); 

    for (my $i = 0; $i <= $list_size; $i++) {
        push(@list_of_numbers, int(rand(10000)));
    }

    return @list_of_numbers;
}

sub _create_random_strings {
    my @chars = ('A'..'Z');
    my $len = $_[0];
    my $string = "";
    
    while($len--){ 
        $string .= $chars[rand(@chars)] 
    };

    return $string;
}

sub _write_a_csv_file {
    my @list_of_numbers = @_;    
    my $file_name = pop @list_of_numbers;
    my $number_of_rows = pop @list_of_numbers;
    
    open(my $FH, '>', $file_name) or die $!;
    
    for (my $i = 0; $i < $number_of_rows; $i++) {
    	print $FH pop(@list_of_numbers)." , $list_of_numbers[-1] \n";
    }
    
    close($FH);
}

if (!caller) {
    my @random_list =  _create_random_list_of_numbers(5);
    my $random_string =  _create_random_strings(5);
    
    print "Please, enter the file name: ";
    my $file_name = <STDIN>;
    chomp($file_name);
    
    print "And the number of rows: ";
    my $number_of_rows = <STDIN>;
    chomp($number_of_rows);
    
    _write_a_csv_file(@random_list, $random_string, $number_of_rows, $file_name);
}
