
Pod::Spec.new do |s|
  s.name             = 'HDWebAppShortcut'
  s.version          = '0.0.1'
  s.summary          = 'A short description of HDWebAppShortcut.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'http://github.com/SheriffWoody/HDWebAppShortcut'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Woody' => 'iwoody721@gmail.com' }
  s.source           = { :git => 'git@github.com:SheriffWoody/HDWebAppShortcut.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.requires_arc = true

  s.subspec 'Core' do |ss|
      ss.source_files = "HDWebAppShortcut/Core/*.{h,m}"
  end
  
  s.subspec 'Actions' do |ss|
      ss.source_files = "HDWebAppShortcut/Actions/*.{h,m}"
      ss.dependency "HDWebAppShortcut/Core"
  end
end
