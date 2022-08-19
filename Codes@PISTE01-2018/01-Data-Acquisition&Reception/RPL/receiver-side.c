 
#include "contiki.h"
#include "lib/random.h"
#include "sys/ctimer.h"
#include "sys/etimer.h"
#include "net/ip/uip.h"
#include "net/ipv6/uip-ds6.h"
#include "net/ip/uip-debug.h"
#include "simple-udp.h"
#include "servreg-hack.h"
#include "rpl-conf.h"
#include "net/rpl/rpl.h"

#include <stdio.h>


#define UDP_PORT 1234
#define SERVICE_ID 190

#define SEND_INTERVAL		(10 * CLOCK_SECOND)
#define SEND_TIME		(random_rand() % (SEND_INTERVAL))

#define RPL_CONF_OF rpl_of0
#define RPL_CONF_DAG_MC RPL_DAG_MC_ENERGY
static struct simple_udp_connection unicast_connection;

struct my_msg_t {
uint16_t NodeID ; 
uint16_t Humidity ; 
uint16_t Luminosity;
uint16_t Temperature;
};

/*---------------------------------------------------------------------------*/
PROCESS(unicast_receiver_process, "Unicast receiver example process");
AUTOSTART_PROCESSES(&unicast_receiver_process);
/*---------------------------------------------------------------------------*/
float
floor(float x)
{
  if(x >= 0.0f) {
    return (float) ((int) x);
  } else {
    return (float) ((int) x - 1);
  }
}
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
struct my_msg_t *msgPtr = (struct my_msg_t *) data;
  

/*---------------Node ID retrieving---------------------------------------------*/
printf("%d:",msgPtr->NodeID) ; 
/*---------------Humidity retrieving---------------------------------------------*/
uint16_t humidity_raw_minvalue3V =1700; // depends on the power input (5V, 3,3V)
//uint16_t humidity_raw_maxvalue3V = 4095;  
uint16_t humidity_relative_value_PHIDGET3V;
uint16_t humidity_raw_value_PHIDGET3V ; 
uint16_t humidity_value_PHIDGET3V ;

 humidity_raw_value_PHIDGET3V = msgPtr->Humidity ;
 if (humidity_raw_value_PHIDGET3V < humidity_raw_minvalue3V) {  
       humidity_relative_value_PHIDGET3V= 0;
          }
 humidity_relative_value_PHIDGET3V = humidity_raw_value_PHIDGET3V - humidity_raw_minvalue3V;
 humidity_relative_value_PHIDGET3V *= ((double)100 / (double)2395);
 humidity_value_PHIDGET3V =  100 - humidity_relative_value_PHIDGET3V;  
 printf("%d:", humidity_value_PHIDGET3V);

/*--------------Luminosity retrieving----------------------------------------*/
uint16_t luminosity_raw_value_PHIDGET35V;
uint16_t luminosity_value_PHIDGET35V;
    
    luminosity_raw_value_PHIDGET35V = msgPtr->Luminosity ;
    luminosity_raw_value_PHIDGET35V *=  ((double)5 / (double)3);
    luminosity_value_PHIDGET35V  =   (luminosity_raw_value_PHIDGET35V * ((double)46200 / (double)4095) );
    printf("%d:",luminosity_value_PHIDGET35V);
/*------------Temperature retieving------------------------------------------*/
uint16_t temp_raw_value ;     
int16_t  tempint;
uint16_t tempfrac;
uint16_t absraw;
int16_t  sign;
    sign = 1;
    temp_raw_value=msgPtr->Temperature ;
    absraw = temp_raw_value;
    if (temp_raw_value < 0) { // Perform 2C's if sensor returned negative data
          absraw = (temp_raw_value ^ 0xFFFF) + 1;
          sign = -1;
        }
	tempint  = (absraw >> 8) * sign;
        tempfrac = ((absraw>>4) % 16) * 625; // Info in 1/10000 of degree
  	printf("%d.%04d\n", tempint, tempfrac); 
        printf("\n"); 

}
/*---------------------------------------------------------------------------*/

static uip_ipaddr_t *
set_global_address(void)
{
  static uip_ipaddr_t ipaddr;

  uip_ip6addr(&ipaddr, 0xaaaa, 0, 0, 0, 0, 0, 0, 0);
  uip_ds6_set_addr_iid(&ipaddr, &uip_lladdr);
  uip_ds6_addr_add(&ipaddr, 0, ADDR_AUTOCONF);


  return &ipaddr;
}
/*---------------------------------------------------------------------------*/
static void
create_rpl_dag(uip_ipaddr_t *ipaddr)
{
  struct uip_ds6_addr *root_if;

  root_if = uip_ds6_addr_lookup(ipaddr);
  if(root_if != NULL) {
    rpl_dag_t *dag;
    uip_ipaddr_t prefix;
    
    rpl_set_root(RPL_DEFAULT_INSTANCE, ipaddr);
    dag = rpl_get_any_dag();
    uip_ip6addr(&prefix, 0xaaaa, 0, 0, 0, 0, 0, 0, 0);
    rpl_set_prefix(dag, &prefix, 64);
    PRINTF("created a new RPL dag\n");
  } else {
    PRINTF("failed to create a new RPL DAG\n");
  }
}
/*---------------------------------------------------------------------------*/
PROCESS_THREAD(unicast_receiver_process, ev, data)
{
  uip_ipaddr_t *ipaddr;

  PROCESS_BEGIN();

  servreg_hack_init();

  ipaddr = set_global_address();

  create_rpl_dag(ipaddr);

  servreg_hack_register(SERVICE_ID, ipaddr);

  simple_udp_register(&unicast_connection, UDP_PORT,
                      NULL, UDP_PORT, receiver);

  while(1) {
    PROCESS_WAIT_EVENT();
  }
  PROCESS_END();
}
/*---------------------------------------------------------------------------*/
