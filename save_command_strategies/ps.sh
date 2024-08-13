#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PANE_PID="$1"

exit_safely_if_empty_ppid() {
	if [ -z "$PANE_PID" ]; then
		exit 0
	fi
}

full_command() {
	# normally the PID is a shell. return the child that has an associated controlling terminal.
	child=$(ps -ao "ppid,args" |
		sed "s/^ *//" |
		grep "^${PANE_PID}" |
		cut -d' ' -f2-)
	if [ "$child" ]; then
		printf %s "$child"
		return
	fi
	# if this command was spawned with `tmux split-pane`, it has no parent shell.
	# just return the args for the PID itself.
	ps -p "${PANE_PID}" -o args | tail -n +2
}

main() {
	exit_safely_if_empty_ppid
	full_command
}
main
