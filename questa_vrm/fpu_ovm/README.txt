This is a simple example showing how Questa Sim Verification Run Manager 
can be used to manage the verification process of a typical IP block.

The design used is an open source FPU based design (VHDL) from OpenCores.org

The test environment is OVM based. For more information regarding creating 
reusable verification platforms using OVM or Accellera UVM, please
visit Verification Academy http://verificationacademy.com. Registration 
may be required.

In a coverage driven methodology, when a new IP for an SoC or FPGA design 
is being developed, the verification team starts the verification process 
by creating a plan that describes : 
  * What will be verified - Prioritized list of key features  
  * How it will be verified - Simulation, Formal Emulation, FPGA 
    Prototyping and for simulation, techniques such as constrained 
    Random tests, Directed test techniques etc.
    In addition, checkers and Scoreboards are defined including the use 
    ABV for capturing intended design behaviour 
  * How progress will be measured - Usually in the form of functional 
    coverage, assertion coverage, code coverage, coveragability measures 
   from Formal engines etc

The team creates the executable platform including coverage models with 
which to exercise the design under verification in order to answer the 
questions posed in the verification plan. The test scenarios that will 
be run on this platform are then developed and following that, the team
proceeds to verify the DUV by executing the tests on the platform. 

The main objective of the verification team is to flush 
out as many bugs as possible from the DUV within the allocated time.

Typically the verification process involves a large number of regression cycles 
and could involve multiple tools each with its own generated metrics. 
It is not unusual to see verification teams getting swamped with having to 
maintain such a process and the resulting data generated rather than focussing 
on the their primary function of verification.

Questa Sim's Verification Run Manager (VRM) accellerates and 
optimizes the verification process through use of automation 
and an understanding of the typical verification process.

It helps manage the verification data, verification process and the tools
used in the execution.

The user describes their regression suite which is stored in the 
Run Manager Database (RMDB).
For details on RMDB, please refer to the Verification Run Manager Users Guide
that is shipped with Questa Sim 
The RMDB leverages test grouping, inheritance and parameterization extensively in 
order to create highly parameterized and portable regression environments 
which can be reused in many different ways.
In addition VRM provides hooks such that the user can better adapt 
it in their environment
 
This example illustrates the following features of Questa Sim 
Verification Run Manager
Launching regressions in command line mode. 
See sim1/fpu_conf.rmdb for details
To launch this complete regression in batch mode type on 
the command prompt
   
   vrun -rmdb sim1/fpu_conf.rmdb flow -j 1

Note: In this release of Questa Sim (ie 10.1), the following changes have been made to 
vrun runtime arguments:
 "-config <rmdbfile>" is replaced with "-rmdb <rmdbfile>"
 "-scratch <regression working and output dir>" is replaced with
 "-vrmdata <regression working and output dir>"
In addition, the default regression working / output directory name has 
been changed from "SCRATCH" to "VRMDATA"

The results of the regression will be placed in directory VRMDATA in pwd.  
You can launch this regression from any location. If you launch from the 
sim1 directory, then the command to type would be
   
   cd sim1
   vrun -rmdb fpu_conf.rmdb flow -j 1 

The html reporting capability can provide insight into the status of the entire
ergression. In addition, it can ease the navigation and visualization 
of individual log files for each test in the regression.

To generate HTML at the end of the regression launch with the following command

  
  vrun -rmdb sim1/fpu_conf.rmdb flow -j 1 -vrmdata VRMDATA -html -htmldir VRMDATA/vrunhtml 

At end of the regression, HTML data will be placed in directory
VRMDATA/vrunhtml. Navigate to this directory and point your web browser 
and the index.html page to view the results.

2. You can launch regressions using VRM's GUI. The new GUI introduces 
the concept of a VRM project. 
A project can hold 1 or more regression descriptions (RMDB files).
In addition, each RMDB file within the project can be configured
differently. 
The project can hold multiple configurations.
The regression history of each configuration is stored and can be 
displayed by the new VRM GUI.
The new VRM GUI allows the user to launch multiple different configurations 
(regressions) simultaneously and track each regression's status from the project view. 
This new VRM project window is called VRM Cockpit.

A quick way to create a project with 1 rmdb file and 1 configuration 
for this rmdb file is as follows
 a. Type vrun -gui -rmdb sim1/fpu_conf.rmdb flow -j 1. 
    This will open the main VRM Cockpit window and will start 
    a regression automatically using the specified RMDB file in 
    a configuration named "Manual Run 1". 
    You can change the configuration name later on.
 b. When the regression finishes, click on main menu item 
    "File" > "Save Project As .."
 c. In the dialog box that opens up, give the project the name 
    "vrmgui_proj.vrm" and click on "Save"
    to save this project.

 To rename the configuration, do a RMB click within the 
 "VRM Cockpit" window pane and in the popup  menu, select 
 "Edit Configuration" to open the "Edit VRM Configuration" dialog box
   i. With the "General" tab selected, change the configuration name 
      under "VRM Configuration Name"  box from "Manual Run 1" to "regressn_run1" 
  ii. Ensure that the checkbox named "Delete VRM DATA 
      directory before each run <-clean>?" is not checked
      if you want to keep the history of running this configuration
 iii. Click on OK to save this modification

