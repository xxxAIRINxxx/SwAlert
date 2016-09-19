Pod::Spec.new do |s|
  s.name         = "SwAlert"
  s.version      = "1.0.0"
  s.summary      = "Wrapper of UIAlertController. written in Swift."
  s.homepage     = "https://github.com/xxxAIRINxxx/SwAlert"
  s.license      = 'MIT'
  s.author       = { "Airin" => "xl1138@gmail.com" }
  s.source       = { :git => "https://github.com/xxxAIRINxxx/SwAlert.git", :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.source_files = 'Sources/*.swift'
end
