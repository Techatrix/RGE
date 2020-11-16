#lang typed/racket

(require/typed "../../../util/structures.rkt"
               [#:struct vec2 ([x : Real] [y : Real])])

(require/typed "../../base/base-structures.rkt"
               [#:struct connection ([id : Nonnegative-Integer] [weight : Real])]
               [#:struct node ([id : Nonnegative-Integer] [position : vec2] [connections : connection])]
               [#:struct graph ([nodes : (Listof node)])])