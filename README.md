# Redis Study 🛠️

This repository contains my study files related to Redis using Cluster strategy.

## 🚀 Getting Started

### Prerequisites

Ensure you have the following installed on your system:
- [Docker & Docker Compose](https://medium.com/@piyushkashyap045/comprehensive-guide-installing-docker-and-docker-compose-on-windows-linux-and-macos-a022cf82ac0b)
- [Redis CLI](https://redis.io/docs/latest/operate/oss_and_stack/install/install-redis/) (only required if you want to connect from outside the container)

### Running a Example

To start, just run:

```bash
docker compose up
```

You'll have to rebalance the slots, to do that just enter the redis container bash:
```bash
docker compose exec redis bash
```

Then get the ID of the new master node (redis-7007) that will receive the slots:
```bash
MASTER_ID=$(redis-cli -h redis-7007 -p 7007 cluster myid)
```

After that, redistribute the slots to include the new master. This command will:
- Move 4096 slots (25% of total 16384 slots) to the new master
- Take slots from all existing masters evenly
- The new distribution will help balance the cluster load
```bash
redis-cli -h redis-7001 -p 7001 --cluster reshard redis-7001:7001 << EOF
4096
$MASTER_ID
all
yes
EOF
```

### Connecting to Redis

#### 📌 Option 1: From Inside the Container

If you don’t have the Redis CLI installed locally, you can connect from inside the running container:

1. Enter the container

```bash
docker compose exec <container_name> bash
```

2. Start the Redis CLI (only works with the Redis port running inside this container):

```bash
redis-cli -p <port> -a root
```

#### 📌 Option 2: From Outside the Container

If you have Redis installed locally, you can connect directly using:
```bash
redis-cli -p <port> -a root
```

