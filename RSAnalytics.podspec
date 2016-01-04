Pod::Spec.new do |s|
  s.name             = "RSAnalytics"
  s.version          = "0.1.0"
  s.summary          = "iOS Analytics event wrapper for Google Analytics, Fabric and Facebook."

  s.description      = <<-DESC
  A single class to send analytics events to, which in turn sends them to analytics tools such as Google Analytics, Fabric and Facebook.
                       DESC

  s.homepage         = "https://github.com/ricsantos/RSAnalytics"
  s.license          = 'Apache 2.0'
  s.author           = { "Ric Santos" => "rics@ntos.me" }
  s.source           = { :git => "https://github.com/ricsantos/RSAnalytics.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/ric__santos'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*.*'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Fabric'
  s.dependency 'Crashlytics'
  s.dependency 'FBSDKCoreKit'
  s.dependency 'GoogleAnalytics', '~> 3.14'
end
