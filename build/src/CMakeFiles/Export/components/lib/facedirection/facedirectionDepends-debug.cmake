#----------------------------------------------------------------
# Generated CMake target import file for configuration "Debug".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "facedirection" for configuration "Debug"
set_property(TARGET facedirection APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(facedirection PROPERTIES
  IMPORTED_IMPLIB_DEBUG "${_IMPORT_PREFIX}/components/lib/facedirection.lib"
  IMPORTED_LINK_INTERFACE_LIBRARIES_DEBUG "RTC112_vc12_x64d;coil112_vc12_x64d;omniORB421_rtd;omniDynamic421_rtd;omnithread40_rtd;advapi32;ws2_32;mswsock;opencv_videostab;opencv_video;opencv_ts;opencv_superres;opencv_stitching;opencv_photo;opencv_ocl;opencv_objdetect;opencv_nonfree;opencv_ml;opencv_legacy;opencv_imgproc;opencv_highgui;opencv_gpu;opencv_flann;opencv_features2d;opencv_core;opencv_contrib;opencv_calib3d"
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/components/bin/facedirection.dll"
  )

list(APPEND _IMPORT_CHECK_TARGETS facedirection )
list(APPEND _IMPORT_CHECK_FILES_FOR_facedirection "${_IMPORT_PREFIX}/components/lib/facedirection.lib" "${_IMPORT_PREFIX}/components/bin/facedirection.dll" )

# Import target "facedirectionComp" for configuration "Debug"
set_property(TARGET facedirectionComp APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(facedirectionComp PROPERTIES
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/components/bin/facedirectionComp.exe"
  )

list(APPEND _IMPORT_CHECK_TARGETS facedirectionComp )
list(APPEND _IMPORT_CHECK_FILES_FOR_facedirectionComp "${_IMPORT_PREFIX}/components/bin/facedirectionComp.exe" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
