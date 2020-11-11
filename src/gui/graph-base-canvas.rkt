#lang racket/gui

(require "view-canvas.rkt")
(require "../graph/base/base.rkt")
(require "util.rkt")
(require "../util/util.rkt")

(provide graph-base-canvas%
         inherit-from-graph-base-canvas)

(define graph-base-canvas%
  (class view-canvas%
    (init-field [graph (graph-make)])
    
    (define/public (get-graph) graph)
    
    (define/public (set-graph! new-graph)
      (set! graph (if (void? new-graph) (graph-make) new-graph))
      (send this refresh))
    ; single
    (define/public (base-add-node-proc proc position)
      (base-add-nodes-proc proc #:positions (list position)))
    (define/public (base-delete-node-proc proc node-id)
      (base-apply-nodes-proc proc (list node-id)))
    (define/public (base-copy-node-proc proc position node)
      (base-copy-nodes position (list node)))
    (define/public (base-move-node-proc proc node-id)
      (base-apply-nodes-proc proc (list node-id)))
    ; single preset
    (define/public (base-add-node position) (base-add-nodes #:positions (list position)))
    (define/public (base-delete-node node-id) (base-delete-nodes (list node-id)))
    (define/public (base-copy-node position node) (base-copy-nodes position (list node)))
    (define/public (base-move-node node-id) (base-move-nodes (list node-id)))
    ; multiple
    (define/public (base-add-nodes-proc
                     proc
                     #:positions [positions #f]
                     #:connections-list [connections-list #f])
      (define _proc
        (lambda (_graph _positions _connections-list)
          (define-values (_position _rest-positions)
            (if (or (not _positions) (empty? _positions))
                (values #f #f)
                (values (car _positions) (rest _positions))))

          (define-values (_connections _rest-connections)
            (if (or (not _connections-list) (empty? _connections-list))
                (values #f #f)
                (values (car _connections-list) (rest _connections-list))))
        
          (cond [(and (not _position) (not _connections)) _graph]
                [else (define new-graph (proc _graph _position _connections))
                      (_proc new-graph _rest-positions _rest-connections)])))
      (_proc graph positions connections-list))

    (define/public (base-copy-nodes-proc proc position nodes)
      (define center (nodes-get-center nodes))
      (define positions (map (lambda (node)
                               (vec2-add position (vec2-sub (node-position node) center))) nodes))
      (define connections-list (map (lambda (node) (node-connections node)) nodes))
      (base-add-nodes-proc proc #:positions positions #:connections-list connections-list))
    
    (define/public (base-apply-nodes-proc proc node-ids)
      (foldl (lambda (id _graph)
                (proc _graph id))
              graph node-ids))
    ; multiple preset
    (define/public (base-add-nodes
                     #:positions [positions #f]
                     #:connections-list [connections-list #f])
      (set-graph!
       (base-add-nodes-proc
       (lambda (_graph _position _connections)
          (graph-add-node
           _graph
           #:position _position
           #:connections _connections))
       #:positions positions
       #:connections-list connections-list)))
    (define/public (base-delete-nodes node-ids)
      (set-graph!
       (base-apply-nodes-proc
        (lambda (_graph id)
           (graph-delete-node _graph id))
        node-ids)))
    (define/public (base-copy-nodes position nodes)
      (set-graph!
       (base-copy-nodes-proc
       (lambda (_graph _position _connections)
          (graph-add-node
           _graph
           #:position _position
           #:connections _connections))
       position
       nodes)))
    (define/public (base-move-nodes node-ids delta-position)
      (set-graph!
       (base-apply-nodes-proc
       (lambda (_graph id)
          (define position (graph-get-node-position _graph id))
          (define new-position (vec2-add position (vec2-div delta-position
                                                            (send this get-scale))))
          (graph-set-node-position _graph id new-position))
       node-ids)))
    ; connection
    ; 1-1 = One <-> One
    ; 1-M = One <-> Multiple
    ; 1-A = One <-> All
    (define/public (base-connections-1-1 proc _graph id1 id2 [direction '->])
      (case direction
        [(->) (proc _graph id1 id2)]
        [(<-) (proc _graph id2 id1)]
        [(<->)
         (proc _graph id1 id2)
         (proc _graph id2 id1)]))

    (define/public (base-connections-1-M proc _graph id node-ids [direction '->])
      (foldl (lambda (_id __graph)
          (if (eq? id _id)
              __graph
              (base-connections-1-1 proc __graph id _id direction))
        ) _graph node-ids))
    
    (define/public (base-connections-1-A proc _graph id [direction '->])
      (foldl (lambda (node __graph)
          (if (eq? id (node-id node))
              __graph
              (base-connections-1-1 proc __graph id (node-id node) direction))
          ) _graph (graph-nodes _graph)))
    ; connection preset
    (define/public (base-add-connections-1-1 id1 id2 [direction '->])
      (set-graph!
       (base-connections-1-1 graph-set-node-add-connection graph id1 id2 direction)))

    (define/public (base-add-connections-1-M id node-ids [direction '->])
      (set-graph!
       (base-connections-1-M graph-set-node-add-connection graph id node-ids direction)))

    (define/public (base-add-connections-1-A id [direction '->])
      (set-graph!
       (base-connections-1-A graph-set-node-add-connection graph id direction)))

    
    (define/public (base-delete-connections-1-1 id1 id2 [direction '->])
      (set-graph!
       (base-connections-1-1 graph-set-node-delete-connection graph id1 id2 direction)))

    (define/public (base-delete-connections-1-M id node-ids [direction '->])
      (set-graph!
       (base-connections-1-M graph-set-node-delete-connection graph id node-ids direction)))

    (define/public (base-delete-connections-1-A id [direction '->])
      (set-graph!
       (base-connections-1-A graph-set-node-delete-connection graph id direction)))

    (super-new)))

(define-syntax (inherit-from-graph-base-canvas stx) 
  (datum->syntax stx '(inherit get-graph
                               set-graph!
                               base-add-node-proc
                               base-delete-node-proc
                               base-copy-node-proc
                               base-move-node-proc
                               base-add-node
                               base-delete-node
                               base-copy-node
                               base-move-node
                               base-add-nodes-proc
                               base-copy-nodes-proc
                               base-apply-nodes-proc
                               base-add-nodes
                               base-delete-nodes
                               base-copy-nodes
                               base-move-nodes
                               base-connections-1-1
                               base-connections-1-M
                               base-connections-1-A
                               base-add-connections-1-1
                               base-add-connections-1-M
                               base-add-connections-1-A
                               base-delete-connections-1-1
                               base-delete-connections-1-M
                               base-delete-connections-1-A)))