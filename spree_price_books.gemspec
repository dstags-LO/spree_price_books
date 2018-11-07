# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_price_books'
  s.version     = '3.4.1'
  s.summary     = 'Price books allowing flexible product pricing.'
  s.description = s.summary
  s.required_ruby_version = '>= 2.0.0'

  s.author    = 'Jeff Dutil'
  s.email     = 'JDutil@BurlingtonWebApps.com'
  s.homepage  = 'http://www.spreecommerce.com'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'money-open-exchange-rates', '1.2.0'
  s.add_dependency 'spree_core', '~> 3.4.5'
  s.add_dependency 'validates_timeliness', '~> 3.0'

end
