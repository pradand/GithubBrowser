# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'GithubBrowser' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  use_frameworks!
  pod 'Alamofire', '~> 5.0.0-rc.3'
  pod 'SkeletonView', '1.4.1'

  # Pods for GithubBrowser

  target 'GithubBrowserTests' do
    inherit! :search_paths
    # Pods for testing

  end

  post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = "NO"
        end
    end
  end
end
