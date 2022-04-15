# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end

target 'ios-livevideosdk-quickdemo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ios-livevideosdk-quickdemo
  pod 'RCLiveVideoLib'
  pod 'Masonry'
  pod 'SVProgressHUD'
  pod 'YYModel'
  pod 'AFNetworking'
  pod 'MJRefresh'
  
  target 'ios-livevideosdk-quickdemoTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ios-livevideosdk-quickdemoUITests' do
    # Pods for testing
  end

end
