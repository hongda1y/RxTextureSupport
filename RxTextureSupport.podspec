#
# Be sure to run `pod lib lint RxTextureSupport.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'RxTextureSupport'
    s.version          = '0.1.0'
    s.summary          = 'RxTextureSupport : Texture with RxSwift'

    s.description      = <<-DESC
    Combination UI and Datasource for RxSwift (Texture)
    DESC

    s.homepage         = 'https://github.com/hongda1y/RxTextureSupport'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'hongda1y' => 'daly.hong@gbstech.com.kh' }
    s.source           = { :git => 'https://github.com/hongda1y/RxTextureSupport.git', :tag => s.version.to_s }

    s.ios.deployment_target = '13.0'
    s.source_files = 'Sources/**/*'
    s.swift_version    = '5.0'

    # s.resource_bundles = {
    #   'RxTextureSupport' => ['RxTextureSupport/Assets/*.png']
    # }

    s.dependency 'Differentiator', '~> 5.0'
    s.dependency 'RxSwift', '~> 6.0'
    s.dependency 'RxCocoa', '~> 6.0'
    s.dependency 'RxDataSources', '~> 5.0'
    s.dependency 'Texture'
    s.dependency 'TextureSwiftSupport'
    s.dependency 'RxOptional'

end
