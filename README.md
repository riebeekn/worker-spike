# Worker spike - parallel

Queues jobs to a Mongo DB and runs various tasks in parallel (i.e. multiple workers can run different tasks for the same job in parallel).

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
