Pod::Spec.new do |s|
  s.name = 'YSTabBar'
  s.version = '1.0.2'
  s.license = 'MIT'
  s.summary = 'YSTabBar is fully customizable tab bar controller which has unique center item.'
  s.homepage = 'https://github.com/eresar01/YSTabBar'
  s.authors = { 'Yerem Sargsyan' => 'eresar01@gmail.com' }
  
  s.source = { :git => 'https://github.com/eresar01/YSTabBar.git', :tag => s.version.to_s }
  s.source_files = 'Sources/*.swift'
  s.swift_version = '5.0'
  s.platform = :ios, '15.0'

end