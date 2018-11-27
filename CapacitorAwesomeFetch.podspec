
  Pod::Spec.new do |s|
    s.name = 'CapacitorAwesomeFetch'
    s.version = '0.0.1'
    s.summary = 'Awesome CROS fetch replacement for Capacitor'
    s.license = 'MIT'
    s.homepage = 'https://github.com/iteufel/AwesomeFetch.git'
    s.author = 'Allan Amstadt'
    s.source = { :git => 'https://github.com/iteufel/AwesomeFetch.git', :tag => s.version.to_s }
    s.source_files = 'ios/Plugin/Plugin/**/*.{swift,h,m,c,cc,mm,cpp}'
    s.ios.deployment_target  = '11.0'
    s.dependency 'Capacitor'
    s.dependency "GCDWebServer", "~> 3.0"
  end