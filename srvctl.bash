# bash completion support for srvctl 12cR1
# vim: ts=4:sw=4:filetype=sh:cc=81

# Copyright (C) 2016 Philippe Leroux <philippe.lrx@gmail.com>
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

#	============================================================================
#	Pour mémo :
#		COMP_WORDS	is an array of words in the current command line.
#		COMP_CWORD	is the index of the current word in the command line.
#		COMPREPLY	is a list of replies.
#	============================================================================

#	srvctl <command> <object> [<options>]
#	COMP_WORD[0] == srvctl
#	COMP_WORD[1] == command
#	COMP_WORD[2] == object
#	COMP_WORD[3] == first option
typeset	-ri	icommand=1
typeset	-ri	iobject=2
typeset	-ri	ifirstoption=3

typeset -r	command_list="enable disable start stop status add remove modify
						update getenv setenv unsetenv config upgrade downgrade"

# Global variables built dynamically
#	object_list : contain all objects.
#	count_nodes : number of nodes.

#	Work only with : export SRVCTL_LOG=yes
function _log
{
	if [ "$SRVCTL_LOG" == yes ]
	then # One log per user.
		echo "$@" >> /tmp/srvctl_completion_${USER}.log
	fi
}

#	return 0 if cluster, 1 if standalone server
function _is_cluster
{
	[ ! -v count_nodes ] && typeset	-rgi count_nodes=$(wc -l<<<"$(olsnodes)") || true
	[ $count_nodes -gt 1 ] && return 0 || return 1
}

#	print to stdout dbname index in COMP_WORDS, -1 if not found.
function _get_dbname_index
{
	for i in $( seq $ifirstoption ${#COMP_WORDS[@]} )
	do
		if [[ ${COMP_WORDS[i]} == "-db" || ${COMP_WORDS[i]} == "-database" ]]
		then
			[ x"${COMP_WORDS[i+1]}" == x ] && echo -1 || echo $(( i + 1 ))
			return 0
		fi
	done

	echo -1
}

#	build the reply : COMPREPLY is set.
function _reply
{
	COMPREPLY=( $( compgen -W "$@" -- ${COMP_WORDS[COMP_CWORD]} ) )
}

# Generated by script : all_objects_for_cmd.sh
# Built object_list for current command
# srvctl version: 12.1.0.2.0
function _reply_with_object_list_cluster
{
	case "$command" in
		relocate)
			typeset -g object_list="database service server vip scan scan_listener oc4j rhpserver rhpclient gns cvu mgmtdb filesystem asm havip"
			;;
		downgrade)
			typeset -g object_list="database"
			;;
		export)
			typeset -g object_list="gns"
			;;
		stop)
			typeset -g object_list="database instance service nodeapps vip asm listener scan scan_listener oc4j rhpserver rhpclient havip exportfs home filesystem volume diskgroup gns cvu mgmtdb mgmtlsnr mountfs"
			;;
		import)
			typeset -g object_list="gns"
			;;
		add)
			typeset -g object_list="database instance service service nodeapps vip network asm listener scan scan_listener srvpool oc4j rhpserver rhpclient havip exportfs filesystem gns cvu mgmtdb mgmtlsnr mountfs"
			;;
		start)
			typeset -g object_list="database instance service nodeapps vip asm listener scan scan_listener oc4j rhpserver rhpclient havip exportfs home filesystem volume diskgroup gns cvu mgmtdb mgmtlsnr mountfs"
			;;
		status)
			typeset -g object_list="database instance service nodeapps vip listener asm scan scan_listener srvpool server oc4j rhpserver rhpclient home filesystem volume diskgroup cvu gns mgmtdb mgmtlsnr exportfs havip mountfs"
			;;
		remove)
			typeset -g object_list="database instance service nodeapps vip network asm listener scan scan_listener srvpool oc4j rhpserver rhpclient havip exportfs filesystem diskgroup gns cvu mgmtdb mgmtlsnr mountfs"
			;;
		config)
			typeset -g object_list="database service nodeapps vip network asm listener scan scan_listener srvpool oc4j rhpserver rhpclient filesystem volume gns cvu exportfs mgmtdb mgmtlsnr mountfs"
			;;
		predict)
			typeset -g object_list="database service asm diskgroup filesystem vip network listener scan scan_listener oc4j"
			;;
		unsetenv)
			typeset -g object_list="database nodeapps vip listener asm mgmtdb mgmtlsnr"
			;;
		upgrade)
			typeset -g object_list="database"
			;;
		setenv)
			typeset -g object_list="database nodeapps vip listener asm mgmtdb mgmtlsnr"
			;;
		enable)
			typeset -g object_list="database instance service asm listener nodeapps vip scan scan_listener oc4j rhpserver rhpclient filesystem volume diskgroup gns cvu mgmtdb mgmtlsnr exportfs havip mountfs"
			;;
		disable)
			typeset -g object_list="database instance service asm listener nodeapps vip scan scan_listener oc4j rhpserver rhpclient filesystem volume diskgroup gns cvu mgmtdb mgmtlsnr exportfs havip mountfs"
			;;
		convert)
			typeset -g object_list="database database"
			;;
		getenv)
			typeset -g object_list="database nodeapps vip listener asm mgmtdb mgmtlsnr"
			;;
		modify)
			typeset -g object_list="database instance service service service service asm nodeapps listener network scan scan_listener srvpool oc4j rhpserver rhpclient filesystem gns cvu mgmtdb mgmtlsnr exportfs havip mountfs"
			;;
		update)
			typeset -g object_list="listener scan_listener database mgmtdb instance gns"
			;;
		*)
			_log "$command not supported."
			typeset -g object_list=""
	esac
}

