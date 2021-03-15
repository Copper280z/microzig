# Embedded Basics

In this tutorial, you'll learn the absolute basics of the embedded world:

## Contents

- [What are embedded systems?](#what-are-embedded-systems)
- Electronics 101
  - Current, voltage, power and all 
  - Diodes, Resistors, Capacitors
  - Ohm's law
  - LEDs and pre-resistors
  - MosFETs
- Breadboard vs. Soldering
- Digital I/O
- Analog I/O
- Bus Systems
  - UART
  - SPI
  - I²C / TWI

## What are embedded systems?

Wikipedia does a good job defining embedded systems with this opener:

> An embedded system is a computer system—a combination of a computer processor, computer memory, and input/output peripheral devices—that has a dedicated function within a larger mechanical or electrical system.

So at the end of the day, if you are adding any sort of computation to some object who's main purpose is not being a computer, it's an embedded system.

Some examples of Embedded systems:
- cars
- industrial control systems
- mars rovers

### Real time

An important characteristic that's often required for an embedded system is "real time".
This is simply the ability for the system to respond to an input within a hard deadline, Eg. automatic breaks for a car.
A general operating system like Linux is not suitable for these applications because it uses time sharing when scheduling tasks/programs, and unreliably responds to important signals.


