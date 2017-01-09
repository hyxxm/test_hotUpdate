
Pod::Spec.new do |s|
s.user_target_xcconfig = {'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES' }
s.name = 'test_hotUpdate'
s.version = '1.0.3'
s.license = 'MIT'
s.summary = 'An HotUpdate framework  on iOS.'
s.homepage = 'https://github.com/tianyahaijiaoHYX520/test_hotUpdate'
s.authors = { '' => '' }
s.source = { :git => 'https://github.com/tianyahaijiaoHYX520/test_hotUpdate.git', :tag => '1.0.3' }
s.requires_arc = true
s.ios.deployment_target = '7.0'

s.source_files = 'test_hotUpdate/*.{h,m}'
# s.public_header_files = 'test_hotUpdate/Header.h'
s.frameworks = 'UIKit','Foundation'
s.dependency 'RNCryptor','3.0.1'
s.dependency 'JSPatch','1.0'
s.dependency 'JSPatch/Extensions','1.0'
s.dependency 'HJNetWorkDataCore'
s.dependency 'HJPageRouter'
s.dependency 'ZipArchive'

s.subspec 'HotUpdateCategory' do |ss|
  ss.source_files = 'test_hotUpdate/HotUpdateCategory/*.{h,m}'
  # ss.dependency 'JSPatch','1.0'
end
s.subspec 'HotUpdateModel' do |ss|
  ss.source_files = 'test_hotUpdate/HotUpdateModel/**/*.{h,m}'
  # ss.dependency 'JSPatch','1.0'
  # ss.dependency 'HJNetWorkDataCore'
  # ss.dependency 'MJExtension'
  # ss.frameworks = 'UIKit','Foundation'
end
s.subspec 'JSExtension' do |ss|
  ss.source_files = 'test_hotUpdate/JSExtension/*.{h,m}'
  # ss.dependency 'JSPatch','1.0'
  # ss.dependency 'HJNetWorkDataCore'
  # ss.frameworks = 'UIKit','Foundation'
end
end
