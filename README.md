# Asynchronous_pipeline
RISC-V : 5-stage pipelined Asynchronous RISC-V Design Project

## Features
- RISC-V based micro-architecture 
- 32-bit RISC-V ISA CPU core
- Support Asynchronous behavior with local handshakng
- NO Clock needed

## Projsect Aims
5-stage pipelined Asynchronous RV32I with RISC-V ISA & only Verilog

## Folder Structure
```
:clipboard: ~ (~OKprincess/projects/)
┣ :package: zaram_training (RISC-V based practice)
┗ :package: Asynchronous_pipeline
  ┣ :open_file_folder: README.md
  ┣ :open_file_folder: tb
  ┗ :open_file_folder: src
    ┣ :open_file_folder: core: components (e.g. adder, configs etc.)
    ┣ :open_file_folder: stages
    ┣ :open_file_folder: memory
    ┣ :open_file_folder: top
    ┗ :open_file_folder: diagrams
```

## TO DO
- [x] Implementation of basic 5-stage pipeline structure
- [ ] Transform the entire structure into 5 modules each according to 5 stages
- [ ] Implementation of Click template & basic circuit 
- [ ] Replace synchronous pipeline registers with asynchronous handshake registers
- [ ] Implement hazard control for asynchronous design
- [ ] Simulate and analyze performance
- [ ] FPGA implementation and testing



