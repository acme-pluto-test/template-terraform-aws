# The bundled terraform ruleset needs no plugin download. The platform workflow runs tflint --init and tflint --recursive.
config {
  call_module_type = "local"
}

plugin "terraform" {
  enabled = true
  preset  = "recommended"
}
