maintainer       ""
maintainer_email ""
license          "All rights reserved"
description      "Installs/Configures ec2-api-tools etc"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

%w{ubuntu}.each do |os|
  supports os
end

%w{java}.each do |cb|
  depends cb
end

