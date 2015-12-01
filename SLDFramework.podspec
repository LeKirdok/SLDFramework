Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '8.0'
s.name = "SLDFramework"
s.summary = "Removed AppDelegate"
s.requires_arc = true

# 2
s.version = "0.5.0"

# 3
s.license = { :type => "SLD", :file => "SLD" }

# 4 - Replace with your name and e-mail address
s.author = { "LeKirdok" => "alper.kirdok@solidict.com" }


# 5 - Replace this URL with your own Github page's URL (from the address bar)
s.homepage = "https://github.com/LeKirdok/SLDFramework"


# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/LeKirdok/SLDFramework.git", :tag => "#{s.version}"}


# 7
s.dependency "AFNetworking", "~> 2.0"
s.dependency "MBProgressHUD", "~> 0.9.1"
s.dependency "SDWebImage", "~>3.7"

# 8
s.source_files = "SLDFramework/**/*.{h,m}"

end