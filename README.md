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
* `nworkers` is the number of consumers to be started
* `worker` is the name of worker, as described above.
