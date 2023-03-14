use strict;
use warnings;
use Text::CSV;

print "Please, enter the file name: ";
my $file_name = <STDIN>;
chomp($file_name);

print "And the number of rows: ";
my $rows_number = <STDIN>;
chomp($rows_number);

my $csv = Text::CSV->new ({
    sep_char => ',',
    quote_char => '"',
    escape_char => '\\'
});

open my $fh, ">", $file_name or die "Could not create file: $!";

# Header
$csv->say ($fh, [ 'user_id', 'user_name' ]);

my $counter = 0;
while ($counter < $rows_number) {

    my $user_id = int(rand(1000));
    my $user_name = "text_user" . int(rand(10));

    $csv->say ($fh, [ $user_id, $user_name ]);

    $counter++;
}

close $fh;