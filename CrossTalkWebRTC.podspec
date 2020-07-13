Pod::Spec.new do |s|  
    s.name              = 'CrossTalkWebRTC'
    s.version           = '83.4103.16'
    s.summary           = 'WebRTC for iOS'
    s.description       = 'WebRTC is a free, open project that provides browsers and mobile applications with Real-Time Communications (RTC) capabilities via simple APIs.'
    s.homepage          = 'https://webrtc.org/'

    s.author            = { 'Beelu Asahi' => 'beelu.asahi@gmail.com' }
    s.license           = { :type => 'Multiple', :file => 'WebRTC.framework/LICENSE.md' }

    s.platform          = :ios
    s.source            = { :git => 'https://github.com/crosstalkio/webrtc-ios.git', :tag => '83.4103.16' }

    s.ios.deployment_target = '10.0'
    s.vendored_frameworks = 'WebRTC.framework'
end
