Pod::Spec.new do |s|
  s.name         = "SwiftAutoLayout"
  s.version      = "1.0.0"
  s.summary      = "Tiny Swift SDL for Autolayout"
  s.homepage     = "https://github.com/indragiek/SwiftAutoLayout"
  s.author	     = { "Indragie Karunatne" => "i@indragie.com" }
  s.license      = "MIT"
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  s.source       = { :git => "https://github.com/indragiek/SwiftAutoLayout.git", :tag => "#{s.version}" }
  s.source_files = "Sources/*.{swift}"
  s.ios.framework = "UIKit"
  s.osx.framework = "Cocoa"
end
