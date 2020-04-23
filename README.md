# cover_callback
* Title       : Cover Progress Graph  
* Version     : 1.0
* Requires    : Specman {19.03..}
* Modified    : April 2020
* Description :

[ More e examples in https://github.com/efratcdn/spmn-e-utils ]

This code is an example of two features:
  1) Coverage Callback API
  2) Calling Python from e code


The file implements a cover_sampling_callback. When its do_callback() is 
called, it sends the sampled group name and grade to Python Matplot, which
prints the result.


Environment setup:

Ensure these four environment variables are defined:

   1) PYTHONPATH 
        To local dir, where plot_i.py is
    
   2) SPECMAN_PYTHON_INCLUDE_DIR 
          To where matplotlib is

   3) SPECMAN_PYTHON_LIB_DIR 
       To where matplotlib is

   4) LD_LIBRARY_PATH 
        To contain $ LD_LIBRARY_PATH and SPECMAN_PYTHON_LIB_DIR

   For example:

     setenv PYTHONPATH ./
     setenv SPECMAN_PYTHON_INCLUDE_DIR $PYTHON_INSTALL/include/python3.7m
     setenv SPECMAN_PYTHON_LIB_DIR  $PYTHON_INSTALL/lib
     setenv LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:${SPECMAN_PYTHON_LIB_DIR}


Running the demo:

  specman -64 -c 'load cover_send_to_graph.e env_example;test'

