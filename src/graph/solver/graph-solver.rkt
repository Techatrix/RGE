#lang racket

(require "../util/graph-model-convert.rkt")
(require (prefix-in O0: "model-O0/graph-model-O0.rkt"))
(require (prefix-in O1: "model-O1/graph-model-O1.rkt"))
(require (prefix-in O2: "model-O2/graph-model-O2.rkt"))
(require (prefix-in O3: "model-O3/graph-model-O3.rkt"))

(provide graph-solver)

(define (graph-solver graph level)
  (define solver (case level
                   [(0) void]
                   [(1) void]
                   [(2) void]
                   [(3) void]))
  (solver (graph-model-convert graph level)))