# Generated by script : all_objects_for_cmd.sh
# Built object_list for current command
# srvctl version: 12.1.0.2.0
function _reply_with_object_list_standalone
{
	case "$command" in
		downgrade)
			typeset -g object_list="database"
			;;
		stop)
			typeset -g object_list="database service asm listener diskgroup ons home"
			;;
		add)
			typeset -g object_list="database service asm listener ons"
			;;
		start)
			typeset -g object_list="database service asm listener diskgroup ons home"
			;;
		status)
			typeset -g object_list="database service asm listener diskgroup ons home"
			;;
		remove)
			typeset -g object_list="database service asm listener diskgroup ons"
			;;
		config)
			typeset -g object_list="database service asm listener ons"
			;;
		unsetenv)
			typeset -g object_list="database asm listener"
			;;
		upgrade)
			typeset -g object_list="database"
			;;
		setenv)
			typeset -g object_list="database asm listener"
			;;
		enable)
			typeset -g object_list="database service asm listener diskgroup ons"
			;;
		disable)
			typeset -g object_list="database service asm listener diskgroup ons"
			;;
		getenv)
			typeset -g object_list="database asm listener"
			;;
		modify)
			typeset -g object_list="database service asm listener ons"
			;;
		update)
			typeset -g object_list="database"
			;;
		*)
			_log "$command not supported."
			typeset -g object_list=""
	esac
}

#	init global variable object_list with all objects for the current command.
#	reply with object_list
function _reply_with_object_list
{
	if _is_cluster
	then
		_reply_with_object_list_cluster
	else
		_reply_with_object_list_standalone
	fi

	_reply "$object_list"
}

