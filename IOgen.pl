#!/usr/bin/perl

$|=1;

#### tune things here

$mydir = '/IO';
$maxforks = 50;


## examples of files sizes for given lines per file

#### 20,000 is 1MB
#### 100,000 is 5MB
#### 2,000,000 is 100MB
#### 20,000,000 is 1GB

$linesPerFile = 100000;

#### dont tune below here

$start = time;
$forknum = 1;
@garbage = qw(
	jlkhasgdfiluqwefbasdfkjasghdfkjhqwefkgyasmvzbncvjkasdhf
	twehbvgasdjliquweflkjascamnabskfjhgukyqwefjkhgasdjbcfnh
	KUGFDWGFGVASDJFWKTYKJACGXCKAHDGKQWEDFHGGASDGHJKJHGGWETU
	BMNBXHGCVWEIUYROIUQWEYWQUEIOQIWUEYIQWUEYOIUQWEYOIYDSAGH
	MNHBVgfkjhgutyetrewASDFASDFcvbncvbnUIOYIOhgfjhgfxcbcnbv
	kugy13ri87awckhgo871r3iuhadilhuo9qlihuwefhp9qefhiub,jsd
);

$SIG{CHLD} = 'IGNORE';

$rc = system("mkdir $mydir");
unless ($rc) { print "could not mkdir $mydir, exiting\n"; }


while ($forknum < $maxforks) {

print "forking number $forknum\n";
$forknum++;

defined(my $childpid = fork) || die "could not fork";

   unless ($childpid) { ## start child code
	srand;
	$filename = 'IO' . int(rand 10000);
	print "my pid is $$ and my filename is $filename\n";
	open MYHAND, ">${mydir}/$filename";
	$linecount = 1;
	while ($linecount < $linesPerFile) {
		$whichline = rand 5;
		print MYHAND $garbage[$whichline], "\n";
		$linecount++;
	}
	close MYHAND;
	exit;

   }                    ## end child code


}

# now wait for all children to exit

while ((my $pid = wait) != -1) {
 }

$end = time;
$delta = $end - $start;
print "this run took $delta seconds\n";
