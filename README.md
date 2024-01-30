

# MLIRod

Welcome to the home page of MLIRod's repository, which contains three folders:

``src`` contains the source code of MLIRod.

``exp`` contains the experiment script of MLIRod.

``data`` contains the experiment data of MLIRod.

```scripts``` contains the fuzz script that uses MLIRod.

# Build MLIRod

Use following commands to build MLIRod:

```
mkdir build
cd build
cmake -G Ninja ../llvm \
  -DLLVM_ENABLE_PROJECTS=mlir \
  -DLLVM_BUILD_EXAMPLES=ON \
  -DLLVM_TARGETS_TO_BUILD="X86;NVPTX;AMDGPU" \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_ENABLE_ASSERTIONS=ON
cmake --build .
```

---

You can use additional settings:

```
-DCMAKE_C_COMPILER=afl-cc \
-DCMAKE_CXX_COMPILER=afl-c++ \
```
to support AFL instrumentation for edge coverage collection.

---

or use settings:
```
-DCMAKE_C_FLAGS="-g -O0 -fprofile-arcs -ftest-coverage" \
-DCMAKE_CXX_FLAGS="-g -O0 -fprofile-arcs -ftest-coverage" \
-DCMAKE_EXE_LINKER_FLAGS="-g -fprofile-arcs -ftest-coverage -lgcov" \
```
to enable gcov for line coverage collection.

---

To use MLIRod, you can find ```mlirfuzz.py``` in ```script```, and run the following command:

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

You can use ```--help``` to obtain more inforamtion about the settings.