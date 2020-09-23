#lang racket
(require "gui.rkt")

(define gui
  (new gui%
       [label "Graph Note Explorer | Experimental GUI"]
       [width 600]
       [height 600]))

(send gui show #t)