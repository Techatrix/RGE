#lang racket

(define (graph-model-convert-O0 graph-model-base) graph-model-base) ; base -> untyped 
(define (graph-model-convert-O1 graph-model-base) graph-model-base) ; base -> untyped optimized
(define (graph-model-convert-O2 graph-model-base) (error "No Implementation")) ; base -> typed
(define (graph-model-convert-O3 graph-model-base) (error "No Implementation")) ; base -> FFI