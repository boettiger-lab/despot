# despot
## Overview
Wrapper for the DESPOT algorithm for solving online POMDP problems.

## Requirements
Tested Operating Systems :
* Ubuntu 16.04 LTS with gcc 5.4.0
* OSX Yosemite ? with gcc 4.1.0

## Usage

    library('despot')
    result = despot(TT,OO,R,gamma)

where ```TT```, ```OO``` and ```R``` are the Transition, Observation and Reward matrices, and ```gamma``` the discount factor.

**Currently in alpha state, package is working but can have errors**
