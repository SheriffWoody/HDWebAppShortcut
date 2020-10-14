
Pod::Spec.new do |s|
  s.name             = 'HDWebAppShortcut'
  s.version          = '0.0.22'
  s.summary          = 'A short description of HDWebAppShortcut.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'http://github.com/SheriffWoody/HDWebAppShortcut'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Woody' => 'hudi721@foxmail.com' }
  s.source           = { :git => 'https://github.com/SheriffWoody/HDWebAppShortcut.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.dependency 'CocoaHTTPServer'
  s.resource_bundles = {
   'HDWebAppShortcut' => ['HDWebAppShortcut/Resource/*']
  }

  s.subspec 'Core' do |ss|
      ss.source_files = "HDWebAppShortcut/Core/*.{h,m}"
  end
end
