platform :ios, '13.0'

target 'HealthDiary' do
  use_frameworks!

  pod 'RealmSwift'

  pod 'RxCocoa'
  pod 'RxDataSources'
  pod 'RxGesture'
  pod 'RxKeyboard'
  pod 'RxSwift'

  pod 'SnapKit'

  target 'HealthDiaryTests' do
    inherit! :search_paths
    pod 'RxBlocking'
    pod 'RxTest'
  end

  # target 'HealthDiaryUITests' do
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
