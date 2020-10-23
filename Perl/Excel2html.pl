#!/usr/bin/perl
#

## Install CPAN Module 
#  /usr/bin/perl -MCPAN -e 'install Spreadsheet::ParseExcel'
#
#
use strict;
use warnings;
use Spreadsheet::ParseExcel;

my $file = shift || die "Give me an Excel file!\n";
-e $file and -r _ or
    die "Must provide valid Excel file! $file, $!\n";

my $excel_obj = Spreadsheet::ParseExcel->new();
my $workbook = $excel_obj->Parse($file);
die "Workbook did not return worksheets!\n"
    unless ref $workbook->{Worksheet} eq 'ARRAY';

for my $worksheet ( @{$workbook->{Worksheet}} )
{
    print "<table>\n";
    for my $row ( 0 .. $worksheet->{MaxRow} )
    {
        print "<tr>\n";
        for my $col ( 0 .. $worksheet->{MaxCol} )
        {
            my $cell = $worksheet->{Cells}[$row][$col];
            print "<td>";
            print ref $cell ? $cell->Value : '';
            print "</td>\n";
        }
        print "</tr>\n"; # record ends
    }
    print "</table>\n";  # worksheet ends
}
