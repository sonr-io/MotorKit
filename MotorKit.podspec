Pod::Spec.new do |s|
  s.name             = 'MotorKit'
  s.version          = '0.0.5'
  s.summary          = 'Apple architecture (iOS, macOS) bindings for the Sonr Motor Node.'

  s.homepage         = 'https://github.com/sonr-io/MotorKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { 'Sonr Team' => 'team@sonr.io' }
  s.source           = { :git => 'https://github.com/sonr-io/MotorKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'
  s.vendored_frameworks = 'Frameworks/Motor.xcframework'
  s.source_files = 'Sources/MotorKit/**/*'
end
