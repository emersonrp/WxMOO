#!/usr/bin/perl
use strict;
use Test::More;

BEGIN { use_ok "WxMOO::Window::Main::InputPane"; }


my $window = new_ok('WxMOO::Window::Main::InputPane');

my $cmd_history = new_ok('WxMOO::Window::Main::InputPane::CommandHistory');

### ADD
$cmd_history->add('first');
$cmd_history->add('second');
$cmd_history->add('third');

is($cmd_history->current_entry, '', 'cmdhistory keeps track of additions');

### PREV
$cmd_history->prev;
$cmd_history->prev;
$cmd_history->prev;

is($cmd_history->current_entry, 'first', 'cmdhistory can backtrack');

$cmd_history->prev;

is ($cmd_history->current_entry, 'first', 'cmdhistory knows where the list starts');

### NEXT
$cmd_history->next;
$cmd_history->next;

is($cmd_history->current_entry, 'third', 'cmdhistory can forward-track');

$cmd_history->next;

is($cmd_history->current_entry, '', 'cmdhistory knows where the list ends');

### UPDATE
$cmd_history->update('second-updated');

is ($cmd_history->current_entry, 'second-updated', 'cmdhistory can update');

$cmd_history->prev;

is ($cmd_history->current_entry, 'third', 'cmdhistory puts updates at the end of the list');



done_testing;
