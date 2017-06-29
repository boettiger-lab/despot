# Despot
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

## Acknowledgements
[Original Despot implementation](https://github.com/AdaCompNUS/despot) was made by the [M<sup>2</sup>AP Group](http://bigbird.comp.nus.edu.sg/m2ap/wordpress/) from the National University of Singapore


**Currently in alpha state, package is working but can have errors**
