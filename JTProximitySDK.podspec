Pod::Spec.new do |s|
  s.name         = "JTProximitySDK"
  s.version      = "1.15.0-beta.1"
  s.summary      = "iOS library for Jointag Proximity"
  s.homepage     = "https://www.jointag.com/"
  s.author       = "Next14 S.p.A."
  s.platform     = :ios
  s.source       = {
    :git => "https://github.com/jointag/JTProximitySDK-iOS.git",
    :tag => "#{s.version}"
  }
  s.ios.deployment_target = '9.0'
  s.vendored_frameworks = 'Library/JTProximitySDK.xcframework'
  s.frameworks = 'UIKit', 'Foundation', 'SystemConfiguration', 'MobileCoreServices', 'CoreLocation', 'CoreTelephony', 'AdSupport', 'WebKit'
  s.license    = {
    :type => "Copyright",
    :text => <<-LICENSE
      Copyright 2022 Next14 S.p.A. All rights reserved.
      LICENSE
  }

end
