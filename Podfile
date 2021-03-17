# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'HealthDiary' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Notey
  pod 'RealmSwift'
  pod 'RxCocoa'
  pod 'RxDataSources'
  pod 'RxSwift'
  pod 'SnapKit'

  target 'HealthDiaryTests' do
    inherit! :search_paths
    pod 'RxBlocking'
    pod 'RxTest'
  end

  target 'HealthDiaryUITests' do
    # Pods for testing
  end

end

post_install do |pi|
  pi.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
