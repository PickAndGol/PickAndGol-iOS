
platform :ios, '9.0'

use_frameworks!

target 'pickandgol_ios' do

pod 'RealmSwift'
pod 'RxSwift',    '~> 3.0'
pod 'RxCocoa',    '~> 3.0'
pod 'Alamofire', '~> 4.3'
pod 'AWSAutoScaling'
pod 'AWSCloudWatch'
pod 'AWSCognito'
pod 'AWSCognitoIdentityProvider'
pod 'AWSDynamoDB'
pod 'AWSEC2'
pod 'AWSElasticLoadBalancing'
pod 'AWSIoT'
pod 'AWSKinesis'
    pod 'AWSLambda'
    pod 'AWSLex'
    pod 'AWSMachineLearning'
    pod 'AWSMobileAnalytics'
    pod 'AWSPinpoint'
    pod 'AWSPolly'
    pod 'AWSRekognition'
    pod 'AWSS3'
    pod 'AWSSES'
    pod 'AWSSimpleDB'
    pod 'AWSSNS'
    pod 'AWSSQS'
#pod 'HanekeSwift'
pod 'SwifterSwift'
pod 'SwiftKeychainWrapper'
pod 'Firebase/Core'
pod 'Firebase/Messaging'
pod 'RxRealm'
pod 'RxRealmDataSources'
end

target 'pickandgol_iosTests' do
pod 'RxSwift',    '~> 3.0'
pod 'AWSS3'
pod 'Alamofire', '~> 4.3'
pod 'SwifterSwift'
pod 'SwiftKeychainWrapper'
pod 'Firebase/Core'
pod 'Firebase/Messaging'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end

