#
#  Be sure to run `pod spec lint MMNavigationController.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|


  s.name         = "VerificationCodeButton"
  s.version      = "0.1.0"
  s.summary      = "iOS app SMS code verification button"

  s.description  = <<-DESC
  SMS code verification button
  flexible!
                   DESC

  s.homepage     = "https://github.com/MangoMade/MMNavigationController"

  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "MangoMade" => "781132399@qq.com" }
  s.platform     = :ios, "8.0"


  s.source       = { :git => "https://github.com/MangoMade/VerificationCodeButton.git", :tag => "#{s.version}" }

  s.source_files  = "Source/*.swift"

  s.requires_arc = true


end
