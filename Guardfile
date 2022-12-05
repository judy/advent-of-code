guard :bundler do
  watch('Gemfile')
end

guard :shell do
  watch(/.*\.rb/) { |m| `./#{m[0]} test` }
end

clearing :on