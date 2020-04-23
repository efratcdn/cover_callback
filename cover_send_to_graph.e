File name     : cover_send_to_graph.e
Title         : Send coverage progress to graph
Project       : Utilities examples
Created       : 2020
              :
Description   : Impelment a cover_sampling_callback struct.
                In its do_callback, send the per-type grade to 
                Matplot (python lib)

                Importing Python functions
  
  Usage example:
  
    specman -64 -c 'load cover_send_to_graph.e env_example;test'

  
<'
extend sys {

    //***PYTHON: import functions

    @import_python(module_name="plot_i", python_name="end_plot")
    end_plot() is imported; 

    @import_python(module_name="plot_i", python_name="init_plot")
    init_plot(numCycles:int) is imported; 

    @import_python(module_name="plot_i", python_name="keep_plot")
    keep_plot() is imported; 
  
    @import_python(module_name="plot_i", python_name="addVal")
    addVal(groupName:string, cycle:int,grade:real) is imported; 

    numCycles:int; 
    keep numCycles==900; // handle this better
    run() is also {
        out("        Specman : Initialize the plot in python");
        init_plot(numCycles);        
    };
    all_objections_dropped(kind : objection_kind) is also {
        out("        Specman : End the plot in python");
        end_plot();
    };

    send_to_graph(group_name : string, group_grade : real) is {
        // out("       Specman : send the data to python");
        addVal(group_name, sys.time*10, group_grade);    
    };   
};

struct cover_cb_send_to_plot like cover_sampling_callback {
   
    do_callback() is only {
        
        if is_currently_per_type() {
            
            var cur_grade : real = get_current_group_grade();
       
            sys.send_to_graph(get_current_cover_group().get_name(), 
                             cur_grade);
        };
    };
};

'>
