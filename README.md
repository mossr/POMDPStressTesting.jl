# POMDPStressTesting.jl
Adaptive stress testing of black-box systems, implemented within the [POMDPs.jl](https://github.com/JuliaPOMDP/POMDPs.jl) ecosystem.

# Interface
To stress test a new system, the user has to define the `GrayBox` and `BlackBox` interface outlined in [`src/GrayBox.jl`](https://github.com/mossr/POMDPStressTesting.jl/blob/master/src/GrayBox.jl) and [`src/BlackBox.jl`](https://github.com/mossr/POMDPStressTesting.jl/blob/master/src/BlackBox.jl).

### GrayBox Interface
The `GrayBox` simulator and environment interface includes:
* `Simulation` type to hold simulation variables
* `environment(sim::Simulation)` to return the collection of environment distributions
* `transition!(sim::Simulation)` to transition the simulator, returning the log-likelihood

### BlackBox  Interface
The `BlackBox` system interface includes:
* `initialize!(sim::Simulation)` to initialize/reset the system under test
* `evaluate!(sim::Simulation)` to evaluate/execute the system under test
    * `distance!(sim::Simulation)` to return how close we are to an event
    * `isevent!(sim::Simulation)` to indicate if a failure event occurred
* `isterminal!(sim::Simulation)` to indicate the simulation is in a terminal state

All of these functions can modify the `Simulation` object in place.


# Solvers
Several solvers are implemented.

#### Reinforcement learning solvers
* [`MCTSPWSolver`](https://github.com/mossr/POMDPStressTesting.jl/blob/master/src/solvers/mcts.jl)

#### Deep reinforcement learning solvers<sup>1</sup>
* [`TRPOSolver`](https://github.com/mossr/POMDPStressTesting.jl/blob/master/src/solvers/drl/trpo.jl)
* [`PPOSolver`](https://github.com/mossr/POMDPStressTesting.jl/blob/master/src/solvers/drl/ppo.jl)

#### Stochastic optimization solvers
* [`CEMSolver`](https://github.com/mossr/POMDPStressTesting.jl/blob/master/src/solvers/cem.jl)

#### Baseline solvers
* [`RandomSearchSolver`](https://github.com/mossr/POMDPStressTesting.jl/blob/master/src/solvers/random_search.jl)


# Example

An example implementation of the AST interface is provided for the Walk1D problem: [`test/Walk1D.jl`](https://github.com/mossr/POMDPStressTesting.jl/blob/master/test/Walk1D.jl).

Below is a descriptive tutorial-style write-up: [`walk1d.pdf`](./test/pdf/walk1d.pdf) (created using [TeX.jl](https://github.com/mossr/TeX.jl))

<!-- (https://github.com/mossr/POMDPStressTesting.jl/blob/master/test/walk1d.pdf) -->

<kbd>
<p align="center">
  <a href="./test/pdf/walk1d.pdf">
    <img src="./test/svg/walk1d.svg">
  </a>
</p>
</kbd>

<!-- With an accompanying notebook: [`Walk1D.ipynb`](https://github.com/mossr/POMDPStressTesting.jl/blob/master/notebooks/Walk1D.ipynb) -->

# Installation

Install the required forked packages then the `POMDPStressTesting.jl` package:
```julia
using Pkg
pkg"add https://github.com/sisl/POMDPPlayback.jl"
pkg"add https://github.com/mossr/CrossEntropyMethod.jl"
pkg"add https://github.com/mossr/MCTS.jl"
pkg"add https://github.com/sisl/POMDPStressTesting.jl"
```

---
Package maintained by Robert Moss: mossr@cs.stanford.edu

<sup>1</sup> TRPO and PPO thanks to [Shreyas Kowshik's](https://github.com/shreyas-kowshik/RL-baselines.jl) initial implementation.