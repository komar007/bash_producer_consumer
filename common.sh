queue=$1
lock="$queue".lock

function lock
{
	mkdir "$lock" 2> /dev/null
}

function unlock()
{
	rmdir "$lock"
}
