Pod::Spec.new do |spec|
  spec.name         = 'FloatingBottomSheet'
  spec.version      = '0.0.1'
  spec.summary      = 'FloatingBottomSheet is a library that implements the bottom sheet on iOS.'
  spec.homepage     = 'https://github.com/OhKanghoon/FloatingBottomSheet'
  spec.license      = { type: 'MIT', file: 'LICENSE' }
  spec.author = { 'OhKanghoon' => 'ggaa96@naver.com' }
  spec.source = { git: 'https://github.com/OhKanghoon/FloatingBottomSheet.git', tag: spec.version.to_s }

  spec.source_files = 'Sources/**/*.{swift,h,m}'
  spec.frameworks   = 'UIKit'
  spec.swift_version = '5.0'

  spec.ios.deployment_target = '14.0'
end
