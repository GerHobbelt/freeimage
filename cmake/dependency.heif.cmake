# HIEF dependency
# https://github.com/strukturag/libheif
#
# Output target: LibHEIF


include(${CMAKE_SOURCE_DIR}/cmake/external_project_common.cmake)

include(${CMAKE_SOURCE_DIR}/cmake/dependency.de265.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/dependency.kvazaar.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/dependency.dav1d.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/dependency.svtav1.cmake)

# for patching
find_package(Git REQUIRED)
cmake_path(GET GIT_EXECUTABLE PARENT_PATH GIT_DIRECTORY)
find_program(PATCH_EXECUTABLE patch HINTS ${GIT_DIRECTORY} ${GIT_DIRECTORY}/../usr/bin REQUIRED)

ExternalProject_Add(HEIF
    PREFIX ${CMAKE_BINARY_DIR}/heif
    URL "https://github.com/strukturag/libheif/releases/download/v1.19.5/libheif-1.19.5.tar.gz"
    URL_MD5 "68a0b8924696b183e640fa03b73eca0c"
    DOWNLOAD_DIR "${CMAKE_SOURCE_DIR}/dependencies/heif"
    SOURCE_DIR "${EXTERNALPROJECT_SOURCE_PREFIX}/dependencies/heif/source"
    BINARY_DIR "${CMAKE_BINARY_DIR}/heif/build"
    DOWNLOAD_EXTRACT_TIMESTAMP TRUE
    UPDATE_COMMAND ""
    PATCH_COMMAND ""
    BUILD_COMMAND ${BUILD_COMMAND_FOR_TARGET} -t heif
    INSTALL_COMMAND ${BUILD_COMMAND_FOR_TARGET} -t install
    CMAKE_ARGS "--preset" "release-noplugins" 
        "-DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_BINARY_DIR}/heif/install" "-DCMAKE_SHARED_LIBRARY_PREFIX=lib"
        "-DZLIB_ROOT:PATH=${ZLIB_ROOT}"
        "-DWITH_LIBDE265=ON"
        "-DLIBDE265_INCLUDE_DIR:PATH=${LIBDE265_INCLUDE_DIRS}" "-DLIBDE265_LINK_DIRS:PATH=${LIBDE265_LINK_DIRS}"
        "-DLIBDE265_LIBRARY:PATH=${LIBDE265_LIBRARY}" "-DLIBDE265_DEBUG_LIBRARY:PATH=${LIBDE265_DEBUG_LIBRARY}"
        "-DWITH_KVAZAAR=ON" 
        "-DKVAZAAR_INCLUDE_DIR:PATH=${KVAZAAR_INCLUDE_DIRS}" "-DKVAZAAR_LINK_DIRS:PATH=${KVAZAAR_LINK_DIRS}"
        "-DKVAZAAR_LIBRARY:PATH=${KVAZAAR_LIBRARY}" "-DKVAZAAR_DEBUG_LIBRARY:PATH=${KVAZAAR_DEBUG_LIBRARY}"
        "-DWITH_DAV1D=ON" 
        "-DDAV1D_INCLUDE_DIR:PATH=${DAVID_INCLUDE_DIRS}" "-DDAV1D_LINK_DIRS:PATH=${DAVID_LINK_DIRS}"
        "-DDAV1D_LIBRARY:PATH=${DAVID_LIBRARY}" "-DDAV1D_DEBUG_LIBRARY:PATH=${DAVID_DEBUG_LIBRARY}"
        "-DWITH_SvtEnc=ON" 
        "-DSvtEnc_INCLUDE_DIR:PATH=${SVTAV1_INCLUDE_DIRS}" "-DSvtEnc_LINK_DIRS:PATH=${SVTAV1_LINK_DIRS}"
        "-DSvtEnc_LIBRARY:PATH=${SVTAV1_LIBRARY}" "-DSvtEnc_DEBUG_LIBRARY:PATH=${SVTAV1_DEBUG_LIBRARY}"
        "-DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS} ${DEF_FLAG}LIBDE265_STATIC_BUILD=1 ${DEF_FLAG}KVZ_STATIC_LIB=1"
        "-DCMAKE_C_FLAGS=${CMAKE_C_FLAGS} ${DEF_FLAG}LIBDE265_STATIC_BUILD=1 ${DEF_FLAG}KVZ_STATIC_LIB=1"
    EXCLUDE_FROM_ALL
    DEPENDS DE265 KVAZAAR DAVID SVTAV1
)

ExternalProject_Add_Step(HEIF git_patch
    DEPENDEES download
    DEPENDERS configure
    COMMAND echo "Applying git patch"
    COMMAND ${PATCH_EXECUTABLE} -N -p1 -i ${CMAKE_SOURCE_DIR}/cmake/libheif/0001-Added-extra-CMAKE-flags-for-linking-plugins-statical.patch
    COMMAND echo " -- Done"
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/dependencies/heif/source
)

message(STATUS CMAKE_VS_MSBUILD_COMMAND=${CMAKE_VS_MSBUILD_COMMAND})

ExternalProject_Get_Property(HEIF SOURCE_DIR)
ExternalProject_Get_Property(HEIF BINARY_DIR)

add_library(LibHEIF INTERFACE)

target_include_directories(LibHEIF INTERFACE ${SOURCE_DIR}/libheif/api ${BINARY_DIR})
set_property(TARGET HEIF PROPERTY FOLDER "Dependencies")

if (WIN32)
    set(LibHEIF_INSTALL_LIBRARY ${CMAKE_BINARY_DIR}/heif/install/bin/heif.dll)
    set(LibHEIF_INSTALL_TYPE BIN)
else()
    file(GLOB LibHEIF_INSTALL_LIBRARY ${CMAKE_BINARY_DIR}/heif/install/lib/libheif.so*)
    set(LibHEIF_INSTALL_TYPE LIB)
endif()

unset(SOURCE_DIR)
unset(BINARY_DIR)
