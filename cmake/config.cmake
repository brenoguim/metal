# Copyright Bruno Dutra 2015-2016
# Distributed under the Boost Software License, Version 1.0.
# See accompanying file LICENSE.txt or copy at http://boost.org/LICENSE_1_0.txt

set(METAL_INCLUDE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/include/")

file(STRINGS "${METAL_INCLUDE_DIR}/metal/config/version.hpp"
    METAL_CONFIG_VERSION_HPP REGEX "METAL_[A-Z]+ [0-9]+" LIMIT_COUNT 3
)

LIST(GET METAL_CONFIG_VERSION_HPP 0 METAL_MAJOR)
LIST(GET METAL_CONFIG_VERSION_HPP 1 METAL_MINOR)
LIST(GET METAL_CONFIG_VERSION_HPP 2 METAL_PATCH)

string(REGEX REPLACE ".*MAJOR ([0-9]+).*" "\\1" METAL_MAJOR "${METAL_MAJOR}")
string(REGEX REPLACE ".*MINOR ([0-9]+).*" "\\1" METAL_MINOR "${METAL_MINOR}")
string(REGEX REPLACE ".*PATCH ([0-9]+).*" "\\1" METAL_PATCH "${METAL_PATCH}")

set(METAL_VERSION "${METAL_MAJOR}.${METAL_MINOR}.${METAL_PATCH}")

message(STATUS "Configuring Metal ${METAL_VERSION}")

option(METAL_ENABLE_WARNINGS        "enable compiler warnings"               ON)
option(METAL_STRICT                 "treat compiler warnings as errors"     OFF)
option(METAL_VERBOSE                "increase output verbosity"             OFF)

include(CheckCXXCompilerFlag)
function(metal_try_add_flag _flag)
    set(result "${_flag}")
    string(TOUPPER "${result}" result)
    string(REGEX REPLACE "[+]" "X" result "${result}")
    string(REGEX REPLACE "[-/;=]" "_" result "${result}")
    string(REGEX REPLACE "[^ A-Z_0-9]" "" result "${result}")
    string(REGEX REPLACE "^[ ]*([A-Z_0-9]+) ?.*$" "\\1" result "${result}")
    set(result "HAS${result}")

    check_cxx_compiler_flag(${_flag} ${result})
    if(${result})
        add_compile_options(${_flag})
    endif()

    if(ARGN)
        set(${ARGN} ${result} PARENT_SCOPE)
    endif()
endfunction()

if(METAL_ENABLE_WARNINGS)
    metal_try_add_flag(-W)
    metal_try_add_flag(-Wall)
    metal_try_add_flag(-Wextra)
    metal_try_add_flag(-Weverything)
    metal_try_add_flag(-Wno-c++98-compat)
    metal_try_add_flag(-Wno-c++98-compat-pedantic)
    metal_try_add_flag(-Wno-documentation)
    metal_try_add_flag(-Wno-documentation-unknown-command)
    metal_try_add_flag(/W4)
endif()

if(METAL_STRICT)
    metal_try_add_flag(-pedantic-errors)
    metal_try_add_flag(-Werror)
    metal_try_add_flag(/Za)
    metal_try_add_flag(/WX)
endif()

if(METAL_VERBOSE)
    metal_try_add_flag(-v)
    metal_try_add_flag(-ftemplate-backtrace-limit=0)
    metal_try_add_flag(-fdiagnostics-show-template-tree)
    metal_try_add_flag(-fno-elide-type)
endif()

foreach(dialect -std=c++17 -std=c++1z -std=c++14 -std=c++1y /std:c++latest)
    metal_try_add_flag(${dialect} result)
    if(${result})
        break()
    endif()
endforeach()
