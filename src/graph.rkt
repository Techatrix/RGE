#lang racket/gui
(require "Point.rkt")

(provide graph-class)

(define (draw-points dc points)
  (cond [(empty? points) ]
        [else (draw-connections dc (car points) (send (car points) get-con) points)
              (send (car points) draw-point dc)
              (draw-points dc (rest points))]))

(define (draw-connections dc p con points)
  (cond [(empty? con) ]
        [else (let ([cp (get-point-i-extern (car (car con)) points)])
                (cond [(not (number? cp)) (send p draw-connection dc (send cp get-pos-x) (send cp get-pos-y))]))
              (draw-connections dc p (rest con) points)]))

(define (get-point-i-extern i points)
  (cond [(empty? points) -1]
        [(eq? (send (car points) get-id) i) (car points)]
        [else (get-point-i-extern i (rest points))]))

(define (get-point-p-extern pos points)
  (cond [(empty? points) -1]
        [(send (car points) ishit (car pos) (cadr pos)) (car points)]
        [else (get-point-p-extern pos (rest points))]))

(define (set-point-i-extern i p points)
  (cond [(empty? points) '()]
        [(eq? (send (car points) get-id) i) (append (list p) (rest points))]
        [else (append (car points) (set-point-i-extern i (list p) (rest points)))]))
; Move that Shit
(define (move-point-i-extern i delta-pos points)
  (cond [(empty? points) '()]
        [(eq? (send (car points) get-id) i) (append (list (send (car points) move-pos delta-pos)) (rest points))]
        [else (append (list (car points)) (move-point-i-extern i delta-pos (rest points)))]))

(define (remove-point-i-extern i points)
  (cond [(empty? points) '()]
        [(eq? (send (car points) get-id) i) (rest points)]
        [else (append (list (car points)) (remove-point-i-extern i (rest points)))]))

(define (add-connection-i-extern i con points)
  (cond [(empty? points) '()]
        [(eq? (send (car points) get-id) i) (append (list (send (car points) add-con con)) (rest points))]
        [else (append (list (car points)) (add-connection-i-extern i con (rest points)))]))

; Connection I to J and J to I
(define (remove-connection-ij-extern i j points)
  (cond [(empty? points) '()]
        [(eq? (send (car points) get-id) i) (append (list (send (car points) remove-con-i j)) (rest points))]
        [(eq? (send (car points) get-id) j) (append (list (send (car points) remove-con-i i)) (rest points))]
        [else (append (list (car points)) (remove-connection-ij-extern i j (rest points)))]))


(define graph-class
  (class object%
    (define points '())
    (define current-new-id 0)
    (define/public (get-points) points)
    (define/public (draw dc) (draw-points dc points))

    ; TODO: get smallest available id
    ; Start at (length points) to 0 and choose the smallest possible
    (define/private (get-available-id-extern pp)
      (cond [(empty? pp) '(+inf.0)]
            [else (min (car pp) (get-available-id-extern (rest pp)))]))
    (define/public (get-available-id)
      (get-available-id-extern points)
      ;(error "Does he look like a Bitch?")
      )
    
    ; Add Point
    ; I = ID, P = Position, C = Connection
    (define/public (add-point) (add-point-data (new point-class [id current-new-id])))
    (define/public (add-point-ipc i p c) (error "Very poor Choice of Words..."))
    (define/public (add-point-p p) (add-point-data (new point-class [id current-new-id] [position p])))
    (define/public (add-point-pc p c) (add-point-data (new point-class [id current-new-id] [position p] [connections c])))
    (define/public (add-point-data p)
      (set! points (append points (list p)))
      (set! current-new-id (add1 current-new-id)))
    ; Get Point
    (define/public (get-point-i i) (get-point-i-extern i points))
    (define/public (get-point-p pos) (get-point-p-extern pos points))
    (define/public (get-pointID-i i) (send (get-point-i i) get-id))
    
    ; Set Point
    (define/public (set-point-i i p)
      (set! points (set-point-i-extern i p points)))
    
    ; Remove Point
    (define/public (remove-point-i i)
        (cond [(eq? i -1)]
              [else (set! points (remove-point-i-extern i points))])
      ;TODO: remove Connections to Point
      )
    (define/public (remove-point-p pos)
      (let ([p (get-point-p pos)])
        (remove-point-i (send p get-id))))
    ; Move Point
    (define/public (move-point-i i delta-pos)
      (cond [(eq? i -1)]
            [else (set! points (move-point-i-extern i delta-pos points))])
      ;(error "Where's the Implementation, Lebowski!")
      )
    (define/public (move-point-p pos delta-pos)
      (let ([p (get-point-p pos)])
        (cond [(eq? p -1)]
              [else (move-point-i (send (get-point-p pos) get-id) delta-pos)])))
    
    ; Add Connection
    (define/public (add-connection-ij i j value)
      (set! points (add-connection-i-extern i (list j value) points))
      (set! points (add-connection-i-extern j (list i value) points))
      ;(error "WHERE'S THE FUCKING IMPLEMENTATION, SHITHEAD!")
      )
    (define/public (add-connection-pp pos1 pos2) ; Check against -1
      (add-connection-ij (send (get-point-p pos1) get-id) (send (get-point-p pos2) get-id) 0))
    ; Remove Connection
    (define/public (remove-connection-ij i j)
      (set! points (remove-connection-ij-extern i j points))
      ; (error "It's uh, it's down there somewhere. Lemme take another look.")
      )
    (define/public (remove-connection-pp pos1 pos2)
      (remove-connection-ij (send (get-point-p pos1) get-id) (send (get-point-p pos2) get-id)))
    
    (super-new)))




