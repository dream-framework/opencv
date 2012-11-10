
#
#  This file is part of the "Teapot" project, and is released under the MIT license.
#

required_version "0.1"

define_package "opencv-2.4.3" do |package|
	package.build(:all) do |platform, environment|
		environment.use in: package.source_path do |config|
			Commands.run("rm", "-rf", "build")
			Commands.run("mkdir", "build")
			
			Dir.chdir("build") do
				Commands.run("cmake", "-G", "Unix Makefiles",
					"-DCMAKE_INSTALL_PREFIX:PATH=#{platform.prefix}",
					"-DCMAKE_CXX_COMPILER_WORKS=TRUE",
					"-DCMAKE_C_COMPILER_WORKS=TRUE",
					"-DBUILD_opencv_legacy=OFF",
					"-DBUILD_opencv_nonfree=OFF",
					"-DBUILD_opencv_ts=OFF",
					"-DBUILD_opencv_ts=OFF",
					"-DBUILD_opencv_objdetect=off",
					"-DBUILD_opencv_highgui=OFF",
					"-DBUILD_SHARED_LIBS=OFF",
					"..")
				
				Commands.run("make")
				
				Commands.run("make", "install")
			end
		end
	end
end
