
#
#  This file is part of the "Teapot" project, and is released under the MIT license.
#

teapot_version "1.0"

define_target "opencv" do |target|
	target.build do
		source_files = Files::Directory.join(target.package.path, "opencv-2.4.10")
		cache_prefix = Files::Directory.join(environment[:build_prefix], "opencv-2.4.10-#{environment.checksum}")
		package_files = Path.join(environment[:install_prefix], "lib/pkgconfig/opencv.pc")
		
		cmake source: source_files, build_prefix: cache_prefix, arguments: [
			"-DCMAKE_CXX_COMPILER_WORKS=TRUE",
			"-DCMAKE_C_COMPILER_WORKS=TRUE",
			"-DBUILD_opencv_legacy=OFF",
			"-DBUILD_opencv_nonfree=OFF",
			"-DBUILD_opencv_java=OFF",
			"-DBUILD_opencv_ts=OFF",
			"-DBUILD_opencv_ts=OFF",
			"-DBUILD_opencv_objdetect=OFF",
			"-DBUILD_opencv_highgui=OFF",
			# 3rd party libraries are not needed:
			"-DBUILD_PNG=OFF",
			"-DBUILD_JPEG=OFF",
			"-DBUILD_ZLIB=OFF",
			"-DBUILD_SHARED_LIBS=OFF",
		]
		
		make prefix: cache_prefix, package_files: package_files
	end
	
	target.depends "Build/Make"
	target.depends "Build/CMake"
	
	target.depends :platform
	target.depends "Language/C++11"
	
	target.depends "Library/png"
	target.depends "Library/jpeg"
	target.depends "Library/z"
	
	target.provides "Library/opencv" do
		append linkflags ["-lopencv_calib3d", "-lopencv_core", "-lopencv_features2d", "-lopencv_flann", "-lopencv_imgproc", "-lopencv_ml", "-lopencv_photo", "-lopencv_video"]
	end
end

define_configuration "opencv" do |configuration|
	configuration.public!
	
	configuration.require "png"
	configuration.require "jpeg"
end

define_configuration "local" do |configuration|
	configuration[:source] = "https://github.com/dream-framework/"
	
	configuration.require "png"
	configuration.require "jpeg"
	configuration.require "build-make"
	configuration.require "build-cmake"
	configuration.require "build-files"
	configuration.require "platforms"
end
