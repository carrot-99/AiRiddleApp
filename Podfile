# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

target 'AiRiddleApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for AiRiddleApp
  pod 'SQLite.swift'
  pod 'Google-Mobile-Ads-SDK'

end

# 新しい Xcode は iOS 15 未満を対象にしたビルドを受け付けないため、
# すべての Pod の最低対応バージョンをアプリと同じ iOS 15.0 にそろえる
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 15.0
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      end
    end
  end
end
