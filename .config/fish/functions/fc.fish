function fc --description 'Build and jump evaluation pipelines local to forecash structures'
  pushd ~/code/forecash/cli
  go build
  forecash
  popd
end
