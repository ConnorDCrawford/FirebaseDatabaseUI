Pod::Spec.new do |s|
  s.name         = 'FirebaseDatabaseUI'
  s.version      = '0.7.0'
  s.summary      = 'Firebase Database UI binding library.'
  s.homepage     = 'https://github.com/firebase/FirebaseUI-iOS'
  s.license      = { :type => 'Apache 2.0' }
  s.author       = 'Firebase'
  s.source = { :git => "https://github.com/ConnorDCrawford/FirebaseUI-iOS.git" }
  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.ios.framework = 'UIKit'
  s.requires_arc = true
  s.default_subspecs = 'Database'

  s.subspec 'Database' do |database|
    database.source_files = "FirebaseDatabaseUI/*.{swift}"
    database.dependency 'Firebase/Database'
    database.dependency 'SwiftLCS', '>= 1.1.0'

#database.vendored_frameworks = 'FirebaseDatabaseUI'

    #database.ios.frameworks = 'FirebaseDatabase', 'FirebaseAnalytics', 'FirebaseCore', 'FirebaseInstanceID', 'GoogleInterchangeUtilities', 'GoogleSymbolUtilities'

    #database.xcconfig  = { 'FRAMEWORK_SEARCH_PATHS' => '"${PODS_ROOT}/**"', 'HEADER_SEARCH_PATHS' => '"${PODS_ROOT}/Firebase/**"', 'SWIFT_VERSION' => '3.0.1' }
  end

end
