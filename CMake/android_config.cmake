message(STATUS "Setting Android configurations")
message(STATUS "Prepare RealSense SDK for Android OS (${ANDROID_NDK_ABI_NAME})")

macro(os_set_flags)
    unset(WIN32)
    unset(UNIX)
    unset(APPLE)
    set(BUILD_WITH_TM2 OFF)
    set(BUILD_UNIT_TESTS OFF)
    set(BUILD_EXAMPLES OFF)
    set(BUILD_WITH_OPENMP OFF)  
    set(CMAKE_ANDROID_ARM_NEON ON) 
    set(BUILD_GRAPHICAL_EXAMPLES OFF)
    set(ANDROID_STL "c++_static")
    set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   -fPIC -pedantic -g -D_BSD_SOURCE")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC -pedantic -g -Wno-missing-field-initializers")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-switch -Wno-multichar")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -fPIE -pie")
    
    if(ANDROID_USB_HOST_UVC)
        set(FORCE_LIBUVC OFF)
        set(BACKEND RS2_USE_ANDROID_BACKEND)
        set(HWM_OVER_XU ON)
    else()
        set(FORCE_LIBUVC ON)
        set(BACKEND RS2_USE_V4L2_BACKEND)
        include(CMake/external_libusb.cmake)
        set(LIBUSB1_LIBRARIES ${LIBUSB1_LIBRARIES} log)
    endif()
endmacro()

macro(os_target_config)
    if(BUILD_SHARED_LIBS)
        find_library(log-lib log)
        target_link_libraries(${LRS_TARGET} PRIVATE log)
    endif()

    if(NOT ANDROID_USB_HOST_UVC)
        add_dependencies(${LRS_TARGET} libusb)
    endif()
    
    target_link_libraries(${LRS_TARGET} PRIVATE ${LIBUSB1_LIBRARIES})
endmacro()
