#lang typed/racket

(require/typed "../../../util/structures.rkt"
               [#:struct point ([x : Real] [y : Real])])

(require/typed "../../base/base-structures.rkt"
               [#:struct connection ([id : Integer])]
               [#:struct node ([id : Integer] [position : point] [connections : connection])]
               [#:struct graph ([nodes : (Listof node)])])