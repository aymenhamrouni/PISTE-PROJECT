#  Unicast sender / receiver with multi-hop under uIP


 The following programs feature a simple communication between sender node and receiver node, the sink, using multi-hop with RPL protocol (uIP protocol stack activated).
 The sender senses and sends three parameters : Temperature, Humidity and Luminosity.


## File list

 * receiver-side.c  
 * sender-side.c
 * Makefile

### Prerequisites
* Contiki system installed

## Executing programs on real z1 motes under Linux (Contiki)

1.  Define Z1 as platform

 `make TARGET = z1 savetarget`

2.  Compile the code (example : receiver-side.c)

 ` make receiver-side`

3.  Upload the code  to z1 mote (connected via USB)

` make receiver-side.upload`

4. Login to view simulation process on terminal

 `make z1-reset && make Login`
