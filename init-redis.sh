#!/bin/sh

# Criar o cluster
echo "yes" | redis-cli --cluster create redis-7001:7001 redis-7002:7002 redis-7003:7003 \
redis-7004:7004 redis-7005:7005 redis-7006:7006 --cluster-replicas 1

# Adicionar o nó 7007
redis-cli --cluster add-node redis-7007:7007 redis-7001:7001

# Esperar o nó 7007 ser reconhecido pelo cluster
sleep 5

# Capturar o ID do nó mestre 7007
MASTER_ID=$(redis-cli -h redis-7007 -p 7007 cluster myid)

# Adicionar nó 7008 como réplica do nó 7007
redis-cli --cluster add-node redis-7008:7008 redis-7001:7001 --cluster-slave --cluster-master-id $MASTER_ID

# Evitar que o container seja encerrado
tail -f /dev/null
