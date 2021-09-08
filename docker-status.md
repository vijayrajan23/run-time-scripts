```bash

#!/usr/bin/env bash

running_containers=$(docker ps -a --filter status=running --format "{{.Names}}")

for i in $running_containers; do
    if [ $i == 'otp-server' ]; then
        echo "$i container is Running"
    elif [ $i == 'otp-server' ]; then
        echo "$i container is Running"
    fi
done

# bash docker-status.sh

```