You can now use this configuration to execute the entire regression with the history
being accumulated for each regression invocation of this configuration.

Adding more configurations can be useful e.g to facilitate GUI based re-run or to 
modify the regression in some way that you want to be repeatable

A new configuration can be created that reuses the existing one as follows
a. In the VRM Cockpit window, do RMB click to open the popup menu then 
   select "Clone Configuration"
b. In the "Edit VRM Configuration" dialog box that opens,  
       i. Change the name from "Clone of regressn_run1" to "regressn_rerun". 
      ii. Keep the same VRM Data Directory as the first configuration
     iii. Click on "Runnables" tab and de-select "flow"
      iv. Click on "OK" to save this configuration
  You now have a configuration that can be used together with the
  new Results Analysis window to re-run a sub-set of your regressions
  based on message categorization e.g. a rerun of first error per test
  in the entire regression.  

Now let's create a new configuration for the existing RMDB where 
we increase the number of random tests in the regression. We will 
specify a different working directory for this configuration to allow
simultaneous execution of this configuration and the first configuration
you created.
a. In the VRM Cockpit window, select configuration "regressn_run1" then
   do RMB click and select "Clone Configuration" 
b. In the "Edit VRM Configuration" dialog box that opens,
     i. Change the name from "Clone of regress_run1" to "big_regressn_run1"
    ii. Change the VRM Data Directory to "VRMDATA_big_regressn"
   iii. Click on "Runtime" Tab and in the box named "Additional Command-Line Options", 
        append the following -GNUM_SIM=10
    iv. Click on "Ok" to save this configuration
     v. Accept the first Option in the popup that appears 
        that says create a new VRM Data directory and keep the existing one as is.
    vi. Click OK to create this new VRM Data directory

You can launch this newly created regression configuration simultaneously (assuming you have
enough compute resources) together with regressn_run1 configuration.
 
3. The directory sim2 contains other regression (RMDB) compositions and use models. 
   Concepts such as included RMDB for capturing re-usable regression setup information
   are illustrated in this example. Have a look at the RMDB files in this directory.
   
The shell script example_guiproj.sh is setup to launch the regression described in 
sim2/fpu_regression.rmdb. 
This example illustrates the power of the parameterization
and inheritance. The parameter called NUM_SIM is appears as if it has been defined 
for the group runnable called "flow" in file sim2/fpu_regression.rmdb.  
Actually, the runnable "flow" inherits the parameter NUM_SIM from a 
base runnable called "regression_base". The base runnable "regression_base" 
is defined in the file sim2/vrm_base.rmdb which is "included" in sim2/fpu_regression.rmdb.
All the members of the group runnable "flow" inherit this parameter.
This script launches the regression with this parameter overriden for the different
members of the flow group, and any modification in NUM_SIM value will alter 
the number of running tests. You can launch this regression by typing  
   
  ./example_guiproj.sh

If you have already created a VRM project in 10.1, a regression configuration will be added 
to your last opened VRM project with a default configuration name "Manual Run 1". 
You can re-name the configuration.
If this is your first VRM project, then you will need to rename the configuration and
save the project 

When using the GUI to launch regressions, it can serve as an integrated environment for
managing the verification process.
In the RMDBs we have enabled 
  a) automatic testplan import and coverage merging
  b) automatic results analysis database creation
See the Verification Run Manager Users Manual for additional details on these
capabilities.

You can use the VRM GUI to do the following tasks.
  * Launch and Monitor the regression
  * Visualize the status of a completed regression as well as the 
    history of different invocations of a regression  
  * Visualize log files using RMB click on a selected action script (preScript, postScript, execScript, mergeScript and triageScript) 
    and selecting View > Action Log file
  * Visualize the merged UCDB file by RMB clicking on any action script in VRM Results window
    where mergefile parameter is visible and in the popup menu select View > Merged Coverage > UCDB in Browser. 
    The merged UCDB file will be opened in the ucdb browser window
  * Visualize the merged UCDB in tracker by selecting View > Merged Coverage > UCDB in Tracker 
    to see the coverage results annotated to the testplan for this regression run
  * New in 10.1 you can also view the merged UCDB in vsim for more detailed coverage analysis by
    selecting View > Merged Coverage > UCDB in VSIM
  * You can perform detailed analysis of the coverage relative to the testplan in the tracker window 
    including opening the coverage analysis windows such as covergroup analysis pane and source code
    windows for code coverage in VSIM mode
  * For Results/failure analysis, RMB click on any action script in the VRM Results window and 
    in the pop up menu select "View > Results Analysis". 
    This will load the auto generated triage database into the Results Analysis (RA) UI.
    Here you can leverage the hierarchical grouping capability and filtering capability of the RA UI
    to quickly figure out which failures to concentrate your debug efforts on.
  * You can automatically re-run the subset of action that meet your filtering / categorization criteria from Results Analysis GUI 
   We set this up earlier using the regressn_rerun configuration which works with regressn_run1.
    