#	$@	option_list
#	print to stdout option_list with used options removed.
function _remove_used_options
{
	typeset	option_list="$@"

	for i in $( seq $ifirstoption ${#COMP_WORDS[@]} )
	do
		if [[ $i -ne $COMP_CWORD && "$option_list" == *"${COMP_WORDS[i]}"* ]]
		then
			option_list=${option_list/${COMP_WORDS[i]}/}
		fi
	done

	echo $option_list
}

#	return 0 if $1 is used in COMP_WORDS, else return 1
function _option_is_used
{
	typeset	-r opt="$1"

	typeset i
	for i in $( seq $ifirstoption ${#COMP_WORDS[@]} )
	do
		[ "$opt" == "${COMP_WORDS[i]}" ] && return 0 || true
	done

	return 1 # not found
}

#	Ex : srvctl stop service -db db_name [-node | -instance]
#	You can use -node or -instance, together it's an error.
#
#	exclusive_options must contains the exclusives options.
#	$1 list options
#	print new list options to stdout.
function _remove_exclusive_options
{
	typeset	option_list="$@"

	typeset option
	for option in $exclusive_options
	do
		if _option_is_used "$option"
		then
			typeset o2r	# option to removed.
			for o2r in ${exclusive_options/$option/}
			do	# cannot use option $o2r with $option, remove it.
				option_list=${option_list/$o2r/}
			done
			break # no need to iterate more.
		fi
	done

	echo "$option_list"
}

#	$1 option_list
#	before to reply :
#		- remove options already in use.
#		- if exclusive_options is set, removes the exclusives options.
function _reply_with_options
{
	typeset	option_list="$@"

	if [ $COMP_CWORD -ne $ifirstoption ]
	then
		option_list="$(_remove_used_options $option_list)"
		if [ -v exclusive_options ]
		then
			_log "_reply_with_options : exclusive options '$exclusive_options'"
			option_list="$(_remove_exclusive_options $option_list)"
		fi
	fi

	_reply "$option_list"
}

#	============================================================================
#	Callback functions : _reply_with_[option]_list (option without dash)
#	return values for an option.

function _reply_with_database_list
{
	_reply "$(crsctl stat res	|\
					grep "\.db$" | sed "s/NAME=ora\.\(.*\).db/\1/g" | xargs)"
}

function _reply_with_diskgroup_list
{
	_reply	"$(crsctl stat res		|\
					grep -E "ora.*.dg$"	|\
					sed "s/NAME=ora.\(.*\).dg/\1/g" | xargs)"
}

function _reply_with_listener_list
{
	#	For RAC database we must exclude listener for scan vips.
	_reply	"$(crsctl stat res				|\
					grep -E "NAME=ora.*.lsnr$"	|\
					grep -v "SCAN"				|\
					sed "s/NAME=ora.\(.*\).lsnr/\1/g" | xargs)"
}

function _reply_with_oraclehome_list
{
	_reply	"$(cat /etc/oratab			|\
					grep -E "^(\+|[A-Z])"	|\
					sed "s/.*:\(.*\):[Y|N].*/\1/g" | xargs)"
}

function _reply_with_vip_list
{
	_reply	"$(crsctl stat res				|\
					grep -E "NAME=ora.*.vip$"	|\
					grep -v "scan"				|\
					sed "s/NAME=ora.\(.*\).vip/\1/g" | xargs)"
}

function _reply_with_netnum_list
{
	typeset -i count_net=$(crsctl stat res|grep -E "\.network$"|wc -l)

	_reply "{1..$count_net}"
}

function _reply_with_scannumber_list
{
	_reply_with_options "1 2 3"
}

function _reply_with_node_number_list
{
	[ ! -v count_nodes ] && _is_cluster || true

	_reply "{1..$count_nodes}"
}

function _reply_with_startconcurrency_list
{
	_reply_with_node_number_list
}

function _reply_with_stopconcurrency_list
{
	_reply_with_node_number_list
}

function _reply_with_node_list
{
	_reply "$(olsnodes | xargs)"
}

function _reply_with_servers_list
{
	_reply_with_node_list
}

function _reply_with_service_list
{
	typeset	-ri idbname=$(_get_dbname_index)
	if [ $idbname -eq -1 ]
	then # return all services
		_reply "$(crsctl stat res			|\
						grep -E "ora.*.svc$"	|\
						sed "s/NAME=ora\.\(.*\)\.svc/\1/g" | xargs)"
	else # return services for specified database.
		typeset -r dbname=$(tr [:upper:] [:lower:]<<<"${COMP_WORDS[idbname]}")
		_reply "$(crsctl stat res						|\
						grep -Ei "ora.$dbname.*.svc$"		|\
						sed "s/NAME=ora\.${dbname}\.\(.*\)\.svc/\1/g" | xargs)"
	fi
}

function _reply_with_instance_list
{
	typeset	-ri idbname=$(_get_dbname_index)
	if [ $idbname -eq -1 ]
	then
		COMPREPLY=()
		return 0
	fi

	if [ -v instance_list ]
	then
		if [ $(( SECONDS - tt_instance_list )) -lt 60 ]
		then
			_reply "$instance_list"
			return 0
		fi
		# cache to old.
	fi

	typeset	cmd="srvctl status database -db ${COMP_WORDS[idbname]}"
	cmd="$cmd | sed 's/Instance \(.*\) is.*/\1/g' | xargs"
	_log "cmd='$cmd'"

	typeset -g	instance_list="$(eval $cmd)"
	typeset	-gi	tt_instance_list=$SECONDS

	_reply "$instance_list"
}

function _reply_with_startoption_list
{
	_reply "open mount read"
}

function _reply_with_stopoption_list
{
	_reply "normal transactional immediate abort"
}

function _reply_with_statefile_list
{	# user must provide a file name.
	COMPREPLY=()
}

function _reply_with_volume_list
{	# user must provide Volume name
	COMPREPLY=()
}

function _reply_with_device_list
{	# user must provide Volume device path
	COMPREPLY=()
}

function _reply_with_name_list
{	# user must provide a name
	COMPREPLY=()
}

function _reply_with_id_list
{	# user must provide unique ID for 'havip'
	COMPREPLY=()
}

#	End callback functions.
#	============================================================================

#	$1 option name, must begin with a dash.
#	$2 list of valid options.
#		Must exist a callback function like _reply_with_[option]_list, the dash
#		is removed from the option name before the call.
#		-db is translated to -database and -s is translated to -service
#	return 0 if reply done, else return 1.
function _reply_for_option
{
	typeset		option="$1"
	[ "${option:0:1}" != "-" ] && return 1 || shift

	typeset	-r	valid_options="$@"

	_log "_reply_for_option : test if '$option' in '$valid_options'"
	typeset w
	for w in $valid_options
	do
		_log "_reply_for_option : $w == $option ?"
		if [ "$w" == "$option" ]
		then
			case $option in
				-s)
					option="-service"
					;;
				-db)
					option="-database"
					;;
			esac
			_log "_reply_for_option : call _reply_with_${option:1}_list"
			_reply_with_${option:1}_list
			return 0
		fi
	done

	_log "_reply_for_option : not found"
	return 1
}

#	============================================================================
#	Callback functions for commands, 2 functions per command.

#	reply for command status
function _reply_for_cmd_status
{
	case "$object_name" in
		database)
			typeset exclusive_options="-db -serverpool -thisversion -thishome"
			if _is_cluster
			then
				_reply_with_options "-db -serverpool -thisversion -thishome
										-force -verbose"
			else
				_reply_with_options "-db -thisversion -thishome
										-force -verbose"
			fi
			;;

		instance)
			typeset exclusive_options="-instance -node"
			#	TODO : standalone CRS
			_reply_with_options "-db -node -instance -force -verbose"
			;;

		service)
			_reply_with_options "-db -service -force -verbose"
			;;

		nodeapps)
			_reply "-node"
			;;

		vip)
			_reply_with_options "-node -vip -verbose"
			;;

		listener)
			_reply_with_options "-listener -verbose"
			;;

		asm)
			_reply_with_options "-detail -verbose"
			;;

		scan|scan_listener)
			typeset exclusive_options="-netnum -scannumber"
			_reply_with_options "-netnum -scannumber -all -verbose"
			;;

		srvpool)
			_log "todo _reply_for_cmd_status $@"
			;;

		server)
			_reply_with_options "-servers -detail"
			;;

		oc4j)
			_reply_with_options "-node -verbose"
			;;

		rhpserver)
			COMPREPLY=()
			;;

		rhpclient)
			COMPREPLY=()
			;;

		home)
			if _is_cluster
			then
				_reply_with_options "-node -oraclehome -statefile"
			else
				_reply_with_options "-oraclehome -statefile"
			fi
			;;

		filesystem)
			_reply_with_options "-device -verbose"
			;;

		volume)
			#	TODO : standalone CRS
			_reply_with_options "-volume -diskgroup -device -node -all"
			;;

		diskgroup)
			if _is_cluster
			then
				_reply_with_options "-diskgroup -node -detail -verbose"
			else
				_reply_with_options "-diskgroup -detail -verbose"
			fi
			;;

		cvu)
			_reply_with_options "-node"
			;;

		gns)
			_reply_with_options "-node -verbose"
			;;

		mgmtdb)
			_reply_with_options "-verbose"
			;;

		mgmtlsnr)
			_reply_with_options "-verbose"
			;;

		exportfs)
			_reply_with_options "-name -id"
			;;

		havip)
			_reply_with_options "-id"
			;;

		mountfs)
			_reply_with_options "-name"
			;;

		ons)
			_reply_with_options "-verbose"
			;;

		*)
			_log "error object '$object_name' unknow."
			COMPREPLY=()
			;;
	esac
}

