Pod::Spec.new do |s|
  s.name = "ZeroFormatter.swift"
  s.version = "0.0.1"
  s.summary = "Implementation of ZeroFormatter in Swift."
  s.homepage = "https://github.com/yaslab/ZeroFormatter.swift"
  s.license = "MIT"
  s.author = { "Yasuhiro Hatta" => "hatta.yasuhiro@gmail.com" }
  s.source = { :git => "https://github.com/yaslab/ZeroFormatter.swift.git", :tag => s.version, :submodules => false }
  #s.social_media_url = 'https://twitter.com/...'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.requires_arc = true

  s.source_files = 'Sources/*.swift'
  s.module_name = 'ZeroFormatter'
end
