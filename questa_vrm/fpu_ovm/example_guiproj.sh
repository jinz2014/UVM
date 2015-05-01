echo "Launching example_guiproj regression ..."
echo "A new regression configuration will be added to your existing vrm project"
echo "Save this regression configuration in a vrm project otherwise"

vrun -j 3 -rmdb sim2/fpu_regression.rmdb -vrmdata VRMDATA1 flow -Gflow/sim_group/simulate~fpu_test_neg_sqr_sequence/NUM_SIM=4 -Gflow/sim_group/simulate~fpu_test_random_sequence/NUM_SIM=4 -Gflow/sim_group/simulate~fpu_test_sequence_fair/NUM_SIM=3 -gui
