ruby tokyo-maker.rb > tokyo.rb
ruby tokyo.rb > 1.rb
ruby 1.rb > 2.rb && ruby 2.rb > 1.rb && ruby 1.rb > 2.rb && ruby 2.rb > 1.rb &&
ruby 1.rb > 2.rb && ruby 2.rb > 1.rb && ruby 1.rb > 2.rb && ruby 2.rb > 1.rb &&
ruby 1.rb > 2.rb && ruby 2.rb > 1.rb && ruby 1.rb > 2.rb && ruby 2.rb > 1.rb &&
ruby 1.rb > 2.rb && ruby 2.rb > 1.rb && ruby 1.rb > 2.rb && ruby 2.rb > 1.rb &&
ruby 1.rb > 2.rb && ruby 2.rb > 1.rb && ruby 1.rb > 2.rb && ruby 2.rb > 1.rb &&
ruby 1.rb > 2.rb && ruby 2.rb > 1.rb && ruby 1.rb > 2.rb && ruby 2.rb > 1.rb &&
ruby 1.rb > 2.rb && ruby 2.rb > 1.rb && ruby 1.rb > 2.rb && ruby 2.rb > 1.rb &&
echo "done"
diff tokyo.rb 1.rb | wc
