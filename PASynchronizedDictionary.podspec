#
#  Be sure to run `pod spec lint PASynchronizedDictionary.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "PASynchronizedDictionary"
  s.version      = "1.0"

  s.summary      = "PASynchronizedDictionary, is thread safe dictionary."
  s.description  = <<-DESC
  PASynchronizedDictionary implements a dictionary trying to mimic as close as possible the SynchronizedMap in JAVA. It is using the GCD with a custom queue to make it thread safe.
                   DESC

  s.homepage     = "https://github.com/akpatrick/PASynchronizedDictionary"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author             = { "Patrick Akoury" => "patrick.akoury@outlook.com" }

  s.swift_version = "4.2"
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/akpatrick/PASynchronizedDictionary.git", :tag => "#{s.version}" }
  s.source_files  = "PASynchronizedDictionary/**/*.swift"
end
