
#
#  This file is part of the "Teapot" project, and is released under the MIT license.
#

teapot_version "3.0"

opencv_libraries = [
	"lib/opencv4/3rdparty/libippicv.a",
	"lib/opencv4/3rdparty/libippiw.a",
	"lib/opencv4/3rdparty/libittnotify.a",
	"lib/libopencv_core.a",
	"lib/libopencv_calib3d.a",
	"lib/libopencv_features2d.a",
	"lib/libopencv_flann.a",
	"lib/libopencv_imgcodecs.a",
	"lib/libopencv_imgproc.a",
	"lib/libopencv_ml.a",
	"lib/libopencv_objdetect.a",
	"lib/libopencv_photo.a",
	"lib/libopencv_videoio.a"
]

define_target "opencv" do |target|
	target.depends "Language/C++11"
	
	target.depends "Library/png"
	target.depends "Library/jpeg"
	target.depends "Library/webp"
	
	target.depends "Library/z"
	target.depends "Library/m"
	target.depends "Library/dl"
	
	target.depends :opencv_platform
	
	target.depends "Build/Make"
	target.depends "Build/CMake"
	
	target.provides "Library/opencv" do
		source_files = target.package.path + "opencv-4.3"
		cache_prefix = environment[:build_prefix] / environment.checksum + "opencv"
		package_files = cache_prefix.list(*opencv_libraries)
		
		cmake source: source_files, install_prefix: cache_prefix, arguments: [
			"-DBUILD_SHARED_LIBS=OFF",
			"-DCMAKE_CXX_COMPILER_WORKS=TRUE",
			"-DCMAKE_C_COMPILER_WORKS=TRUE",
			"-DBUILD_opencv_java=OFF",
			"-DBUILD_opencv_python2=OFF",
			"-DBUILD_opencv_python3=OFF",
			"-DBUILD_opencv_ts=OFF",
			#"-DBUILD_opencv_objdetect=OFF",
			"-DBUILD_opencv_highgui=OFF",
			# 3rd party libraries are not needed:
			"-DBUILD_PNG=OFF",
			"-DBUILD_JPEG=OFF",
			"-DBUILD_ZLIB=OFF",
			"-DWITH_OPENEXR=OFF",
			"-DWITH_WEBP=OFF",
			"-DWITH_JASPER=OFF",
			"-DWITH_TIFF=OFF",
		], package_files: package_files
		
		append linkflags package_files
		append header_search_paths cache_prefix + "include/opencv4"
	end
end

define_configuration "development" do |configuration|
	configuration[:source] = "https://github.com/dream-framework/"
	
	configuration.import "opencv"
	
	configuration.require "build-make"
	configuration.require "build-cmake"
	configuration.require "build-files"
	
	configuration.require "platforms"
end

define_configuration "opencv" do |configuration|
	configuration.public!
	
	configuration.require "png"
	configuration.require "jpeg"
	configuration.require "webp"
	
	# Provides suitable packages for building on windows:
	host /linux/ do
		configuration.require "opencv-linux"
	end
	
	host /darwin/ do
		configuration.require "opencv-darwin"
	end
end
