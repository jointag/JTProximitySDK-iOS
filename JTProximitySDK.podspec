Pod::Spec.new do |s|
  s.name         = "JTProximitySDK"
  s.version      = "1.2.0-stable"
  s.summary      = "iOS library for Jointag Proximity"
  s.homepage     = "https://www.jointag.com/"
  s.author             = "Jointag S.r.l."
  s.platform     = :ios
  s.source       = { :git => "https://github.com/jointagdev/JTProximitySDK.git", :tag => "#{s.version}" }
  s.source_files  = "Library/JTProximitySDK.framework/Headers/JTProximitySDK.*"
  s.vendored_frameworks = 'Library/JTProximitySDK.framework'
  s.ios.deployment_target = '8.0'
  s.resources = ["Library/JTProximitySDK.bundle"]
  s.frameworks = 'UIKit', 'Foundation', 'SystemConfiguration', 'MobileCoreServices', 'CoreLocation', 'CoreBluetooth'
  s.requires_arc = true
  s.xcconfig  =  {
    'LIBRARY_SEARCH_PATHS' => '"$(PODS_ROOT)/JTProximitySDK"',
    'HEADER_SEARCH_PATHS' => '"${PODS_ROOT}/Headers/JTProximitySDK"'
  }
  s.license      = {
    :type => "Copyright",
    :text => <<-LICENSE
      Copyright 2017 Estimote, Inc. All rights reserved.
      LICENSE
  }

end
