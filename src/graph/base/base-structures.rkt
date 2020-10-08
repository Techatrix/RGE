#lang racket

(require "../../util/structures.rkt")

(provide (all-defined-out))

(struct connection (id) #:transparent)

(struct node (id position connections) #:transparent)

(struct graph (nodes) #:transparent)