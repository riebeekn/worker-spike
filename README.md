# Worker spike - serial

Queues jobs to a Mongo DB and runs jobs in serial (i.e. a single worker runs all the tasks for a single job).

* To seed jobs:
```
$ ruby app/fixture/seed_jobs.rb
```

* To run a single task:
```
$ ruby app/console/run_job.rb
```

* To run a worker process:
```
$ ruby app/worker/worker.rb
```
