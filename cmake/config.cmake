# Copyright Bruno Dutra 2015-2016
# Distributed under the Boost Software License, Version 1.0.
# See accompanying file LICENSE.txt or copy at http://boost.org/LICENSE_1_0.txt

option(METAL_ENABLE_WARNINGS        "enable compiler warnings"               ON)
option(METAL_STRICT                 "treat compiler warnings as errors"     OFF)
option(METAL_VERBOSE                "increase output verbosity"             OFF)

include(CheckCXXCompilerFlag)
function(metal_try_add_flag _flag)
    set(result "${_flag}")
    string(REGEX REPLACE "[+]" "x" result "${result}")
    string(REGEX REPLACE "[^a-zA-Z0-9_]" "_" result "${result}")
    set(result "has${result}")

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
    metal_try_add_flag(/W3)
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
