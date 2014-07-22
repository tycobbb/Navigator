
Pod::Spec.new do |s|

  s.name = 'NavigationRouter'
  s.version = '0.0.1'
  s.license = 'MIT'

  s.source = { :git => 'https://github.com/derkis/NAVRouter', :branch => 'master' }
  s.source_files = 'NavigationRouter/*.{h,m}'
  s.requires_arc = true

  s.dependency 'YOLOKit', '~> 11'

end

