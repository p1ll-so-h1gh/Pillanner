source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '13.0'
use_frameworks!

target 'Pillanner' do
    pod 'SnapKit', '~> 5.6'

    # 카카오 로그인
    pod 'KakaoSDKCommon'
    pod 'KakaoSDKUser'
    pod 'KakaoSDKAuth'

    # Naver 로그인 SDK
    pod 'naveridlogin-sdk-ios'

    # 네트워크 통신
    pod 'Alamofire'

    # Firebase
    pod 'FirebaseAuth'
    pod 'FirebaseFirestore'
    pod 'FirebaseAnalytics'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      end
    end
  end

end
