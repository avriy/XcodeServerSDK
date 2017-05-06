
use_frameworks!

def utils
    pod 'BuildaUtils', '~> 0.4.0'
end

def tests
    pod 'DVR', :git => "https://github.com/venmo/DVR.git", :commit => "c0ee9cc3d08053fa9993c41af14cedc046cfed21"
    pod 'Nimble'
end

target 'XcodeServerSDK' do
    utils
end

target 'XcodeServerSDKTests' do
    utils
    tests
end
