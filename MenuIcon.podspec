#
# Be sure to run `pod lib lint MenuIcon.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MenuIcon'
  s.version          = '0.1.0'
  s.summary          = 'MenuIcon is used to display a menu icon which can auto change it\'s appearance to close or back style.'

  s.description      = <<-DESC
  MenuIcon default displays a icon with three lines(usually known as `hamburger`), and you can change it to a close or back or any other styles if you want. It can be used as a navigation item's custom view, so you can easily change it's apearance when user clicked was received.
                       DESC

  s.homepage         = 'https://github.com/hyice/MenuIcon'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'hyice' => 'hyice.zhang@gmail.com' }
  s.source           = { :git => 'https://github.com/hyice/MenuIcon.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'MenuIcon/*.swift'
  s.swift_version = '4.0'
end
