todo() {
	TODAY=$(date "+%Y-%m-%d")
	TOMORROW=$(date -v+1d "+%Y-%m-%d")
	TODO_DIR=${TODO_DIR_DEFAULT:-"$HOME/todo"}
	case "$3" in
		today|t)
			WHEN=$TODAY
			;;
		tomorrow|tm|tomo)
			WHEN=$TOMORROW
			;;
		*)
			if [[ $3 =~ ^[+-][0-9]+d$ ]]; then
				WHEN=$(date -v$3 "+%Y-%m-%d")
			else
				WHEN=$3
			fi
			;;
	esac
	case "$2" in
		today|t)
			WHEN_VIEW=$TODAY
			;;
		yesterday|y)
			WHEN_VIEW=$(date -v-1d "+%Y-%m-%d")
			;;
		tomorrow|tm|tomo)
			WHEN_VIEW=$TOMORROW
			;;
		week|w)
			DOW=$(date "+%u")
			WHEN_VIEW=""
			for i in {$(($DOW - 1))..0}
			do
				WHEN_VIEW="$WHEN_VIEW$(date -v-${i}d "+%Y-%m-%d")\n"
			done
			for i in {1..$((7 - $dow))}
			do
				WHEN_VIEW="$WHEN_VIEW$(date -v+${i}d "+%Y-%m-%d")\n"
			done
			WHEN_VIEW=$(echo $WHEN_VIEW | uniq | sort)
			;;
		next-week|nw)
			DOW=$(date "+%u")
			NEXT_MON=$((8 - $DOW))
			WHEN_VIEW=""
			for i in {$NEXT_MON..$(($NEXT_MON + 6))}
			do
				WHEN_VIEW="$WHEN_VIEW$(date -v+${i}d "+%Y-%m-%d")\n"
			done
			WHEN_VIEW=$(echo $WHEN_VIEW | uniq | sort)
			;;
		last-week|lw)
			DOW=$(date "+%u")
			LAST_MON=$((6 + $DOW))
			WHEN_VIEW=""
			for i in {$LAST_MON..$(($LAST_MON - 6))}
			do
				WHEN_VIEW="$WHEN_VIEW$(date -v-${i}d "+%Y-%m-%d")\n"
			done
			WHEN_VIEW=$(echo $WHEN_VIEW | uniq | sort)
			;;
		*)
			if [[ $2 =~ ^[+-][0-9]+d$ ]]; then
				WHEN_VIEW=$(date -v$2 "+%Y-%m-%d")
			elif [ -z "$2" ]; then
				WHEN_VIEW=$TODAY
			else
				WHEN_VIEW=$2
			fi
			;;
	esac
	case "$1" in
		add|a)
			WHEN=${WHEN:-$TODAY}
			echo "- [ ] $2" >> "$TODO_DIR/$WHEN.md"
			$0 view "$WHEN"
			;;
		remove|rm)
			WHEN=${WHEN:-$TODAY}
			if [[ $2 =~ '^[0-9]+$' ]] ; then
				sed -i "" "$2d" "$TODO_DIR/$WHEN.md"
			else
				sed -i "" "/^\- \[[ x]\] $2$/d" "$TODO_DIR/$WHEN.md"
			fi
			$0 view "$WHEN"
			;;
		done|d)
			WHEN=${WHEN:-$TODAY}
			if [[ $2 =~ '^[0-9]+$' ]] ; then
				sed -i "" "$2s/^\- \[ \]/- [x]/g" "$TODO_DIR/$WHEN.md"
			else
				sed -i "" "s/^\- \[ \] $2$/- [x] $2/g" "$TODO_DIR/$WHEN.md"
			fi
			$0 view "$WHEN"
			;;
		undone|u)
			WHEN=${WHEN:-$TODAY}
			if [[ $2 =~ '^[0-9]+$' ]] ; then
				sed -i "" "$2s/^\- \[x\]/- [ ]/g" "$TODO_DIR/$WHEN.md"
			else
				sed -i "" "s/^\- \[x\] $2$/- [ ] $2/g" "$TODO_DIR/$WHEN.md"
			fi
			$0 view "$WHEN"
			;;
		help|h)
			echo "Usage:"
			echo "  $0 [CMD] [WHAT] [WHEN]"
			echo ""
			echo "CMD can be:"
			echo "  'add|a' to add element to list"
			echo "  'remove|rm' to remove an element from a list"
			echo "  'view|v' to print the list on stdout"
			echo "  'left|l' to print the items left to do for WHEN"
			echo "  'did' to print the items already did for WHEN"
			echo "  'done|d' or undone|u to mark or unmark the item as done"
			echo "  'carry-on|co' moves yesterday's undone items to today's list"
			echo "  'push' moves todays's undone items to tomorrow's list"
			echo "  'help|h' prints this message"
			echo "If no command is passed, 'view' is assumed."
			echo ""
			echo "WHEN can be:"
			echo "  today|t"
			echo "  tomorrow|tomo|tm"
			echo "  yesterday|y"
			echo "  week|w"
			echo "  next-week|nw"
			echo "  last-week|lw"
			echo "  a temporal interaval referred to today's date (e.g. +2d, -2d etc...)."
			echo "When CMD is 'view', it can also be a string matching the format '%Y-%m-%d' to list all the items in different days. If no WHEN is passed, 'today' is assumed."
			echo ""
			echo "Examples:"
			echo "$ $0 add 'Buy milk'"
			echo "$ $0 rm 'Buy milk'"
			echo "$ $0 view tomorrow"
			echo "$ $0 view 2019-11"
			echo "$ $0 view week"
			echo "$ $0 left today"
			echo "$ $0 did yesterday"
			echo "$ $0 done 'Buy milk' yesterday"
			echo "$ $0 undone|u 'Buy milk' yesterday"
			echo "$ $0 carry-on"
			echo "$ $0 push"
			echo ""
			;;
		view|v)
			echo $WHEN_VIEW | xargs -I __ find "$TODO_DIR" -name "__*.md" -type f -exec basename {} .md \; -exec cat {} \; -exec echo "" \; 2> /dev/null || echo "No todos for __."
			;;
		left|l)
			$0 view "$WHEN_VIEW" | grep -e "^\- \[ \] .*$" -e '^20[0-9][0-9]-[0-9][0-9]-[0-9][0-9]$' -e '^$'
			;;
		did)
			$0 view "$WHEN_VIEW" | grep -e "^\- \[x\] .*$" -e '^20[0-9][0-9]-[0-9][0-9]-[0-9][0-9]$' -e '^$'
			;;
		carry-on|co)
			$0 left yesterday | tail -n +2 | head -n +2 >> "$TODO_DIR/$TODAY.md"
			$0 view today
			;;
		push)
			$0 left today | tail -n +2 | head -n +2 >> "$TODO_DIR/$TOMORROW.md"
			$0 view tomorrow
			;;
		*)
			$0 view today
			;;
	esac
}
