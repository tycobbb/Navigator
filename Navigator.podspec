
Pod::Spec.new do |s|

  s.name         = 'Navigator'
  s.version      = '0.5'
  s.summary      = 'URL-based view navigation for iOS'
  s.homepage     = 'http://github.com/derkis/NAVRouter'
  s.author       = { 'Ty Cobb' => 'ty.cobb.m@gmail.com' } 
  s.license      = { :type => 'MIT', :file => 'License.txt' }
 
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.source       = { :git => 'https://github.com/derkis/NAVRouter.git', :branch => 'api-redux', :submodules => true }
  
  s.subspec 'Core' do |ss|
    paths = [ '', 'Router/', 'Routes/', 'Transitions/', 'Updates/', 'Shared/' ].map do |dir|
      "Navigator/#{dir}"
    end

    ss.source_files = paths.map { |path| path + '*.{h,m}' }
    ss.public_header_files = paths.map { |path| path + '*.h' } 
  end

  s.subspec 'View' do |ss|
    ss.dependency 'Navigator/Core'
    ss.source_files = 'Navigator/View/*.{h,m}'
    ss.public_header_files = 'Navigator/View/*.h'
    ss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'NAVIGATOR_VIEW' }
  end
  
  s.dependency 'YOLOKit', '~> 11'
  
  yolo_preprocessor_defines = %w{
    last skip snip split join extend select map find concat uniq array dict first inject flatten
  }.reduce('') do |memo, subspec|
    memo + "YOLO_#{subspec.upcase}=1 "
  end.strip

  s.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => yolo_preprocessor_defines }

end
