#lang racket
(require ffi/unsafe
         ffi/unsafe/define
         racket/path)

(provide graphMake
         graphSolve
         graphSolveResultResponse
         graphSolveResultPathSize
         graphSolveResultPath
         printGraph
         is-available)

(define ffi-lib-path-pref
  (get-preference 'ffi-lib-path
                   (lambda () #f)
                   'timestamp
                   (build-path (find-system-path 'pref-dir) "rge-prefs.rktd")))

(define ffi-lib-path
  (cond [(and (path-string? ffi-lib-path-pref) (file-exists? ffi-lib-path-pref)) ffi-lib-path-pref]
        [else #f]))

(define-values (lib is-available)
  (cond [(not ffi-lib-path) (values #f #f)]
        [else (values (ffi-lib ffi-lib-path) #t)]))

(define-ffi-definer define-curses lib #:default-make-fail make-not-available)


(define _uID _long)
(define _size_t _ulong)

(define _Graph-pointer (_cpointer 'Graph))
(define _SolveResult-pointer (_cpointer 'SolveResult))

(define _Vector2 (_list-struct _float _float))
(define _Connection (_list-struct _uID _float))

(define-curses graphMake
  (_fun
   [_int = (if (= (length ids)
                  (length positions)
                  (length connectionCounts)
                  (length connections))
               (length ids)
               (error "Invalid Graph"))]
   [ids : (_list i _uID)]
   [positions : (_list i _Vector2)]
   [connectionCounts : (_list i _size_t)]
   [connections : (_list i (_list i _Connection))]
   -> _Graph-pointer))

(define-curses graphSolve
  (_fun
   [graph : _Graph-pointer]
   [rootNodeID : _uID]
   [goalNodeID : _uID]
   [solveMode : _int]
   [searcherMode : _int]
   -> _SolveResult-pointer))

(define-curses graphSolveResultResponse
  (_fun
   [result : _SolveResult-pointer]
   -> _int))

(define-curses graphSolveResultPathSize
  (_fun
   [result : _SolveResult-pointer]
   -> _size_t))

(define-curses graphSolveResultPath
  (_fun
   [result : _SolveResult-pointer]
   [path : (_list o _uID (graphSolveResultPathSize result))]
   -> _void -> path))

(define-curses printGraph
  (_fun
   [graph : _Graph-pointer]
   -> _string))
