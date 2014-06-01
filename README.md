bash_producer_consumer
======================

Producer-consumer pattern implementation in bash

Usage
-----

In these examples `queue_filename` is the name of a text file which will be used to keep the job queue.

### Start a consumer:

    ./consumer queue_filename consumer_id worker
    
where:.
* `consumer_id` is this consumer's unique identifier for this queue,
* `worker` is the name of program/script which performs the job; it will be passed the job to perform using command-line arguments.

### Enqueue a job to be performed by consumers:

    ./enqueue queue_filename [arg1[ arg2][...]]
    
The arguments `argN` passed after `queue_filename` will become arguments to the program specified by the `worker` argument of `consumer`/`server`. Spaces and other special characters are allowed inside arguments.

    ./enqueue queue_filename -- [arg1[ arg2][...]]

If the first argument after `queue_filename` is `--`, all following arguments `argN` are concatenated (with spaces between them) to form the job string. This string will be later concatenated with the `worker` argument of `consumer`/`server` to form the command to be executed by `eval`. This means that both spaces inside arguments passed to `enqueue` and spaces between the arguments will be treated as argument separators when running the worker.

This method of invocation can be also used to enqueue arbitrary shell commands (if the server/consumer is run with empty string as worker) - see examples.

### Start consumer server:

    ./server queue_filename nconsumers worker
    
where:
* `nconsumers` is the number of consumers to be started,
* `worker` is the name of worker, as described above.

Examples
--------

### Convert many graphic files

Start the server with 6 convert workers:

    ./server convert_queue 6 convert
    
Find bmp files and prepare jobs:

    for f in *.bmp; do ./enqueue convert_queue "$f" "${f%.bmp}.png"; done

### Encode many wave files to mp3

Start the server with 6 lame workers:

    ./server music_queue 6 lame
    
Find wave files and prepare jobs:

    find Music/ -name '*.wav' | while read file; do
        ./enqueue music_queue "$file" "${file%.wav}.mp3"
    done
    
### Execute arbitrary shell commands

    ./server queue 6
    for f in *.txt; do ./enqueue queue -- "echo extra line >> $f"; done
    
*Note:* this will not work well for filenames with special characters, especially spaces; it is necessary to properly handle escaping of spaces and other characters.
