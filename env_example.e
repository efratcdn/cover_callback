File name     : env_example.e
Title         : Send coverage progress to graph - usage example
Project       : Utilities examples
Created       : 2020
              :
Description   : Using the cover_send_to_graph
  
                Defining two cover groups, and registrating them to 
                the cover_sampling_callback defined in cover_send_to_graph.e
      
  
  Usage example:
  
    specman -64 -c 'load cover_send_to_graph.e env_example;test'

  

<'
import cover_send_to_graph;

type packet_protocol : [ETHERNET, IEEE, ATM];

struct packet{
   
    len : uint(bits:4);      
  
    data : list of byte; 
    keep data.size() == len; 
    
    pkt_type: packet_protocol;

    event packet_cover;

    ///on packet_cover {out("================================");};
    cover packet_cover is {
        item len;
        item pkt_type;
    }; 
};





extend sys {    
    inst : packet;
    
    keep numCycles==900;
    
    kind1 : [a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s];
    kind2 : [a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s];
    event mem_cover;
    cover mem_cover is {
        item kind1;
        item kind2;
        cross kind1, kind2;
    };
    
    run() is also {
        start scenario();
    };
    scenario() @any is {
        raise_objection(TEST_DONE);
         
       
        while(sys.time<numCycles)  {
            gen inst;
            emit inst.packet_cover;
            gen kind1;
            gen kind2;
            emit mem_cover;
            wait [10] * cycle;
        };
        
        drop_objection(TEST_DONE);
    };
    
};

            

type power_t         : [OFF, STAND_BY, ON];
type state_machine_t : [IDLE, ADDRESS, DATA]; 
struct state_machine_s like any_sequence_item {
    power : power_t;
    fsm  : state_machine_t;
    
    keep soft power == select {
        10 : STAND_BY;
        100 : ON;
    };
    keep soft fsm == select {
        100 : IDLE;
        5  : DATA;
    };
    
    event state_machine_cover;
    cover state_machine_cover is {
        item power;
        item fsm;
        cross power, fsm;
    };
};

// the state machine generaiton controlled with sequences

sequence controller_seq using item = state_machine_s, created_driver = controller_driver;

extend controller_driver {
    event clock is only @sys.any;
    
    run() is also {
        start dummy_bfm();
    };
    dummy_bfm() @clock is {
        var ctrl : state_machine_s;
        while TRUE {
            ctrl = get_next_item();
            emit ctrl.state_machine_cover;
            wait [10] * cycle;
            
            emit item_done;
        };
    };
};

extend controller_seq {
    !ctrl : state_machine_s;
};

extend controller_seq_kind : [ARB, INIT, MODE_0, CONFIG ];

extend MAIN controller_seq {
    !seq : controller_seq;
    body() @driver.clock is only {
        for i from 0 to 7 {
            do seq keeping {it.kind != ARB;};
        };
         for i from 0 to 7 {
            do seq;
        };
    };
};
extend INIT controller_seq {
    body() @driver.clock is only {
        for i from 0 to 10 {
            wait [1] * cycle;
            do ctrl;
        };
    };
};
extend MODE_0 controller_seq {
    body() @driver.clock is only {
        for i from 0 to 10 {
            wait [2] * cycle;
            do ctrl;
        };
    };
};
extend CONFIG controller_seq {
    body() @driver.clock is only {
        for i from 0 to 10 {
            wait [1] * cycle;
            do ctrl keeping {.power == ON};
        };
    };
};

extend ARB controller_seq {
    keep soft ctrl.power == select {
        30 : OFF;
        30 : STAND_BY;
        30 : ON;
    };
    keep soft ctrl.fsm == select {
        30 : IDLE;
        30 : ADDRESS;
        30 : DATA;
    };
    
    body() @driver.clock is only {
        for i from 0 to 10 {
            wait [3] * cycle;
            do ctrl;
        };
    };
};


extend sys {
    controller_driver is instance;
};

'>

<'
extend sys {
    !cb : cover_cb_send_to_plot;
    
    run() is also {
       cb  = new  with {
           var gr1:=rf_manager.get_struct_by_name("packet").get_cover_group("packet_cover");
            .register(gr1);

            var gr2:=rf_manager.get_struct_by_name("sys").get_cover_group("mem_cover");
            .register(gr2);
            
        };   
    };
};
'>
 
