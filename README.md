# uvm_example_adder4
a simple adder4 example with UVM
Copyright (c) 2026 Fengjixiong

This is a basic example of how to use [UVM](https://www.accellera.org/downloads/standards/uvm)
with [Verilator](https://github.com/verilator/verilator).

reference project: https://github.com/antmicro/verilator-uvm-example

You may need to install some dependencies:

```sh
sudo apt update -y
sudo apt install -y bison flex libfl-dev help2man z3
# You may already have these:
sudo apt install -y git autoconf make g++ perl python3
```

Then, clone and build latest Verilator (5.050+):

```sh
git clone https://github.com/verilator/verilator
pushd verilator
autoconf
./configure
make -j `nproc`
popd
```

For the full instructions, visit Verilator's [documentation](https://verilator.org/guide/latest/install.html).

Next, download the UVM code:
```sh
cd ..
wget https://www.accellera.org/images/downloads/standards/uvm/UVM-1800.2-2020.3.1.tar.gz
tar -xvzf UVM-1800.2-2020.3.1.tar.gz
cd -
```

Now, set up the `UVM_HOME` environment variable to point to the extracted UVM sources.
We also need `PATH` to point to Verilator:

```sh
UVM_HOME="$(pwd)/1800.2-2020.3.1/src"
PATH="$(pwd)/verilator/bin:$PATH"
```

To build the simulation, run:

```sh
./run.sh
```
