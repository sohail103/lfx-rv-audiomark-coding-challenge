# LFX Mentorship Coding Challenge: RISC-V AudioMark

**Author:** Sohail Raj Satapathy

This repository contains my solution to the LFX Mentorship Program RISC-V AudioMark coding challenge.
The task is to implement a saturating multiply-accumulate (Q15 AXPY) function accelerated using RISC-V Vector (RVV) intrinsics.

The function computes:
`y[i] = sat_q15(a[i] + alpha*b[i])` for all i in [0,n)

## Repository Structure

- src/   -> Solution with reference and harness
- asm/   -> Generated assembly (scalar and RVV versions)
- stats/ -> gem5 statistics output for selected runs (LMUL=2 on MinorCPU and O3CPU) and simulation logs

## Summary of Approach

1. Uses widening multiply-accumulate(`vwmacc`) to fuse multiply and add
2. Accumulates in 32-bit and narrows back to Q15 using vnclip with saturation
3. Vector-length agnostic via strip-mined loop using `vsetvl`

A detailed explanation of instruction choices and performance analysis is available in [PDF](CodingChallenge-lfx-rv-audiomark-SohailRajSatapathy.pdf)

## Correctness

Correctness is validated using the provided test harness. The implementation with RVV intrinsics produces bit-for-bit identical results to the scalar reference by preserving arithmetic order and using saturated narrowing.

gem5 simulation output: 
```
**** REAL SIMULATION ****
Cycles ref: 101527
Verify RVV: OK (max diff = 0)
Cycles RVV: 6961
Exiting @ tick 196358500 because exiting with last active thread context
```

Full simulation logs are available in `stats/simulation1.log` and `stats/simulation2.log`

## Build Instructions

Example build using Clang for code generation and gcc for linking:
```bash
clang -O3 -c --target=riscv64-elf -march=rv64gcv -mabi=lp64d -mno-relax -fno-vectorize -o q15_axpy_challenge.o src/q15_axpy_challenge.c

riscv64-elf-gcc -march=rv64gcv -mabi=lp64d -static -o q15_axpy_challenge q15_axpy_challenge.o
```

The produced binary can be run on simulators such as 
- gem5
- spike
- QEMU
The harness prints correctness status and rough cycle counts

## Performance

Performance was profiled using gem5 to analyze behavior on both In-Order (MinorCPU) and Out-of-Order (O3CPU) microarchitectures (VLEN=256)
- Up to ~20x speedup over scalar (no auto-vectorization)
- Performance depends on LMUL and microarchitecture
- Detailed cycle counts and analysis are included in the document along with a deep dive into pipeline stalls caused by `vsetvli` toggling on in-order cores vs. out-of-order cores.
See: [PDF](CodingChallenge-lfx-rv-audiomark-SohailRajSatapathy.pdf)

## Generated Assembly

The following files contain the generated assembly for comparison:
- `asm/rvv-generated-assembly.s`
- `asm/scalar-no-vectorize-generated-assembly.s`
- `asm/scalar-vectorized-generated-assembly.s`
These were used to analyze instruction selection and VTYPE behavior.

## Notes

- The RVV intrinsics implementation targets the ratified RVV Intrinsics v1.0 specification (`__riscv_v_intrinsic >= 1000000`)
- Older draft headers use a different `vnclip` signature (no explicit `vxrm` argument); these are excluded via preprocessor guards and fall back to the scalar implementation.
- Due to the use of `printf`, `aligned_alloc` and `rand` in the provided harness, the program is built in a hosted environment against a standard C runtime rather than as a strictly freestanding bare-metal binary.
- The program was validated using gem5's Syscall Emulation (SE) mode. This avoids the overhead of Full System simulation while supporting standard C runtime calls like `printf`.
