# Event Sourcing in Elixir

**This is the code**

## Introduction

This repo is an explanation about how would I do event sourcing just using
the primitives of Erlang / Elixir. There are a few good libraries around, like
`commanded` that abstracts many of the concepts of CQRS / Event Sourcing. I want
to give another approach, which I also find interesting.

The basic concept behind Event Sourcing is the idea of a state machine, that
handles commands, events, you name it. In the literature about Event Sourcing
that state machine is the *aggregate*, where you keep an actual snapshot of the
current state of the entity, having processed an arbitrary number of events.
The main idea behind the *aggregate* is to isolate it's state, so it can be
responsible for handling his lifecycle by himself.

So this post will, step by step, build a real world solution for a specific domain: supply chain. To give a little more input on what we are proposing,
these are the domain rules:

1. We should support adding a new order to the system. How we are going to do it,
   it's via an REST API. Other methods may be supported at a later point.
2. We should allow our supply chain users to do changes on the quantities of
   the items in the order.
3. We should allow our supply chain users to be able to acknowledge an order 
   sending an confirmation via a webhook or e-mail to a given store.
4. We should allow our suply chain users to be able to split an order in different
   shipments, in case the order exceeds the capacity of a truck.
5. We should allow our supply chain users to be able to register and dispatch an
   invoice for an order, via e-mail or webhook.
6. We should allow our supply chain users to be able to register and track when
   the deliveries of an order are leaving and have delivered the goods to a given
   store.

This domain has quite the complex requirements. Let's break it down in small
parts and start our implementation.