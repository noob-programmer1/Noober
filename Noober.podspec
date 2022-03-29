
Pod::Spec.new do |spec|


  spec.name         = "Noober"
  spec.version      = "0.1.1"
  spec.summary      = "A network debugger library for ios"
  spec.description  = " Noober is a lightweight network debugger library that itercepts api and and log it"

  spec.homepage     = "https://github.com/ABHI165/Noober"
  spec.requires_arc = true
  spec.swift_versions = '5.0'
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  spec.license      = "MIT"
  spec.ios.deployment_target = '11.0'


  spec.author             = { "Abhishek Agarwal" => "abhiagarwal16052000@gmail.com" }
  # Or just: spec.author    = "Abhishek Agarwal"
  # spec.authors            = { "Abhishek Agarwal" => "abhiagarwal16052000@gmail.com" }
  # spec.social_media_url   = "https://twitter.com/abhi165"

  # spec.platform     = :ios, "11.0"

  spec.source       = { :git => "https://github.com/ABHI165/Noober.git", :tag => "#{spec.version}" }


  spec.source_files  = "Noober/**/*.{swift}"
 
  # spec.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # spec.framework  = "SomeFramework"
  # spec.frameworks = "SomeFramework", "AnotherFramework"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # spec.dependency "JSONKit", "~> 1.4"

end
