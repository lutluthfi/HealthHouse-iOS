platform :ios, '13.0'

target 'HealthHouse' do
  use_frameworks!

  pod 'RealmSwift'

  pod 'RxCocoa', '~> 6.0'
  pod 'RxCoreLocation', '~> 1.5.1'
  pod 'RxDataSources', '~> 5.0.0'
  pod 'RxGesture', '~> 4.0'
  pod 'RxKeyboard', '~> 2.0.0'
  pod 'RxMKMapView', '~> 6.0.0'
  pod 'RxSwift', '~> 6.0'

  pod 'SnapKit', '~> 5.0.0'

  target 'HealthHouseTests' do
    inherit! :search_paths
    pod 'RxBlocking', '~> 6.0'
    pod 'RxTest', '~> 6.0'
  end

  # target 'HealthHouseUITests' do
  # end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64' 
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
