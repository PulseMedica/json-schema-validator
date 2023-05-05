macro(find_node_module module_name)
    cmake_parse_arguments(FNM "FINDCMAKE;FINDJS;DEBUG" "NODE_MODULE_NAME;CMAKE_PATH" "" ${ARGN})

    if(EXISTS ${CMAKE_SOURCE_DIR}/node_modules/${FNM_NODE_MODULE_NAME})
        set(module_dir ${CMAKE_SOURCE_DIR}/node_modules/${FNM_NODE_MODULE_NAME})
    elseif(EXISTS ${CMAKE_SOURCE_DIR}/../../../node_modules/${FNM_NODE_MODULE_NAME})
        set(module_dir ${CMAKE_SOURCE_DIR}/../../../node_modules/${FNM_NODE_MODULE_NAME})
    else()
        message(WARNING "Could not find module: ${module_name}")
        return()
    endif()

    if(${FNM_FINDCMAKE})
        # Look for a <package>-config.cmake or <Package>Config.cmake file
        find_package(${module_name} NO_POLICY_SCOPE REQUIRED HINTS ${module_dir}/${FNM_CMAKE_PATH})
    elseif(${FNM_FINDJS})
        # Look for index.js for libs, include_dir, and dll_dir
        if(${FNM_DEBUG})
            execute_process(COMMAND node -p "require('${module_dir}').libs_debug" OUTPUT_VARIABLE ${module_name}_LIBS OUTPUT_STRIP_TRAILING_WHITESPACE)
            message(STATUS "Found ${module_name}_LIBS: ${${module_name}_LIBS}")
            execute_process(COMMAND node -p "require('${module_dir}').include_dir_debug" OUTPUT_VARIABLE ${module_name}_INCLUDE_DIR OUTPUT_STRIP_TRAILING_WHITESPACE)
            message(STATUS "Found ${module_name}_INCLUDE_DIR: ${${module_name}_INCLUDE_DIR}")
            execute_process(COMMAND node -p "require('${module_dir}').dll_dir_debug" OUTPUT_VARIABLE ${module_name}_DLL_DIR OUTPUT_STRIP_TRAILING_WHITESPACE)
            message(STATUS "Found ${module_name}_DLL_DIR: ${${module_name}_DLL_DIR}")
        else()
            execute_process(COMMAND node -p "require('${module_dir}').libs" OUTPUT_VARIABLE ${module_name}_LIBS OUTPUT_STRIP_TRAILING_WHITESPACE)
            message(STATUS "Found ${module_name}_LIBS: ${${module_name}_LIBS}")
            execute_process(COMMAND node -p "require('${module_dir}').include_dir" OUTPUT_VARIABLE ${module_name}_INCLUDE_DIR OUTPUT_STRIP_TRAILING_WHITESPACE)
            message(STATUS "Found ${module_name}_INCLUDE_DIR: ${${module_name}_INCLUDE_DIR}")
            execute_process(COMMAND node -p "require('${module_dir}').dll_dir" OUTPUT_VARIABLE ${module_name}_DLL_DIR OUTPUT_STRIP_TRAILING_WHITESPACE)
            message(STATUS "Found ${module_name}_DLL_DIR: ${${module_name}_DLL_DIR}")
        endif()

        # Add DLL_DIR to DLL_DIRS
        if(DEFINED ${module_name}_DLL_DIR)
            list(APPEND DLL_DIRS ${${module_name}_DLL_DIR})
        endif()
    endif()
endmacro()