use strict;
use warnings;
use YAML::Tiny;
use JSON;
use Text::CSV;

# Check if the input file and format are provided
# Provide the required command-line arguments in your script running configuration (script parameters)
if (@ARGV != 2) {
    die "Usage: $0 <config_file> <yaml|json>\n";
}

my ($config_file, $format) = @ARGV;

# Read the config file
my $config;

if ($format eq 'yaml') {
    $config = YAML::Tiny->read($config_file)->[0];
} elsif ($format eq 'json') {
    open my $fh, '<', $config_file or die "Can't open $config_file: $!";
    local $/;
    my $json_text = <$fh>;
    close $fh;
    $config = decode_json($json_text);
} else {
    die "Invalid format. Please use 'yaml' or 'json'.\n";
}

# Check if the output file and fields are provided
if (!exists $config->{'output'} || !exists $config->{'fields'}) {
    die "Config file must contain 'output' and 'fields'.\n";
}

# Create a CSV object
my $csv = Text::CSV->new({binary => 1, eol => "\n"}) or die "Cannot create CSV object: " . Text::CSV->error_diag();

# Open the output file
open my $output_fh, '>', $config->{'output'} or die "Can't open " . $config->{'output'} . ": $!";

# Write the header to the output file
$csv->say($output_fh, [map { $_->{'name'} } @{$config->{'fields'}}]);

# Write the rows to the output file (this example generates 10 rows)
for my $row (1 .. 10) {
    my @data = map {
        my $field = $_;
        my $type = $field->{'type'};
        if ($type eq 'integer') {
            int(rand(100)); # Generate a random integer between 0 and 99
        } elsif ($type eq 'string') {
            join('', map { ('a'..'z', 'A'..'Z', 0..9)[rand 62] } 1..8); # Generate a random 8-character alphanumeric string
        } else {
            die "Unsupported field type: $type\n";
        }
    } @{$config->{'fields'}};
    $csv->say($output_fh, \@data);
}

# Close the output file
close $output_fh;

print "CSV file generated: " . $config->{'output'} . "\n";

