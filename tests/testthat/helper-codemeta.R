
# Write codemeta.json file
try({
  devtools::install_github("codemeta/codemetar", quiet = T)
  codemetar::write_codemeta('../..', path = '../../docs/codemeta.json', force_update = F)
})
