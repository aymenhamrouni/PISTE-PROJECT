
#include "contiki.h"
#include "net/rime/rime.h"
#include "lib/list.h"
#include "lib/memb.h"
#include "lib/random.h"
#include "dev/z1-phidgets.h"
#include "dev/button-sensor.h"
#include "dev/i2cmaster.h"
#include "dev/tmp102.h"
#include "dev/leds.h"

#include <stdio.h>
#include "sys/node-id.h"
#define CHANNEL 8080



struct my_msg_t {
uint16_t NodeID ; 
uint16_t Humidity ; 
uint16_t Luminosity;
uint16_t Temperature;
};


struct example_neighbor {
  struct example_neighbor *next;
  linkaddr_t addr;
  struct ctimer ctimer;
};

#define NEIGHBOR_TIMEOUT 50 * CLOCK_SECOND
#define MAX_NEIGHBORS 16
LIST(neighbor_table);
MEMB(neighbor_mem, struct example_neighbor, MAX_NEIGHBORS);
/*---------------------------------------------------------------------------*/
PROCESS(example_multihop_process, "PISTE Project 2018,Node 3");
AUTOSTART_PROCESSES(&example_multihop_process);
/*---------------------------------------------------------------------------*/
/*
 * This function is called by the ctimer present in each neighbor
 * table entry. The function removes the neighbor from the table
 * because it has become too old.
 */
static void
remove_neighbor(void *n)
{ 
 struct example_neighbor *e = n;

  list_remove(neighbor_table, e);
  memb_free(&neighbor_mem, e);
}
/*---------------------------------------------------------------------------*/
/*
 * This function is called when an incoming announcement arrives. The
 * function checks the neighbor table to see if the neighbor is
 * already present in the list. If the neighbor is not present in the
 * list, a new neighbor table entry is allocated and is added to the
 * neighbor table.
 */
static void
received_announcement(struct announcement *a,
                      const linkaddr_t *from,
		      uint16_t id, uint16_t value)
{
  struct example_neighbor *e;

    /* printf("Got announcement from %d.%d, id %d, value %d\n",
      from->u8[0], from->u8[1], id, value);*/

  /* We received an announcement from a neighbor so we need to update
     the neighbor list, or add a new entry to the table. */
  for(e = list_head(neighbor_table); e != NULL; e = e->next) {
    if(linkaddr_cmp(from, &e->addr)) {
      /* Our neighbor was found, so we update the timeout. */
      ctimer_set(&e->ctimer, NEIGHBOR_TIMEOUT, remove_neighbor, e);
      return;
    }
  }

  /* The neighbor was not found in the list, so we add a new entry by
     allocating memory from the neighbor_mem pool, fill in the
     necessary fields, and add it to the list. */
  e = memb_alloc(&neighbor_mem);
  if(e != NULL) {
    linkaddr_copy(&e->addr, from);
    list_add(neighbor_table, e);
    ctimer_set(&e->ctimer, NEIGHBOR_TIMEOUT, remove_neighbor, e);
  }
}
static struct announcement example_announcement;
/*---------------------------------------------------------------------------*/
/*
 * This function is called at the final recepient of the message.
 */
 
static void
recv(struct multihop_conn *c, const linkaddr_t *sender,
     const linkaddr_t *prevhop,
     uint8_t hops)
{ struct my_msg_t *msgPtr=(struct my_msg_t *)(packetbuf_dataptr());

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


/*
 * This function is called to forward a packet. The function picks a
 * random neighbor from the neighbor list and returns its address. The
 * multihop layer sends the packet to this address. If no neighbor is
 * found, the function returns NULL to signal to the multihop layer
 * that the packet should be dropped.
 */
static linkaddr_t *
forward(struct multihop_conn *c,
	const linkaddr_t *originator, const linkaddr_t *dest,
	const linkaddr_t *prevhop, uint8_t hops)
{


   

  /* Find a random neighbor to send to. */
  int num, i;
  struct example_neighbor *n;

  A : if(list_length(neighbor_table) > 0) {
    num = random_rand() % list_length(neighbor_table);
    i = 0;
    for(n = list_head(neighbor_table); n != NULL && i != num; n = n->next) {
      ++i;
    }
    if(n != NULL) {
     printf("%d.%d: Forwarding packet to %d.%d (%d in list), hops %d\n",
	     linkaddr_node_addr.u8[0], linkaddr_node_addr.u8[1],
	     n->addr.u8[0], n->addr.u8[1], num,
	     packetbuf_attr(PACKETBUF_ATTR_HOPS)); 
      return &n->addr;
    }
  else { announcement_listen(50 * CLOCK_SECOND ) ; goto A ;  }
  
   
  }
  
    printf("%d.%d: did not find a neighbor to foward to\n",linkaddr_node_addr.u8[0], linkaddr_node_addr.u8[1]);
  return NULL; 
}
static const struct multihop_callbacks multihop_call = {recv, forward};
static struct multihop_conn multihop;
/*---------------------------------------------------------------------------*/
PROCESS_THREAD(example_multihop_process, ev, data)
{


 

  PROCESS_EXITHANDLER(multihop_close(&multihop);)
    
  PROCESS_BEGIN();
  tmp102_init();
  static struct my_msg_t data_to_be_sent;
  static struct my_msg_t *data_to_be_sent_Ptr = &data_to_be_sent;
  static struct etimer et;
  /* Initialize the memory for the neighbor table entries. */
  memb_init(&neighbor_mem);

  /* Initialize the list used for the neighbor table. */
  list_init(neighbor_table);

  /* Open a multihop connection on Rime channel CHANNEL. */
  multihop_open(&multihop, CHANNEL, &multihop_call);

  /* Register an announcement with the same announcement ID as the
     Rime channel we use to open the multihop connection above. */
  

  /* Activate the button sensor. We use the button to drive traffic -
     when the button is pressed, a packet is sent. */
  SENSORS_ACTIVATE(phidgets);

  /* Loop forever, send a packet when the button is pressed. */
  while(1) {


    
    /* Wait until we get a sensor event with the button sensor as data. */
    
    
  etimer_set(&et, 120 * CLOCK_SECOND);
etimer_set(&et, 10 * CLOCK_SECOND);
    
announcement_register(&example_announcement,
			CHANNEL,
			received_announcement);

  /* Set a dummy value to start sending out announcments. */
  announcement_set_value(&example_announcement, 0);

    PROCESS_WAIT_UNTIL(etimer_expired(&et));
announcement_listen(120 * CLOCK_SECOND);
 PROCESS_WAIT_UNTIL(etimer_expired(&et));
   /* Register an announcement with the same announcement ID as the
     Rime channel we use to open the multihop connection above. */
 
    linkaddr_t to;
   

	data_to_be_sent_Ptr->NodeID=3.0 ; 
	data_to_be_sent_Ptr->Humidity=phidgets.value(PHIDGET3V_2);
	data_to_be_sent_Ptr->Luminosity=phidgets.value(PHIDGET5V_1);
        data_to_be_sent_Ptr->Temperature=tmp102_read_reg(TMP102_TEMP);
    /* Copy the "Hello" to the packet buffer. */
    packetbuf_copyfrom(data_to_be_sent_Ptr,sizeof(data_to_be_sent));

    /* Set the Rime address of the final receiver of the packet to
       1.0. This is a value that happens to work nicely in a Cooja
       simulation (because the default simulation setup creates one
       node with address 1.0). */
    to.u8[0] = 1;
    to.u8[1] = 0;

    /* Send the packet. */
    multihop_send(&multihop, &to);

  }

  PROCESS_END();
}
/*---------------------------------------------------------------------------*/
