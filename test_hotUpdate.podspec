
Pod::Spec.new do |s|
s.name = 'test_hotUpdate'
s.version = '1.0.0'
s.license = 'MIT'
s.summary = 'An HotUpdate framework  on iOS.'
s.homepage = 'https://github.com/tianyahaijiaoHYX520/test_hotUpdate'
s.authors = { '' => '' }
s.source = { :git => 'https://github.com/tianyahaijiaoHYX520/test_hotUpdate.git', :tag => '1.0.0' }
s.requires_arc = true
s.ios.deployment_target = '7.0'
s.source_files = 'HJHotUpdate/*.{h,m}'
s.frameworks = 'UIKit'
s.dependency 'JSPatch','1.0'
s.dependency 'JSPatch/Extensions','1.0'
s.dependency 'HJNetWorkDataCore'
s.dependency 'HJPageRouter'
s.dependency 'ZipArchive'
s.dependency 'RNCryptor'
s.subspec 'HotUpdateCategory' do |ss|
  ss.source_files = 'HJHotUpdate/HotUpdateCategory/*.{h,m}'
  ss.dependency 'JSPatch','1.0'
end
s.subspec 'HotUpdateModel' do |ss|
  ss.source_files = 'HJHotUpdate/HotUpdateModel/**/*.{h,m}'
  ss.dependency 'JSPatch','1.0'
  ss.dependency 'HJNetWorkDataCore'
  ss.dependency 'MJExtension'
end
s.subspec 'JSExtension' do |ss|
  ss.source_files = 'HJHotUpdate/JSExtension/*.{h,m}'
  ss.dependency 'JSPatch','1.0'
  ss.dependency 'HJNetWorkDataCore'
end
end
