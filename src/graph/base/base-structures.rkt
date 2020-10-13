#lang racket

(require "../../util/structures.rkt")

(provide (all-defined-out))

(struct connection (id weight) #:transparent)

(struct edge (id1 id2) #:transparent)

(struct node (id position connections) #:transparent)

(struct graph (nodes) #:transparent)