#  Unicast sender / receiver with multi-hop under RIME


 The following programs feature a simple communication between sender node and receiver node, the sink, using multi-hop with RIME protocol stack activated.
 The sender senses and sends three parameters : Temperature, Humidity and Luminosity.


## File list

 * receiver-side-sink.c  
 * sender-side-node2.c
 * sender-side-node3.c
 * Makefile

### Prerequisites
* Contiki system installed
* Note : the node ID for each node should be configured before programming. By default, the sink node has the ID = 1, sender nodes = ID (2,3).
To burn the MAC address and the node ID (ID =1), run the following in directory : /examples/z1 run:

 `make clean && make burn-nodeid.upload nodeid=1 nodemac=1 && make z1-reset && make login`

## Executing programs on real z1 motes under Linux (Contiki)

1.  Define Z1 as platform

 `make TARGET = z1 savetarget`

2.  Compile the code (example : receiver-side-sink.c)

 ` make receiver-side-sink`

3.  Upload the code  to z1 mote (connected via USB)

` make receiver-side-sink.upload`

4. Login to view simulation process on terminal

 `make z1-reset && make Login`
