#lang racket

(require "../solver/model-O1/graph-convert.rkt")

(provide graph-model-convert)

(define (graph-model-convert graph-model-base level)
  ((case level
     [(0) graph-model-convert-O0]
     [(1) graph-model-convert-O1]
     [(2) graph-model-convert-O2]
     [(3) graph-model-convert-O3])
   graph-model-base))

(define (graph-model-convert-O0 graph-model-base) graph-model-base)             ; base -> untyped 
(define (graph-model-convert-O1 graph-model-base) (graph->binary-graph graph-model-base)) ; base -> untyped optimized
(define (graph-model-convert-O2 graph-model-base) graph-model-base)             ; base -> typed
(define (graph-model-convert-O3 graph-model-base) (error "No Implementation"))  ; base -> FFI