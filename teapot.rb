
#
#  This file is part of the "Teapot" project, and is released under the MIT license.
#

teapot_version "1.0"

define_target "opencv" do |target|
	OPENCV_LIBRARIES = [
		"share/OpenCV/3rdparty/lib/libippicv.a",
		"lib/libopencv_calib3d.a",
		"lib/libopencv_core.a",
		"lib/libopencv_features2d.a",
		"lib/libopencv_flann.a",
		# "lib/libopencv_highgui.a",
		"lib/libopencv_imgcodecs.a",
		"lib/libopencv_imgproc.a",
		"lib/libopencv_ml.a",
		"lib/libopencv_objdetect.a",
		"lib/libopencv_photo.a",
		"lib/libopencv_videoio.a"
	]
	
	target.build do
		source_files = Files::Directory.join(target.package.path, "opencv-3.1.0")
		cache_prefix = Files::Directory.join(environment[:build_prefix], "opencv-3.1.0-#{environment.checksum}")
		package_files = Files::Paths.directory(environment[:install_prefix], OPENCV_LIBRARIES)
		
		cmake source: source_files, build_prefix: cache_prefix, arguments: [
			"-DCMAKE_CXX_COMPILER_WORKS=TRUE",
			"-DCMAKE_C_COMPILER_WORKS=TRUE",
			"-DBUILD_opencv_java=OFF",
			"-DBUILD_opencv_ts=OFF",
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
	target.depends "Library/dl"
	
	target.provides "Library/opencv" do
		append linkflags [
			->{install_prefix + "share/OpenCV/3rdparty/lib/libippicv.a"},
			->{install_prefix + "lib/libopencv_calib3d.a"},
			->{install_prefix + "lib/libopencv_core.a"},
			->{install_prefix + "lib/libopencv_features2d.a"},
			->{install_prefix + "lib/libopencv_flann.a"},
			# ->{install_prefix + "lib/libopencv_highgui.a"},
			->{install_prefix + "lib/libopencv_imgproc.a"},
			->{install_prefix + "lib/libopencv_imgcodecs.a"},
			->{install_prefix + "lib/libopencv_ml.a"},
			->{install_prefix + "lib/libopencv_objdetect.a"},
			->{install_prefix + "lib/libopencv_photo.a"},
			->{install_prefix + "lib/libopencv_video.a"},
			->{install_prefix + "lib/libopencv_videoio.a"},
			"-ldc1394",
			"-lswscale",
			"-lv4l1",
			"-lv4l2",
			"-lavcodec",
			"-lavformat",
			"-lavutil"
		]
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
