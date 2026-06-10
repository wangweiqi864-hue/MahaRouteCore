Pod::Spec.new do |s|
  s.name             = 'MahaRouteCore'
  s.version          = '0.1.2'
  s.summary          = 'A lightweight route parsing and dispatch core used by the app.'

  s.description      = <<-DESC
MahaRouteCore extracts the existing MHGlobalRouter capability into a private pod.
It keeps the current route parsing behavior while exposing renamed public APIs.
  DESC

  s.homepage         = 'https://github.com/wangweiqi864-hue/MahaRouteCore'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wangweiqi864-hue' => 'wangweiqi864-hue@users.noreply.github.com' }
  s.source           = { :git => 'https://github.com/wangweiqi864-hue/MahaRouteCore.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'

  s.source_files = 'MahaRouteCore/Classes/**/*'
  s.dependency 'MahaLogCore'
end
