# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'hufy' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for hufy
  pod 'MBProgressHUD', '~> 1.2.0'
  pod 'IQKeyboardManagerSwift'
  pod 'Kingfisher', '~> 5.0'
  pod 'ObjectMapper', '~> 3.5'
  pod 'RxSwift'
  pod 'RxDataSources'
  pod 'XCGLogger', '~> 7.0.1'
  pod 'MercariQRScanner'
  pod 'SnapKit', '~> 5.0.0'
  pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'FirebaseFirestoreSwift'
  pod 'Firebase/Storage'
  pod 'Firebase/Functions'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Performance'
  pod 'Firebase/DynamicLinks'
  pod 'FirebaseUI/Storage'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
    end
  end
end
