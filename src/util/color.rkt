#lang racket
(require racket/draw)

(provide (all-defined-out))

(define color-white (send the-color-database find-color "white"))
(define color-black (send the-color-database find-color "black"))
(define color-red (send the-color-database find-color "red"))
(define color-green (send the-color-database find-color "green"))
(define color-blue (send the-color-database find-color "blue"))
