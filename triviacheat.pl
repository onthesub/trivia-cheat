

#!/usr/bin/perl -w
#
# trivia cheater

use Irssi;
use Irssi::Irc;
use Storable;

$VERSION = "0.2";
%IRSSI = (
	authors		=> 'otis',
	name		=> 'triviacheat',
);

my %answerhash;
my $currentq = '';

sub on_public {
	my ($server, $msg, $nick, $addr, $target) = @_;

	$target = $nick if ( ! $target );
	$nick = $server->{'nick'} if ($nick =~ /^#/);
	$target = lc($target);

	my $answer;
	if ($nick =~ /^Trivia/) {
		if ($msg =~ /^[\d]+\./) {
			my $q;

			$msg =~ m/\. (.*)/;
			$q = $1;

			if (exists $answerhash{$q}) {
				Irssi::active_win()->print($answerhash{$q}{'answer'});
			}

			$currentq = $q;
		} elsif ($msg =~ /^Time's up!/) {
			$msg =~ m/answer was: (.*)/;
			$answer = $1;

			$answerhash{$currentq}{'answer'} = $answer;
			#Irssi::active_win->print("answer saved: " . $answerhash{$currentq}{'answer'});
		} elsif ($msg =~ /^Winner:/) {
			$msg =~ m/Answer: (.*); Time:/;
			$answer = $1;

			$answerhash{$currentq}{'answer'} = $answer;
			#Irssi::active_win->print("answer saved: " . $answerhash{$currentq}{'answer'});
		}
	}
}

sub cmd_save {
	store \%answerhash, 'trivia_answers.hash';
}

sub cmd_load {
	$answerhash = retrieve('trivia_answers.hash');
}

# hooks
Irssi::signal_add_last("message public", "on_public");

Irssi::command_bind('tc_load', \&cmd_load);
Irssi::command_bind('tc_save', \&cmd_save);

