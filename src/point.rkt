#lang racket/gui
(require "util.rkt")

(provide point-class)
(provide point-d)
(provide point-r)

(define point-d 50)
(define point-r (/ point-d 2))

(define (remove-con-i-extern i connections)
  (cond [(empty? connections) '()]
        [(eq? (car (car connections)) i) (rest connections)]
        [else (append (list (car connections)) (remove-con-i-extern i (rest connections)))]))

; Point Class
(define point-class
  (class object%
    (init-field [id 0]
                [position '(0 0)]
                [connections '()])
    ; Getter
    (define/public (get-id) id)
    (define/public (get-pos) position)
    (define/public (get-pos-x) (car position))
    (define/public (get-pos-y) (car (cdr position)))
    (define/public (get-con) connections)
    ; Draw
    (define/public (draw-point dc) (send dc draw-ellipse (send this get-pos-x) (send this get-pos-y) point-d point-d))
    (define/public (draw-connection dc x y)
      ; (send dc draw-line (+ (send this get-pos-x) point-r) (+ (send this get-pos-y) point-r) (+ x point-r) (+ y point-r))
      (draw-arrow dc (+ (send this get-pos-x) point-r) (+ (send this get-pos-y) point-r) (+ x point-r) (+ y point-r))

      )
    ; Util
    (define/public (ishit x y) (< (dst-PtoP (send this get-pos-x) (send this get-pos-y) x y) point-r))
    (define/public (add-con c) (set! connections (append connections (list c))) this) ; TODO: check for redefinition
    (define/public (remove-con-i i) (set! connections (remove-con-i-extern i connections)) this)
    (define/public (move-pos delta-pos) (set! position (list (+ (get-pos-x) (car delta-pos)) (+ (get-pos-y) (cadr delta-pos)))) this)
    
    (super-new)))