#	next reply for command status (after the first option)
function _next_reply_for_cmd_status
{
	typeset		exclusive_options="-node -instance"

	# Provide all possible options, don't worry about previous options.
	typeset	-r	valid_options="-diskgroup -db -database -service -s -listener
						-oraclehome -node -servers -instance -vip -scannumber
						-netnum"

	if ! _reply_for_option "$prev_word" "$valid_options"
	then
		_reply_for_cmd_status
	fi
}

#	reply for command start
function _reply_for_cmd_start
{
	case "$object_name" in
		database)
			if _is_cluster
			then
				# -node only for RAC On Node
				# -eval for policy managed
				_reply_with_options "-db -startoption -startconcurrency
									-eval -verbose"
			else
				_reply_with_options "-db -startoption -verbose"
			fi
			;;

		instance) # cluster only
			_reply_with_options "-db -node -instance -startoption"
			;;

		service)
			if _is_cluster
			then
				typeset exclusive_options="-node -instance"
				# Cannot add -service -startoption !
				#	exclusive_options must became an associative array !
				_reply_with_options "-db -service -serverpool -node -instance
									-pq -global_override -startoption -eval
									-verbose"
			else
				typeset exclusive_options="-service -startoption"
				_reply_with_options "-db -service -startoption -global_override
									verbose"
			fi
			;;

		asm)
			if _is_cluster
			then
				_reply_with_options "-startoption -force -proxy -node"
			else
				_reply_with_options "-startoption -force"
			fi
			;;

		listener)
			if _is_cluster
			then
				_reply_with_options "-listener -force"
			else
				_reply_with_options "-listener"
			fi
			;;

		diskgroup)
			if _is_cluster
			then
				_reply_with_options "-diskgroup -node"
			else
				_reply_with_options "-diskgroup"
			fi
			;;

		ons) # standalone only
			_reply_with_options "-verbose"
			;;

		home)
			if _is_cluster
			then
				_reply_with_options "-oraclehome -statefile -node"
			else
				_reply_with_options "-oraclehome -statefile"
			fi
			;;

		exportfs)
			_reply_with_options "-name -id"
			;;

		mgmtlsnr)
			_reply_with_options "-node"
			;;

		rhpclient)
			_reply "-node"
			;;

		cvu)
			_reply_with_options "-node"
			;;

		filesystem)
			_reply_with_options "-device -node"
			;;

		mountfs)
			_reply_with_options "-name -node"
			;;

		rhpserver)
			_reply "-node"
			;;

		vip)
			_reply_with_options "-node -vip -netnum -relocate -verbose"
			;;

		gns)
			_reply_with_options "-loglevel -node -verbose"
			;;

		nodeapps)
			_reply_with_options "-node -adminhelper -onsonly -verbose"
			;;

		scan)
			typeset exclusive_options="-netnum -scannumber"
			_reply_with_options "-netnum -scannumber -node"
			;;

		volume)
			_reply_with_options "-volume -diskgroup -device -node"
			;;

		havip)
			_reply_with_options "-id -node"
			;;

		mgmtdb)
			_reply_with_options "-startoption -node"
			;;

		oc4j)
			_reply_with_options "-node -verbose"
			;;

		scan_listener)
			typeset exclusive_options="-netnum -scannumber"
			_reply_with_options "-netnum -scannumber -node"
			;;

		*)
			_log "_reply_for_cmd_start $object_name : todo"
			COMPREPLY=()
			;;
	esac
}

