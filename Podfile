# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'
plugin 'cocoapods-binary'

target 'hufy' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for hufy
  pod 'Firebase/Core', :binary => true
  pod 'Firebase/Analytics', :binary => true
  pod 'Firebase/Auth', :binary => true
  pod 'Firebase/Firestore', :binary => true
  pod 'FirebaseFirestoreSwift', :binary => true
  pod 'Firebase/Storage', :binary => true
  pod 'Firebase/DynamicLinks', :binary => true
  pod 'MBProgressHUD', '~> 1.2.0', :binary => true
  pod 'IQKeyboardManagerSwift', :binary => true
  pod 'Kingfisher', '~> 5.0', :binary => true
  pod 'ObjectMapper', '~> 3.5', :binary => true
  pod 'RxSwift', :binary => true
  pod 'RxDataSources', :binary => true
  pod 'XCGLogger', '~> 7.0.1', :binary => true
  pod 'MercariQRScanner'
  pod 'SnapKit', '~> 5.0.0', :binary => true

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
    end
  end
end
