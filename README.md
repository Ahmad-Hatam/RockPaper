This project combines a Rock-Paper-Scissors game with a Cellular Automaton-based random number generator. Both players are computer-controlled, creating an intriguing blend of computational randomness and strategic decision-making, all written in assembly language.


The project consists of three main components:

Main Program (main.s): This file orchestrates the game's execution, including setting up configurations, simulating gameplay, and terminating the program after a specified number of iterations.

Cellular Automaton (automaton.s): Responsible for generating random bits used in the game. It converts numbers into binary and simulates an elementary cellular automaton to produce pseudo-random sequences.

Rock Paper Scissors Logic (rps.s): Implements the game logic, including player moves, determining winners, and displaying results.

Testing:
You can test the implementation by running the provided run_tests script. It executes your code against test cases stored in the tests/ directory. Each test comprises two files: {testname}.s (main program) and {testname}.ref (expected output).
