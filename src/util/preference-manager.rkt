#lang racket

(provide get-pref
         put-pref)

(define pref-file-path (build-path (find-system-path 'pref-dir) "rge-prefs.rktd"))

(define (get-pref name default)
  (get-preference
   name
   (lambda () default)
   'timestamp
   pref-file-path))

(define (put-pref name value)
  (put-preferences
   (list name)
   (list value)
   #f
   pref-file-path))