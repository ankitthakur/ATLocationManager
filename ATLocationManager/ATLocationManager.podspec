#
# Be sure to run `pod lib lint ATLocationManager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |spec|
  spec.name             = 'ATLocationManager'
  spec.version          = '0.1.0'
  spec.summary          = 'Core Location library with user defined configurations for iOS and OSX'
  spec.swift_version    = '5.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  spec.description      = <<-DESC
Core Location library to fetch location with scheduled interval (as minimum interval difference) between consequtive locations with Best Accurary
                       DESC

  spec.homepage         = 'https://github.com/ankitthakur/ATLocationManager'
  # spec.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.author           = { 'Ankit Thakur' => 'ankitthakur85@icloud.com' }
  spec.source           = { :git => 'https://github.com/ankitthakur85/ATLocationManager.git', :tag => spec.version.to_s }
  # spec.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  spec.requires_arc = true
  spec.ios.deployment_target  = '10.0'
  spec.osx.deployment_target  = '10.10'

  spec.source_files       = 'ATLocationManager/Sources/Common/*.swift'
  spec.ios.source_files   = 'ATLocationManager/Sources/iOS/*.swift'
  spec.osx.source_files   = 'ATLocationManager/Sources/OSX/*.swift'

  # spec.resource_bundles = {
  #   'ATLocationManager' => ['ATLocationManager/Assets/*.png']
  # }

  # spec.public_header_files = 'Pod/Classes/**/*.h'
  spec.frameworks = 'CoreLocation'
  spec.ios.framework  = 'UIKit'
  spec.osx.framework  = 'AppKit'
  # spec.dependency 'AFNetworking', '~> 2.3'
end
