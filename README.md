Below is an example of a failure:

First we insert 5 rows of data on each of the 3 nodes in the cluster, then we select everything from the table (resulting in 15 rows on each server). Then we delete on each server with `hostname=@@hostname` so every server cleans up after itself. Lastly we check that the table is empty on all 3 servers.

But, one of the deletes results in `Query OK, 0 rows affected` even tough the rows are deleted...

In the logs this is shown (random amount of times):
```
node2_1  | BF-BF X lock conflict,mode: 1027 supremum: 0
node2_1  | conflicts states: my 5 locked 0
node2_1  | RECORD LOCKS space id 26 page no 3 n bits 88 index `GEN_CLUST_INDEX` of table `galera`.`debug` trx table locks 1 total table locks 2  trx id 5621 lock_mode X locks rec but not gap lock hold time 0 wait time before grant 0
node2_1  | BF-BF X lock conflict,mode: 1027 supremum: 0
node2_1  | conflicts states: my 5 locked 0
node2_1  | RECORD LOCKS space id 26 page no 3 n bits 88 index `GEN_CLUST_INDEX` of table `galera`.`debug` trx table locks 1 total table locks 2  trx id 5621 lock_mode X locks rec but not gap lock hold time 0 wait time before grant 0
node2_1  | BF-BF X lock conflict,mode: 1027 supremum: 0
node2_1  | conflicts states: my 5 locked 0
node2_1  | RECORD LOCKS space id 26 page no 3 n bits 88 index `GEN_CLUST_INDEX` of table `galera`.`debug` trx table locks 1 total table locks 2  trx id 5621 lock_mode X locks rec but not gap lock hold time 0 wait time before grant 0
```

It's often based on which order the delete is executed, but sometimes it's a different node that shows the `Query OK, 0 rows affected`

![screenshot](https://github.com/anderskvist/galera-debug/raw/master/doc/screenshot.png)
