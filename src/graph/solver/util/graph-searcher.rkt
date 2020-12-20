#lang racket

(provide (struct-out searcher))

(struct searcher (get set add remove map list))