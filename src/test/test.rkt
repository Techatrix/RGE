#lang racket/base

(require rackunit
         rackunit/gui)

(require "structures-test.rkt")
(require "util-test.rkt")
(require "util-test.rkt")
(require "solver/solver-test.rkt")

(test/gui
 (test-suite
  "All Tests"
  vec2-test-suite
  util-test-suite
  graph-solver-test-suite)
 #:wait? #t)
