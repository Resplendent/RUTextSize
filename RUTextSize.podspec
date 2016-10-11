#
# Be sure to run `pod lib lint RUTextSize.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RUTextSize'
  s.version          = "0.1.11"
  s.summary          = "Provides code for determining the size of text."

  s.description      = <<-DESC
Provides code for determining the size of text.
* RUAttributesDictionaryBuilder: Used for setting text-related attributes, and create an attributes dictionary with the proper iOS keys and values, given the properties set.
* NSString+RUTextSize: Gets size of an NSString.
* NSAttributedString+RUTextSize: Gets size of an NSAttributedString.

Provides category methods on common text-related UI components to get their text sizes.
* UILabel+RUTextSize
* UIButton+RUTextSize
* UITextField+RUTextSize
* UITextView+RUTextSize

Also provides category methods for absorbing the properties set on an instance of `RUAttributesDictionaryBuilder`.
* UILabel+RUAttributesDictionaryBuilder
                       DESC

  s.homepage         = "https://github.com/Resplendent/RUTextSize"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.authors          = {
							"Benjamin Maer" => "ben@resplendent.co",
							"Lee Pollard" => "tjdet11@gmail.com"
}
  s.source           = { :git => "https://github.com/Resplendent/RUTextSize.git", :tag => "v#{s.version}"}

  s.ios.deployment_target = '7.0'
  s.requires_arc = true

  s.source_files = 'RUTextSize/Classes/**/*'
  
  s.dependency 'ResplendentUtilities', '~> 0.5.0'
end