#	next reply for command start (after the first option)
function _next_reply_for_cmd_start
{
	# Provide all possible options, don't worry about previous options.
	typeset	-r	valid_options="-db -database -instance -service
								-startconcurrency -node -startoption
								-oraclehome -listener -diskgroup -vip -netnum
								-scannumber -statefile -volume -device
								-name -id"

	if ! _reply_for_option $prev_word "$valid_options"
	then
		case "$prev_word" in
			read)
				COMPREPLY=( only )
				;;

			-loglevel) # Callback ?
				_reply_with_options "{1..6}"
				;;

			*)
				_reply_for_cmd_start
		esac
	fi
}

#	reply for command stop
function _reply_for_cmd_stop
{
	case "$object_name" in
		database)
			if _is_cluster
			then
				# -node only for RAC On Node
				# -eval for policy managed
				_reply_with_options "-db -stopoption -stopconcurrency
									-force -eval -verbose"
			else
				_reply_with_options "-db -stopoption -force -verbose"
			fi
			;;

		instance)	# cluster only
			_reply_with_options "-db -node -instance -stopoption -force
								-failover"
			;;

		service)
			if _is_cluster
			then
				_reply_with_options "-db -service -serverpool -node -instance
									-pq -global_override -force -noreplay
									-eval -verbose"
			else
				_reply_with_options "-db -service -global_override -force
									-verbose"
			fi
			;;

		asm)
			if _is_cluster
			then
				_reply_with_options "-stopoption -force -proxy -node"
			else
				_reply_with_options "-stopoption -force"
			fi
			;;

		listener)
			if _is_cluster
			then
				_reply_with_options "-listener -node -force"
			else
				_reply_with_options "-listener -force"
			fi
			;;

		diskgroup)
			if _is_cluster
			then
				_reply_with_options "-diskgroup -force -node"
			else
				_reply_with_options "-diskgroup -force"
			fi
			;;

		ons) # only on standalone.
			_reply_with_options "-verbose"
			;;

		home)
			if _is_cluster
			then
				_reply_with_options "-oraclehome -statefile -stopoption -force
									-node"
			else
				_reply_with_options "-oraclehome -statefile -stopoption -force"
			fi
			;;

		exportfs)
			_reply_with_options "-name -id -force"
			;;

		mgmtlsnr)
			_reply_with_options "-node -force"
			;;

		rhpclient)
			COMPRELY=()
			;;

		cvu)
			_reply_with_options "-force"
			;;

		filesystem)
			_reply_with_options "-device -node -force"
			;;

		mountfs)
			_reply_with_options "-name -node -force"
			;;

		rhpserver)
			COMPRELY=()
			;;

		vip)
			_reply_with_options "-node -vip -netnum -relocate -force -verbose"
			;;

		gns)
			_reply_with_options "-node -force -verbose"
			;;

		nodeapps)
			_reply_with_options "-node -relocate -adminhelper -onsonly -force
								-verbose"
			;;

		scan)
			typeset exclusive_options="-netnum -scannumber"
			_reply_with_options "-netnum -scannumber -force"
			;;

		volume)
			_reply_with_options "-volume -diskgroup -device -node -force"
			;;

		havip)
			_reply_with_options "-id -node -force"
			;;

		mgmtdb)
			_reply_with_options "-stopoption -force"
			;;

		oc4j)
			_reply_with_options "-force -verbose"
			;;

		scan_listener)
			typeset exclusive_options="-netnum -scannumber"
			_reply_with_options "-netnum -scannumber -force"
			;;

		*)
			_log "_reply_for_cmd_stop $object_name : todo"
			COMPREPLY=()
			;;
	esac
}

