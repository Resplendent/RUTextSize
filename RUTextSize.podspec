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
  s.summary          = "Helpers for getting size of common text-related UI components."

  s.description      = <<-DESC
TODO: Add long description of the pod here.
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
