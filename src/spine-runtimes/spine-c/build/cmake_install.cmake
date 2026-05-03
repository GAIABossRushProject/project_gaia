# Install script for directory: /Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set path to fallback-tool for dependency-resolution.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/usr/bin/objdump")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/dist/lib" TYPE STATIC_LIBRARY FILES "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/build/libspine-c.a")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/dist/lib/libspine-c.a" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/dist/lib/libspine-c.a")
    execute_process(COMMAND "/usr/bin/ranlib" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/dist/lib/libspine-c.a")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  include("/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/build/CMakeFiles/spine-c.dir/install-cxx-module-bmi-noconfig.cmake" OPTIONAL)
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/dist/include" TYPE FILE FILES
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/Animation.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/AnimationState.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/AnimationStateData.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/Array.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/Atlas.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/AtlasAttachmentLoader.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/Attachment.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/AttachmentLoader.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/Bone.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/BoneData.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/BoundingBoxAttachment.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/ClippingAttachment.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/Color.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/Debug.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/Event.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/EventData.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/IkConstraint.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/IkConstraintData.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/MeshAttachment.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/PathAttachment.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/PathConstraint.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/PathConstraintData.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/Physics.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/PhysicsConstraint.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/PhysicsConstraintData.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/PointAttachment.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/RegionAttachment.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/Sequence.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/Skeleton.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/SkeletonBinary.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/SkeletonBounds.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/SkeletonClipping.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/SkeletonData.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/SkeletonJson.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/Skin.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/Slot.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/SlotData.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/TextureRegion.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/TransformConstraint.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/TransformConstraintData.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/Triangulator.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/Version.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/VertexAttachment.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/dll.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/extension.h"
    "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/spine-c/include/spine/spine.h"
    )
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
if(CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/build/install_local_manifest.txt"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
if(CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_COMPONENT MATCHES "^[a-zA-Z0-9_.+-]+$")
    set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
  else()
    string(MD5 CMAKE_INST_COMP_HASH "${CMAKE_INSTALL_COMPONENT}")
    set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INST_COMP_HASH}.txt")
    unset(CMAKE_INST_COMP_HASH)
  endif()
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "/Users/brandonharrell/repos/boss_rush/spine-runtimes/spine-c/build/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
