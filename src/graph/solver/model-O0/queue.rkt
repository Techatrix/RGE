#lang racket

(provide (all-defined-out))

(struct queue (data))

(define (queue-empty? _queue)
  (empty? (queue-data _queue)))

(define (queue->list _queue)
  (queue-data _queue))

(define (queue-enqueue _queue e)
  (queue (append (queue-data _queue) (list e))))

(define (queue-dequeue _queue)
  (values (queue (rest (queue-data _queue))) (car (queue-data _queue))))
