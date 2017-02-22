#
# Be sure to run `pod lib lint ABTableViewPullRefresh.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ABTableViewPullRefresh'
  s.version          = '0.1.0'
  s.summary          = 'A simple Pull-to-Refresh view based on the popular EGOTableViewPullRefresh.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
I was having lots of problems with the standard EGORefreshTableHeaderView.

Luckily, I found an upgraded version provided by cocoanetics. That version can be found here:https://www.cocoanetics.com/2009/12/how-to-make-a-pull-to-reload-tableview-just-like-tweetie-2/

The following is mostly their vanilla code. Though I did change a couple things, like changing the text to match what was in the previous version. Though, the Japanese text probably wasn't in Devin's original. :/

I also overrode the setFrame function to center the text elements inside the frame. The activity view and arrow, I left as was.
                       DESC

  s.homepage         = 'https://github.com/ABeard89/ABTableViewPullRefresh'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ABeard89' => 'anthony.beard89@gmail.com' }
  s.source           = { :git => 'https://github.com/ABeard89/ABTableViewPullRefresh.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '7.1.2'

  s.source_files = 'ABTableViewPullRefresh/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ABTableViewPullRefresh' => ['ABTableViewPullRefresh/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
