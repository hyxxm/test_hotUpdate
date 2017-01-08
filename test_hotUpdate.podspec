
Pod::Spec.new do |s|
s.name = 'test_hotUpdate'
s.version = '1.0.0'
s.license = 'MIT'
s.summary = 'An HotUpdate framework  on iOS.'
s.homepage = 'https://github.com/tianyahaijiaoHYX520/test_hotUpdate'
s.authors = { '' => '' }
s.source = { :git => 'https://github.com/tianyahaijiaoHYX520/test_hotUpdate.git', :tag => '1.0.0' }
s.requires_arc = true
s.ios.deployment_target = '9.0'
s.source_files = 'test_hotUpdate/**/*.{h,m}'
s.frameworks = 'UIKit'
s.dependency 'RNCryptor'
s.dependency 'JSPatch','1.0'
s.dependency 'JSPatch/Extensions','1.0'
s.dependency 'HJNetWorkDataCore'
s.dependency 'HJPageRouter'
s.dependency 'ZipArchive'

end
# s.subspec 'HotUpdateCategory' do |ss|
#   ss.source_files = 'test_hotUpdate/HotUpdateCategory/*.{h,m}'
#   ss.dependency 'JSPatch','1.0'
# end
# s.subspec 'HotUpdateModel' do |ss|
#   ss.source_files = 'test_hotUpdate/HotUpdateModel/**/*.{h,m}'
#   # ss.dependency 'JSPatch','1.0'
#   # ss.dependency 'HJNetWorkDataCore'
#   # ss.dependency 'MJExtension'
# end
# s.subspec 'JSExtension' do |ss|
#   ss.source_files = 'test_hotUpdate/JSExtension/*.{h,m}'
#   # ss.dependency 'test_hotUpdate'
#   # ss.dependency 'JSPatch','1.0'
#   # ss.dependency 'HJNetWorkDataCore'
# end
# end
