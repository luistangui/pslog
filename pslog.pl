use File::stat;
use Time::localtime;

my $proc = '/proc/';

print "pslog v1.0 - Process Logger\n\n";
print "Creation Date \t \t  Process ID  \t User \t \t Group \t \t Command\n";

opendir(my $dh,$proc)|| die "can't open Process List";

#Getting all directories/files on /proc/ with only numbers as dirname/filename
while(readdir($dh)){
	info($_) if $_ =~ /\d+/;	
}
closedir($dh);

sub info{
	$pid = $_;
	if($pid){
		my $process = stat($proc.$pid.'/cmdline'); #Getting stats from cmdline file.
		$uid, $gid = $process->uid, $process->gid; #Getting uid and gid from cmdline stats.
		$ctime = ctime($process->ctime);#Getting creation time from cmdline.
		$user, $group = getpwuid($uid), getgrgid($gid);
		open(my $f,'<:encoding(UTF-8)',$proc.$pid.'/cmdline');
		$cmd = <$f> =~ s/\0/ /r; #Removing Nullbytes from cmdline content before print.
		print "$ctime  pid=$pid \t uid=$uid/$user \t gid=$gid/$group \t $cmd\n";
	
	}
}
