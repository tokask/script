#!/usr/local/bin/perl -T

require 5.003;
use strict;
use CGI;

my $cert_dir = "/usr/local/ssl/certs";
my $cert_file = "CAcert.pem";

my $query = new CGI;

my $kind = $query->param('FORMAT');
if($kind eq 'DER') { $cert_file = "CAcert.der"; }

my $cert_path = "$cert_dir/$cert_file";

open(CERT, "<$cert_path");
my $data = join '', <CERT>;
close(CERT);
print "Content-Type: application/x-x509-ca-cert\n";
print "Content-Length: ", length($data), "\n\n$data";

1;
