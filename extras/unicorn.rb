worker_processes 3

listen 5000
listen 5001
listen 5002

preload_app true

timeout 30

pid               '/var/www/mirafloris/shared/pids/unicorn.pid'
stderr_path       '/var/www/mirafloris/shared/log/unicorn.error.log'
stdout_path       '/var/www/mirafloris/shared/log/unicorn.out.log'
working_directory '/var/www/mirafloris/current'