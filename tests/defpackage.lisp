;;; -*- mode:lisp; coding:utf-8 -*-

(/debug "perform test/defpackage.lisp!")

;;; Tests for defpackage

(test (defpackage :test-package))       ; we just define it
(test (eq (defpackage :test-package) (find-package :test-package)))

;; Since we didn't use `:use` before, we expect no exported symbols
(test (eq (find-symbol "CAR" :test-package) nil))
;; We redefine the package
(test (eq (defpackage :test-package (:use cl)) (find-package :test-package)))
;; Now we expect there to be symbols
(test (eq (find-symbol "CAR" :test-package) 'cl::car))
(test (unuse-package "CL" :test-package))
;; Now symbols should be gone
(test (eq (find-symbol "CAR" :test-package) nil))
(test (use-package "CL" :test-package))
(test (eq (find-symbol "CAR" :test-package) 'cl::car))

(test (delete-package :test-package))
(test (defpackage :test-package (:import-from cl cdr)))
(test (eq (find-symbol "CDR" :test-package) 'cl::cdr))

(test (delete-package :test-package))
(test (defpackage :test-package (:export cdr) (:import-from cl cdr)))
(test (eq (nth-value 1 (find-symbol "CDR" :test-package)) :external))

(test (defpackage :test-package-2 (:use :test-package)))
(test (eq (find-symbol "CDR" :test-package-2) 'cl::cdr))
;; Delete :test-package unuses it in :test-package-2
(test (delete-package :test-package))
(test (eq (find-symbol "CDR" :test-package-2) nil))
(test (equal (package-use-list :test-package-2) nil))
