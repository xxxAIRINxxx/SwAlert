Pod::Spec.new do |s|
  s.name             = "SwAlert"
  s.version          = "0.1.5"
  s.summary          = "Wrapper of UIAlertView & UIAlertController. written in Swift."
  s.homepage         = "https://github.com/xxxAIRINxxx/SwAlert"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Airin" => "xl1138@gmail.com" }
  s.source           = { :git => "https://github.com/xxxAIRINxxx/SwAlert.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'SwAlert/*.swift'
end
