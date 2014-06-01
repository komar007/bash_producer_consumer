bash_producer_consumer
======================

Producer-consumer pattern implementation in bash

Usage
-----
In these examples `queue_filename` is the name of a text file which will be used to keep the job queue.

### Start a consumer:

    ./consumer queue_filename consumer_id worker
    
where:
* `consumer_id` is this consumer's unique identifier for this queue,
* `worker` is the name of program/script which performs the job; it will be passed the job to perform using command-line arguments.

### Produce a job to be performed by consumers:

    ./enqueue queue_filename job_description
    
where `job_description` is a string (passed as single argument!) which describes the arguments which will be passed to the worker.

### Start consumer server:

    ./server queue_filename nconsumers worker
    
where:
* `nconsumers` is the number of consumers to be started,
* `worker` is the name of worker, as described above.

Examples
--------

### Convert many graphic files

Start the server with 6 convert workers:

    ./server.sh convert_queue 6 convert
    
Find bmp files and prepare jobs:

    for f in *.bmp; do ./enqueue convert_queue $f ${f%.bmp}.png; done
    
*Note*: this will not work for filenames with special characters, like spaces. See the next example.

### Encode many wave files to mp3

Start the server with 6 lame workers:

    ./server.sh music_queue 6 lame
    
Find wave files and prepare jobs:

    find Music/ -name '*.wav' | while read file; do
        ./enqueue.sh music_queue "\"$file\" \"${file%.wav}.mp3\"";
    done
    
Each job will be the argument list to lame in the following format:

    "filename.wav" "filename.mp3"

The script adds double quotes to make sure that spaces will be handled correctly. There's still room for improvement - remember that the command to be executed as job is created by concatenating the `worker` argument to server with the job string. That command is then executed by `eval`, This means that in this example double quotes inside filenames will likely break everything.

It might seem to be too much hassle, but this approach gives the most flexibility by allowing to run arbitrary bash commands with arbitrary arguments as jobs. You can even pass an empty string as `worker` and enqueue whole bash command to execute as jobs.
