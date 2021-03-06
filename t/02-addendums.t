#! /usr/bin/perl
# Addenda modifiers tester.

#########################

use strict;
use warnings;

my @tests;

mkdir "t/tmp" unless -e "t/tmp";

push @tests, {
	'run'  => 'perl ../po4a-translate -f man -a t-02-addendums/man.addendum1 -m t-02-addendums/man -p t-02-addendums/man.po-ok -l tmp/man.fr',
	'test' => 'diff -u t-02-addendums/man.fr.add1 tmp/man.fr 1>&2',
	'doc'  => 'translate with addendum1'
};

push @tests, {
	'run'  => 'perl ../po4a-translate -f man -a t-02-addendums/man.addendum2 -m t-02-addendums/man -p t-02-addendums/man.po-ok -l tmp/man.fr',
	'test' => 'diff -u t-02-addendums/man.fr.add2 tmp/man.fr 1>&2',
	'doc'  => 'translate with addendum2'
};

push @tests, {
	'run'  => 'perl ../po4a-translate -f man -a t-02-addendums/man.addendum3 -m t-02-addendums/man -p t-02-addendums/man.po-ok -l tmp/man.fr',
	'test' => 'diff -u t-02-addendums/man.fr.add3 tmp/man.fr 1>&2',
	'doc'  => 'translate with addendum3'
};

push @tests, {
	'run'  => 'perl ../po4a-translate -f man -a t-02-addendums/man.addendum4 -m t-02-addendums/man -p t-02-addendums/man.po-ok -l tmp/man.fr',
	'test' => 'diff -u t-02-addendums/man.fr.add4 tmp/man.fr 1>&2',
	'doc'  => 'translate with addendum4'
};

push @tests, {
  'run' => 'perl ../po4a-translate -k 0 -f text -m t-02-addendums/Titles.asciidoc -p t-02-addendums/Titles.po -l tmp/Titles.trans ' .
                '-a t-02-addendums/addendum1 -a t-02-addendums/addendum2 -a t-02-addendums/addendum3',
  'test'=> 'diff -u t-02-addendums/Titles.trans.add123 tmp/Titles.trans 1>&2',
  'doc' => 'translate with addendum1, 2 and 3'
  };

push @tests, {
  'run' => 'perl ../po4a-translate -k 0 -f text -m t-02-addendums/Titles.asciidoc -p t-02-addendums/Titles.po -l tmp/Titles.trans ' .
                '-a @t-02-addendums/addendum123.list',
  'test'=> 'diff -u t-02-addendums/Titles.trans.add123 tmp/Titles.trans 1>&2',
  'doc' => 'translate with @addendum'
  };

push @tests, {
  'run' => 'perl ../po4a-translate -k 0 -f text -m t-02-addendums/Titles.asciidoc -p t-02-addendums/Titles.po -l tmp/Titles.trans ' .
                '-a !t-02-addendums/addendum2 -a @t-02-addendums/addendum123.list',
  'test'=> 'diff -u t-02-addendums/Titles.trans.add13 tmp/Titles.trans 1>&2',
  'doc' => 'translate with !addendum'
  };

push @tests, {
  'run' => 'perl ../po4a-translate -k 0 -f text -m t-02-addendums/Titles.asciidoc -p t-02-addendums/Titles.po -l tmp/Titles.trans ' .
                '-a ?/does/not/exist',
  'test'=> 'diff -u t-02-addendums/Titles.asciidoc tmp/Titles.trans 1>&2',
  'doc' => 'translate with non-existing ?addendum'
  };

push @tests, {
  'run' => 'perl ../po4a-translate -k 0 -f text -m t-02-addendums/Titles.asciidoc -p t-02-addendums/Titles.po -l tmp/Titles.trans ' .
                '-a @t-02-addendums/addendum123.list2',
  'test'=> 'diff -u t-02-addendums/Titles.trans.add1 tmp/Titles.trans 1>&2',
  'doc' => 'translate with recursive @addendum'
  };

push @tests, {
  'run' => 'perl ../po4a -f t-02-addendums/test0.conf',
  'test'=> 'diff -u t-02-addendums/Titles.trans.add123 tmp/Titles.trans 1>&2',
  'doc' => '(po4a) translate with addendum1, 2 and 3'
  };

push @tests, {
  'run' => 'perl ../po4a -f t-02-addendums/test1.conf',
  'test'=> 'diff -u t-02-addendums/Titles.trans.add123 tmp/Titles.trans 1>&2',
  'doc' => '(po4a) translate with @addendum'
  };

push @tests, {
  'run' => 'perl ../po4a -f t-02-addendums/test2.conf',
  'test'=> 'diff -u t-02-addendums/Titles.trans.add13 tmp/Titles.trans 1>&2',
  'doc' => '(po4a) translate with !addendum'
  };

push @tests, {
  'run' => 'perl ../po4a -f t-02-addendums/test3.conf',
  'test'=> 'diff -u t-02-addendums/Titles.asciidoc tmp/Titles.trans 1>&2',
  'doc' => '(po4a) translate with non-existing ?addendum'
  };

push @tests, {
  'run' => 'perl ../po4a -f t-02-addendums/test4.conf',
  'test'=> 'diff -u t-02-addendums/Titles.trans.add1 tmp/Titles.trans 1>&2',
  'doc' => '(po4a) translate with recursive @addendum'
  };

use Test::More tests => 14*3; # tests * (run+dos2unix+validity)

for (my $i=0; $i<scalar @tests; $i++) {
    chdir "t" || die "Can't chdir to my test directory";

    my ($val,$name);

    my $cmd=$tests[$i]{'run'};
    $val=system($cmd);

    $name=$tests[$i]{'doc'}.' runs';
    ok($val == 0,$name);
    diag(%{$tests[$i]{'run'}}) unless ($val == 0);

    SKIP: {
        skip ("Command don't run, can't test the validity of its return",1)
            if $val;
	
	$val = system("dos2unix -q tmp/*"); # Just in case this is Windows
	is($val,0, "dos2unix did not went well");
	
	$name=$tests[$i]{'doc'}.' returns what is expected';
        $val=system($tests[$i]{'test'});
        ok($val == 0, $name);
        unless ($val == 0) {
	    diag ("------------------------");
            diag ("'".$tests[$i]{'test'}."' failed (retval=$val) on:");
            diag ("Files were created with:");
            diag ($tests[$i]{'run'});
            my $add = $tests[$i]{'run'};
	    if ($add =~ m/-a/) {
		$add =~ s/.*-a [!@]?(\S*).*/$1/;
		$add = `cat $add | head -n 1`;
		diag ("Addendum header was: $add");
	    } else {
		diag ("Unable to find the addendum header");
	    }
	    diag ("------------------------");
        }
    }

    system("rm -f tmp/* 2>&1");

    chdir ".." || die "Can't chdir back to my root";
}

0;
