
Pod::Spec.new do |s|

  s.name         = 'Navigator'
  s.version      = '0.5'
  s.summary      = 'URL-based view navigation for iOS'
  s.homepage     = 'http://github.com/derkis/NAVRouter'

  s.author       = { 'Ty Cobb' => 'ty.cobb.m@gmail.com' } 
  s.license      = { :type => 'MIT', :file => 'License.txt' }
 
  s.platform     = :ios, '7.0'
  s.source       = { :git => 'https://github.com/derkis/NAVRouter.git', :branch => 'api-redux' }
  s.requires_arc = true

  s.source_files = 'Navigator/*.{h,m}' 
  s.public_header_files = 'Navigator/*.h'
  
  s.dependency 'YOLOKit', '~> 11'
  
  yolo_preprocessor_defines = %w{
    last skip snip split join extend select map find concat uniq array dict 
  }.reduce('') do |memo, subspec|
    memo + "YOLO_#{subspec.upcase}=1 "
  end.strip

  s.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => yolo_preprocessor_defines }

end
