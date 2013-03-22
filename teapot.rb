
#
#  This file is part of the "Teapot" project, and is released under the MIT license.
#

required_version "0.7.0"

define_target "opencv" do |target|
	target.build do |environment|
		build_external(package.path, "opencv-2.4.3", environment) do |config, fresh|
			Commands.run("cmake", "-G", "Unix Makefiles",
				"-DCMAKE_INSTALL_PREFIX:PATH=#{config.install_prefix}",
				"-DCMAKE_PREFIX_PATH=#{config.install_prefix}",
				"-DCMAKE_CXX_COMPILER_WORKS=TRUE",
				"-DCMAKE_C_COMPILER_WORKS=TRUE",
				"-DBUILD_opencv_legacy=OFF",
				"-DBUILD_opencv_nonfree=OFF",
				"-DBUILD_opencv_ts=OFF",
				"-DBUILD_opencv_ts=OFF",
				"-DBUILD_opencv_objdetect=OFF",
				"-DBUILD_opencv_highgui=OFF",
				# 3rd party libraries are not needed:
				"-DBUILD_PNG=OFF",
				"-DBUILD_JPEG=OFF",
				"-DBUILD_ZLIB=OFF",
				"-DBUILD_SHARED_LIBS=OFF",
				"."
			) if fresh
			
			Commands.make
			Commands.make_install
		end
	end
	
	target.depends :platform
	target.depends "Library/png"
	target.depends "Library/jpeg"
	target.depends "Library/z"
	
	target.provides "Library/opencv" do
		append linkflags "-lopencv"
	end
end
