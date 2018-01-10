;;; open-in-msvs.el --- Open current file:line:column in Microsoft Visual Studio  -*- lexical-binding: t; -*-

;; Copyright (C) 2016 Evgeny Panasyuk

;; Author: Evgeny Panasyuk
;; URL: https://github.com/evgeny-panasyuk/open-in-msvs
;; Version: 0.2
;; Keywords: convenience, usability, integration, Visual Studio, MSVS, IDE

;;; License:

;; Permission is hereby granted, free of charge, to any person or organization
;; obtaining a copy of the software and accompanying documentation covered by
;; this license (the "Software") to use, reproduce, display, distribute,
;; execute, and transmit the Software, and to prepare derivative works of the
;; Software, and to permit third-parties to whom the Software is furnished to
;; do so, all subject to the following:
;; 
;; The copyright notices in the Software and this entire statement, including
;; the above license grant, this restriction and the following disclaimer,
;; must be included in all copies of the Software, in whole or in part, and
;; all derivative works of the Software, unless such copies or derivative
;; works are solely in the form of machine-executable object code generated by
;; a source language processor.
;; 
;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
;; SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
;; FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
;; ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
;; DEALINGS IN THE SOFTWARE.

;;; Commentary:

;; Opens current file:line:column within active instance of Visual Studio or
;; starts new one.
;;
;; Bind the following command:
;; open-in-msvs


;;; Code:

(require 's)

(defun open-in-msvs--cygpath-to-windows (filename)
  "Convert filename to a Windows path with cygpath."
  (s-trim
   (shell-command-to-string
    (format "cygpath --windows %s"
            (shell-quote-argument filename)))))

(defvar open-in-msvs--path-to-vbs (concat (file-name-directory
                                           (or load-file-name
                                               (buffer-file-name))) "open-in-msvs.vbs"))
(when (eq system-type 'cygwin)
  (setq open-in-msvs--path-to-vbs (open-in-msvs--cygpath-to-windows open-in-msvs--path-to-vbs)))


;; Main function
;;;###autoload
(defun open-in-msvs ()
  "Opens current file:line:column within active instance of Visual Studio or start new one."
  (interactive)
  (save-restriction
    (widen)
    (let ((filename (if (eq system-type 'cygwin)
                        (open-in-msvs--cygpath-to-windows (buffer-file-name))
                      (buffer-file-name))))
      (call-process "cmd.exe"
                    nil nil nil
                    "/C" 
                    open-in-msvs--path-to-vbs filename
                    (number-to-string (line-number-at-pos)) (number-to-string (current-column))))))


(provide 'open-in-msvs)
;;; open-in-msvs.el ends here
