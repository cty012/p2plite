find_path(LIBNICE_INCLUDE_DIR NAMES nice/nice.h)
find_library(LIBNICE_LIBRARY NAMES nice)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(libnice DEFAULT_MSG LIBNICE_LIBRARY LIBNICE_INCLUDE_DIR)

if(LIBNICE_FOUND AND NOT TARGET libnice::libnice)
    add_library(libnice::libnice UNKNOWN IMPORTED)
    set_target_properties(libnice::libnice PROPERTIES
            IMPORTED_LOCATION "${LIBNICE_LIBRARY}"
            INTERFACE_INCLUDE_DIRECTORIES "${LIBNICE_INCLUDE_DIR}")
endif()

mark_as_advanced(LIBNICE_INCLUDE_DIR LIBNICE_LIBRARY)
