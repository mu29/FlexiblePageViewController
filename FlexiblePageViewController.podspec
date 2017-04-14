#
# Be sure to run `pod lib lint FlexiblePageViewController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FlexiblePageViewController'
  s.version          = '0.1.0'
  s.summary          = 'UIPageViewController for processing arbitrary data'

  s.homepage         = 'https://github.com/mu29/FlexiblePageViewController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mu29' => 'mu29@yeoubi.net' }
  s.source           = { :git => 'https://github.com/mu29/FlexiblePageViewController.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'FlexiblePageViewController/Classes/**/*'
  s.frameworks       = 'UIKit', 'Foundation'

end
