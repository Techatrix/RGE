#lang racket

(require "graph-ffi.rkt")

(provide graph-model-convert)

(define (graph-model-convert graph-model-base level)
  (cond [(eq? level 3) (graph-model-convert-O3 graph-model-base)]
        [else graph-model-base]))

(define (graph-model-convert-O0 graph-model-base) graph-model-base)             ; base -> untyped 
(define (graph-model-convert-O1 graph-model-base) graph-model-base)             ; base -> untyped optimized
(define (graph-model-convert-O2 graph-model-base) graph-model-base)             ; base -> typed
(define (graph-model-convert-O3 graph-model-base) (ffi:graph->ffi-graph graph-model-base))  ; base -> FFI
