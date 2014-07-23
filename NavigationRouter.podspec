
Pod::Spec.new do |s|

  s.name         = "NavigationRouter"
  s.version      = "0.0.1"
  s.summary      = "URL-based view navigation for iOS"
  s.homepage     = "http://github.com/derkis/NAVRouter"
  s.license      = "MIT"
  s.author       = { "Ty Cobb" => "ty.cobb.m@gmail.com" }
  
  s.platform     = :ios, '7.0'
  s.source       = { :git => 'https://github.com/derkis/NAVRouter.git' }
  s.requires_arc = true

  s.source_files   = 'NavigationRouter/*.{h,m}', 'NavigationRouter/YOLOKit/*.{h,m}'
  s.preserve_paths = 'NavigationRouter/YOLOKit/YOLO.ph'
  s.public_header_files = 'NavigationRouter/*.h'
  
  s.frameworks = 'Foundation', 'UIKit' 

end
