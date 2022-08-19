 

#include "contiki.h"
#include "lib/random.h"
#include "sys/ctimer.h"
#include "sys/etimer.h"
#include "net/ip/uip.h"
#include "net/ipv6/uip-ds6.h"
#include "net/ip/uip-debug.h"
#include "dev/z1-phidgets.h"
#include "dev/button-sensor.h"
#include "sys/node-id.h"
#include "dev/cc2420/cc2420.h"
#include "dev/i2cmaster.h"  // Include IC driver
#include "dev/tmp102.h" // Include sensor driver
#include "simple-udp.h"
#include "servreg-hack.h"
#include <stdio.h>
#include <string.h>
#include "node-id.h" 

#define UDP_PORT 1234
#define SERVICE_ID 190

#define SEND_INTERVAL		(10 * CLOCK_SECOND)
#define SEND_TIME		(random_rand() % (SEND_INTERVAL))

static struct simple_udp_connection unicast_connection;

struct sensed_data {
uint16_t NodeID ; 
uint16_t Humidity ; 
uint16_t Luminosity;
uint16_t Temperature;
};

/*---------------------------------------------------------------------------*/
PROCESS(unicast_sender_process, "Unicast sender example process");
AUTOSTART_PROCESSES(&unicast_sender_process);
/*---------------------------------------------------------------------------*/
static void
receiver(struct simple_udp_connection *c,
         const uip_ipaddr_t *sender_addr,
         uint16_t sender_port,
         const uip_ipaddr_t *receiver_addr,
         uint16_t receiver_port,
         const uint8_t *data,
         uint16_t datalen)
{

	
  printf("Data received on port %d from port %d with length %d\n",
         receiver_port, sender_port, datalen);
}
/*---------------------------------------------------------------------------*/
static void
set_global_address(void)
{
  uip_ipaddr_t ipaddr;
  int i;
  uint8_t state;

  uip_ip6addr(&ipaddr, 0xaaaa, 0, 0, 0, 0, 0, 0, 0);
  uip_ds6_set_addr_iid(&ipaddr, &uip_lladdr);
  uip_ds6_addr_add(&ipaddr, 0, ADDR_AUTOCONF);

  printf("IPv6 addresses: ");
  for(i = 0; i < UIP_DS6_ADDR_NB; i++) {
    state = uip_ds6_if.addr_list[i].state;
    if(uip_ds6_if.addr_list[i].isused &&
       (state == ADDR_TENTATIVE || state == ADDR_PREFERRED)) {
      uip_debug_ipaddr_print(&uip_ds6_if.addr_list[i].ipaddr);
      printf("\n");
    }
  }
}
/*---------------------------------------------------------------------------*/
PROCESS_THREAD(unicast_sender_process, ev, data)
{
  static struct etimer periodic_timer;
  static struct etimer send_timer;
  static struct sensed_data data_to_be_sent;
  static struct sensed_data *data_to_be_sent_Ptr = &data_to_be_sent;
  uip_ipaddr_t *addr;

  PROCESS_BEGIN();
  SENSORS_ACTIVATE(phidgets);

  tmp102_init(); //init temperature sensor 
  servreg_hack_init();

  set_global_address();


  simple_udp_register(&unicast_connection, UDP_PORT,
                      NULL, UDP_PORT, receiver);

  etimer_set(&periodic_timer, SEND_INTERVAL);
  while(1) {

    PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&periodic_timer));
    etimer_reset(&periodic_timer);
    etimer_set(&send_timer, SEND_TIME);

    PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&send_timer));
    addr = servreg_hack_lookup(SERVICE_ID);
    printf("%d",node_id) ; 
    if(addr != NULL) {
      static unsigned int message_number;
	
	data_to_be_sent_Ptr->NodeID=node_id ; 
	data_to_be_sent_Ptr->Humidity=phidgets.value(PHIDGET3V_2);
	data_to_be_sent_Ptr->Luminosity=phidgets.value(PHIDGET5V_1);
        data_to_be_sent_Ptr->Temperature=tmp102_read_reg(TMP102_TEMP);
	
     
   printf("Sending unicast to :");
        uip_debug_ipaddr_print(addr);
        printf("\n");
        message_number++;
        simple_udp_sendto(&unicast_connection,data_to_be_sent_Ptr, sizeof(data_to_be_sent), addr);
    } else {
      printf("Service %d not found\n", SERVICE_ID);
    }
  }

  PROCESS_END();
}
/*---------------------------------------------------------------------------*/
