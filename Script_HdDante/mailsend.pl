#!/usr/bin/perl
#


open(SENDMAIL, "|/usr/lib/sendmail -oi -t -odq")
                        or die "Impossibile aprire sendmail: $!\n";
print SENDMAIL <<"EOF";
From: Mittente <tocas\@tocas.homelinux.net>
To: Destinatario <antonio\@tcl.it>
Cc: Copia <tokas\@xlife.it>
Subject: Un oggetto significativo
    
Il corpo del messaggio va qui dopo una linea vuota
Puo` essere lungo quante linee desiderate.
EOF
close(SENDMAIL)     or warn "sendmail non si e` chiuso correttamente";
