#lang racket
(require "gui/gui.rkt")

(define gui
  (new gui%
       [label "Graph Note Explorer"]
       [width 600]
       [height 600]))

(send gui show #t)