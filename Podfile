
platform :ios, '9.0'

use_frameworks!

target 'pickandgol_ios' do

pod 'RealmSwift'
pod 'RxSwift',    '~> 3.0'
pod 'RxCocoa',    '~> 3.0'
pod 'Alamofire', '~> 4.3'
pod 'HanekeSwift'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end

