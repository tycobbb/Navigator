
Pod::Spec.new do |s|

  s.name         = 'Navigator'
  s.version      = '0.5'
  s.summary      = 'URL-based view navigation for iOS'
  s.homepage     = 'http://github.com/derkis/NAVRouter'

  s.author       = { 'Ty Cobb' => 'ty.cobb.m@gmail.com' } 
  s.license      = { :type => 'MIT', :file => 'License.txt' }
 
  s.platform     = :ios, '7.0'
  s.source       = { :git => 'https://github.com/derkis/NAVRouter.git', :branch => 'api-redux', :submodules => true }
  s.requires_arc = true

  s.source_files = 'Navigator/*.h'
  s.public_header_files = 'Navigator/*.h' 

  s.subspec 'Router' do |ss|
    ss.source_files = 'Navigator/Router/*.{h,m}'
  end

  s.subspec 'Transitions' do |ss|
    ss.dependency 'Navigator/Shared'
    ss.dependency 'Navigator/Updates'
    ss.source_files = 'Navigator/Transitions/*.{h,m}'
  end

  s.subspec 'Updates' do |ss|
    ss.dependency 'Navigator/Shared'
    ss.dependency 'Navigator/Routes'
    ss.source_files = 'Navigator/Updates/*.{h,m}'
  end

  s.subspec 'Routes' do |ss|
    ss.dependency 'Navigator/Shared'
    ss.source_files = 'Navigator/Routes/*.{h,m}'
  end

  s.subspec 'Internal' do |ss|
    ss.source_files = 'Navigator/Internal/*.{h,m}'
  end

  s.subspec 'View' do |ss|
    ss.source_files = 'Navigator/View/*.{h,m}'
  end
 
  s.subspec 'Shared' do |ss|
    ss.source_files = 'Navigator/Shared/*.{h,m}'
  end

  s.dependency 'YOLOKit', '~> 11'
  
  yolo_preprocessor_defines = %w{
    last skip snip split join extend select map find concat uniq array dict first inject flatten
  }.reduce('') do |memo, subspec|
    memo + "YOLO_#{subspec.upcase}=1 "
  end.strip

  s.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => yolo_preprocessor_defines }

end
