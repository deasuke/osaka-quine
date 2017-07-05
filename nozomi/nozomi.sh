ruby nozomi-maker.rb > nozomi.rb
ruby nozomi.rb > 1.rb
ruby 1.rb > 2.rb && ruby 2.rb > 1.rb && ruby 1.rb > 2.rb && ruby 2.rb > 1.rb &&
ruby 1.rb > 2.rb && ruby 2.rb > 1.rb && ruby 1.rb > 2.rb && ruby 2.rb > 1.rb &&
ruby 1.rb > 2.rb && ruby 2.rb > 1.rb && ruby 1.rb > 2.rb && ruby 2.rb > 1.rb &&
ruby 1.rb > 2.rb && ruby 2.rb > 1.rb && ruby 1.rb > 2.rb && ruby 2.rb > 1.rb &&
ruby 1.rb > 2.rb && ruby 2.rb > 1.rb && ruby 1.rb > 2.rb &&
echo "done"
diff nozomi.rb 2.rb | wc
