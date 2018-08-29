(defun exs-load(dep)
  (interactive "sdep:")
  (alchemist-eval--expression (concat "Exs.Load.load " dep))
  )
