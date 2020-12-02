# Yavalath Repository

Project for 50.002 Computation Structures module.

## How to play

1. Take turns to place a piece of your colour on an empty hex.
1. If you form a four-in-a-row, you win.
1. If you form a three-in-a-row (without another four-in-a-row), you lose.

## What we did:

- Made a prototype [in C](misc/Yavalath.c)
- Designed a custom instruction set architecture and built [an assembler](bsim/prealpha.uasm)
- Hand-compiled our prototype code to [assembly](bsim/yavalath.uasm)
- Made an [emulator](misc/emulator.py) in python (with pygame) for testing
