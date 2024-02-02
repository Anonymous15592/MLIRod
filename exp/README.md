```exp``` contains all of the experiment scripts, and it contains the following 5 folders:

### ```0.MLIRod```

To run the evaluation experiment of MLIRod, you can use the following command:

```
python mlirfuzz.py \
--existing_seed_dir ${seed_dir} \
--replace_data_edge ${build}/bin/ReplaceDataEdge \
--replace_control_edge ${build}/bin/ReplaceControlEdge \
--delete_node ${build}/bin/DeleteNode \
--create_node ${build}/bin/CreateNode \
--mlir_opt ${path_of_mlir-opt_you_want_to_test} \
--optfile opt.txt \
--collector ${build}/bin/CollectCoverage \
--clean True > log.txt
```

The ```${seed_dir}``` denotes the path of the existing seed directory.

The ```${build}``` denotes the build path of MLIRod.

You can use ```--help``` to obtain more information about the settings.

Note that you may generate seed pool by yourself, using the following script:

```
#!/bin/bash

successful_runs=0
target_successful_runs=${program_number}

while [ $successful_runs -lt $target_successful_runs ]; do
    ${your_mlirsmith_path}

    if [ $? -eq 0 ]; then
        echo "success!"
        ((successful_runs++))
        cp a.mlir seeds/${successful_runs}.mlir
    else
        echo "failed"
    fi
done

echo "successfully invoke $target_successful_runs times"
```

```${program_number}``` in the above script denotes the number of program to be generated, 
and ```${your_mlirsmith_path}``` is the binary of MLIRSmith.



### ```1.MLIRSmith```

```1.MLIRSmith``` contains the evaluation script for MLIRSmith, you can use the following command to run the evaluation experiment of MLIRSmith:

```
mkdir testcase
timeout 86400 python mlirsmith.py \
--mlirsmith ${build}/bin/mlirsmith \
--testcase_base testcase \
--mliropt ${build}/bin/mlir-opt \
--optfile opt.txt \
--optnum 10 \
--out_base report > log
```

```${build}``` have the same meaning as above.


### ```2.mutation variants```

```2.mutation variants``` contains four folders, each of which contains a variant that removes one of the mutation rules in MLIRod shown as their folder name. Run them with the same command as MLIRod!


### ```3.coverage variants```

```3.coverage variants``` contains two folders, each of which contains the corresponding variant script (i.e. variant that replaces OD coverage to edge coverage, and variant that removes OD coverage).

+ ```MLIRod-random```: contains the variant that removes the OD coverage guidance of MLIRod. You can run it with the same command as MLIRod.

+ ```MLIRod-edgecov```: contains the variant that replaces the OD coverage guidence with edge coverage, please replace the setting ```--collector``` to **showmap tool of AFL++**  to run this script.

### ```4.no-pass```

```4.no-pass``` contains the variant that removes the *pass-based dialect and operation enrichment* from MLIRod. Run this script with the same command as MLIRod.