; $Date: 2007-05-29 08:18:49 $
(load (expand-file-name "~/.emacs.d/init"))
(condition-case nil
    (load (expand-file-name "~/.emacs.d/custom"))
  (error nil))
