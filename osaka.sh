ruby osaka-maker.rb > osaka.rb
ruby osaka.rb > 1.rb
ruby 1.rb > 2.rb && ruby 2.rb > 1.rb && ruby 1.rb > 2.rb && ruby 2.rb > 1.rb &&
ruby 1.rb > 2.rb && ruby 2.rb > 1.rb && ruby 1.rb > 2.rb && ruby 2.rb > 1.rb &&
ruby 1.rb > 2.rb && ruby 2.rb > 1.rb && ruby 1.rb > 2.rb && ruby 2.rb > 1.rb &&
ruby 1.rb > 2.rb && ruby 2.rb > 1.rb && ruby 1.rb > 2.rb && ruby 2.rb > 1.rb &&
ruby 1.rb > 2.rb && ruby 2.rb > 1.rb 
echo "done"
diff osaka.rb 1.rb | wc
