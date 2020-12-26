#lang racket/base

(provide (struct-out searcher))

(struct searcher (get set add remove map list))
