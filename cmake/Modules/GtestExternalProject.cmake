# gtest external project
# target:
#  - googletest_ep
# defines:
#  - GTEST_HOME
#  - GTEST_STATIC_LIB
#  - GTEST_MAIN_STATIC_LIB
#  - GMOCK_MAIN_STATIC_LIB

if(DEFINED ENV{GTEST_HOME} AND EXISTS ENV{GTEST_HOME})
  set(GTEST_HOME "$ENV{GTEST_HOME}")
  set(GTEST_INCLUDE_DIR "${GTEST_HOME}/include")
  set(GTEST_STATIC_LIB
    "${GTEST_HOME}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gtest${CMAKE_STATIC_LIBRARY_SUFFIX}")
  set(GTEST_MAIN_STATIC_LIB
    "${GTEST_HOME}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gtest_main${CMAKE_STATIC_LIBRARY_SUFFIX}")
  set(GMOCK_MAIN_STATIC_LIB
    "${GTEST_HOME}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gmock_main${CMAKE_STATIC_LIBRARY_SUFFIX}")

  add_custom_target(googletest_ep)
else()
  set(GTEST_VERSION "1.8.0")

  if(APPLE)
    set(GTEST_CMAKE_CXX_FLAGS "-fPIC -DGTEST_USE_OWN_TR1_TUPLE=1 -Wno-unused-value -Wno-ignored-attributes")
  elseif(NOT MSVC)
    set(GTEST_CMAKE_CXX_FLAGS "-fPIC")
  endif()
  if(CMAKE_BUILD_TYPE)
    string(TOUPPER ${CMAKE_BUILD_TYPE} UPPERCASE_BUILD_TYPE)
  endif()
  set(GTEST_CMAKE_CXX_FLAGS "${EP_CXX_FLAGS} ${CMAKE_CXX_FLAGS_${UPPERCASE_BUILD_TYPE}} ${GTEST_CMAKE_CXX_FLAGS}")

  set(GTEST_PREFIX "${CMAKE_CURRENT_BINARY_DIR}/external/googletest/src/googletest_ep")
  set(GTEST_INCLUDE_DIR "${GTEST_PREFIX}/include")
  set(GTEST_STATIC_LIB
    "${GTEST_PREFIX}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gtest${CMAKE_STATIC_LIBRARY_SUFFIX}")
  set(GTEST_MAIN_STATIC_LIB
    "${GTEST_PREFIX}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gtest_main${CMAKE_STATIC_LIBRARY_SUFFIX}")
  set(GMOCK_MAIN_STATIC_LIB
    "${GTEST_PREFIX}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gmock_main${CMAKE_STATIC_LIBRARY_SUFFIX}")
  set(GTEST_CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
    -DCMAKE_INSTALL_PREFIX=${GTEST_PREFIX}
    -DCMAKE_CXX_FLAGS=${GTEST_CMAKE_CXX_FLAGS})
  if (MSVC AND NOT ARROW_USE_STATIC_CRT)
    set(GTEST_CMAKE_ARGS ${GTEST_CMAKE_ARGS} -Dgtest_force_shared_crt=ON)
  endif()

  set(GTEST_URL_MD5 "16877098823401d1bf2ed7891d7dce36")

  ExternalProject_Add(googletest_ep
    PREFIX external/googletest
    URL "https://github.com/google/googletest/archive/release-${GTEST_VERSION}.tar.gz"
    URL_MD5 ${GTEST_URL_MD5}
    BUILD_BYPRODUCTS ${GTEST_STATIC_LIB} ${GTEST_MAIN_STATIC_LIB} ${GMOCK_MAIN_STATIC_LIB}
    CMAKE_ARGS ${GTEST_CMAKE_ARGS}
    ${EP_LOG_OPTIONS})
endif()