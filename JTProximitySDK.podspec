Pod::Spec.new do |s|
  s.name         = "JTProximitySDK"
  s.version      = "1.12.0"
  s.summary      = "iOS library for Jointag Proximity"
  s.homepage     = "https://www.jointag.com/"
  s.author       = "Jointag S.r.l."
  s.platform     = :ios
  s.source       = {
    :git => "https://github.com/jointag/JTProximitySDK-iOS.git",
    :tag => "#{s.version}"
  }
  s.ios.deployment_target = '8.0'
  s.vendored_frameworks = 'Library/JTProximitySDK.xcframework'
  s.frameworks = 'UIKit', 'Foundation', 'SystemConfiguration', 'MobileCoreServices', 'CoreLocation', 'CoreTelephony', 'AdSupport', 'WebKit'
  s.license    = {
    :type => "Copyright",
    :text => <<-LICENSE
      Copyright 2020 Jointag S.r.l. All rights reserved.
      LICENSE
  }

end