#	next reply for command stop (after the first option)
function _next_reply_for_cmd_stop
{
	# Provide all possible options, don't worry about previous options.
	typeset	-r	valid_options="-db -database -instance -service
								-stopconcurrency -node -stopoption -serverpool
								-oraclehome -listener -diskgroup -vip -netnum
								-scannumber -statefile -volume -device
								-name -id"

	_log "_next_reply_for_cmd_stop : prev_word = '$prev_word'"
	if ! _reply_for_option $prev_word "$valid_options"
	then
		case "$prev_word" in
			transactional)
				case "$object_name" in
					instance|database)
						_reply "local"
						;;
					*)
						_reply_for_cmd_stop
						;;
				esac
				;;

			*)
				_reply_for_cmd_stop
		esac
	fi
}

#	reply for command config
function _reply_for_cmd_config
{
	case "$object_name" in
		database)
			if _is_cluster
			then
				_reply_with_options "-db -serverpool -all -verbose"
			else
				_reply_with_options "-db -all -verbose"
			fi
			;;

		service)
			if _is_cluster
			then
				_reply_with_options "-db -serverpool -service -verbose"
			else
				_reply_with_options "-db -service -verbose"
			fi
			;;

		asm)
			if _is_cluster
			then
				_reply_with_options "-proxy -detail"
			else
				_reply_with_options "-all"
			fi
			;;

		listener)
			if _is_cluster
			then
				typeset exclusive_options="-listener -asmlistener -leaflistener"
				_reply_with_options "-listener -asmlistener -leaflistener -all"
			else
				_reply_with_options "-listener"
			fi
			;;

		cvu)
			COMP_REPLY=()
			;;

		ons) # only standalone
			COMP_REPLY=()
			;;

		filesystem)
			_reply_with_options "-device"
			;;

		mgmtlsnr)
			_reply_with_options "-all"
			;;

		oc4j)
			COMPREPLY=()
			;;

		scan_listener)
			typeset exclusive_options="-netnum -scannumber"
			_reply_with_options "-netnum -scannumber -all"
			;;

		volume)
			_reply_with_options "-volume -diskgroup -device"
			;;

		gns)
			_reply_with_options "-detail -subdomain -multicastport -node -port
								-network -status -version -query -list
								-clusterguid -clustername -clustertype
								-loglevel -verbose"
			;;

		mountfs)
			_reply_with_options "-name"
			;;

		rhpclient)
			COMPRELY=()
			;;

		network)
			_reply_with_options "-netnum"
			;;

		rhpserver)
			COMPRELY=()
			;;

		srvpool)
			_reply_with_options "-serverpool"
			;;

		exportfs)
			_reply_with_options "-name -id"
			;;

		mgmtdb)
			_reply_with_options "-verbose -all"
			;;

		nodeapps)
			_reply_with_options "-viponly -onsonly"
			;;

		scan)
			typeset exclusive_options="-netnum -scannumber"
			_reply_with_options "-netnum -scannumber -all"
			;;

		vip)
			_reply_with_options "-node -vip"
			;;

		*)
			_log "_reply_for_cmd_config $object_name : todo"
			COMPREPLY=()
			;;
	esac
}

