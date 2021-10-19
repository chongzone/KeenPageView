
Pod::Spec.new do |s|
  s.name          = 'KeenPageView'
  s.version       = '1.0.0'
  s.summary       = '分段选择控件、页面滚动切换、支持自定义标题样式、扩展方便'
  s.homepage      = 'https://github.com/chongzone/KeenPageView'
  s.license       = { :type => 'MIT', :file => 'LICENSE' }
  s.author        = { 'chongzone' => 'chongzone@163.com' }
  
  s.requires_arc  = true
  s.swift_version = '5.0'
  s.ios.deployment_target = '9.0'
  s.source = { :git => 'https://github.com/chongzone/KeenPageView.git', :tag => s.version }
  
  s.source_files = 'KeenPageView/Classes/**/*'
# s.resource_bundles = {
#   'KeenPageView' => ['KeenPageView/Assets/*.png']
# }

end