#	next reply for command config (after the first option)
function _next_reply_for_cmd_config
{
	typeset	-r	valid_options="db -database -s -service -listener -device
								-netnum -scannumber -volume -diskgroup -device
								-name -netnum -name -id -vip"

	if ! _reply_for_option $prev_word "$valid_options"
	then
		case "$prev_word" in
			-serverpool)	# Must provide server pool name
				COMPREPLY=()
				;;

			*)
			_reply_for_cmd_config
			;;
		esac
	fi
}

#	End callback functions for command.
#	============================================================================

function _srvctl_complete
{
	#	Variables read by all called functions		############################
	typeset	-r	prev_word="${COMP_WORDS[COMP_CWORD-1]}"
	typeset -r	command=${COMP_WORDS[icommand]}
	typeset -r	object_name=${COMP_WORDS[iobject]}
	#	########################################################################

	typeset -r	supported_cmd="status start stop config"

	#	srvctl <command> <object> firstoption ...
	_log
	_log "${COMP_WORDS[*]}"
	_log "command       : $command"
	_log "object        : $object_name"
	_log "first option  : ${COMP_WORDS[ifirstoption]}"
	_log "cur_word      : ${COMP_WORDS[COMP_CWORD]}"
	_log "prev_word     : $prev_word"
	_log "COMP_CWORD    : $COMP_CWORD"

	if [[ "$prev_word" == "srvctl" ]]
	then # srvctl TAB
		_reply "${command_list}"
	elif [[ "$command_list" == *"$prev_word"* ]]
	then # srvctl <command> TAB
		_reply_with_object_list
	elif [[ "$object_list" == *"$prev_word"* ]]
	then # srvctl <command> <object> TAB
		if [[ "$supported_cmd" == *"$command"* ]]
		then
			_reply_for_cmd_${command}
		else
			_log "TODO : command '$command' not supported."
		fi
	else # srvctl <command> <object> opt1 opt2 ... TAB
		if [[ "$supported_cmd" == *"$command"* ]]
		then
			_next_reply_for_cmd_${command}
		else
			_log "TODO : command '$command' not supported."
		fi
	fi

	_log "COMPREPLY : '${COMPREPLY[*]}'"
}

complete -F _srvctl_complete srvctl
