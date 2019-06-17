find_package(MPI)

find_path(_veloc_root
          NAMES include/veloc.h
          HINTS $ENV{VeloC_ROOT} ${VeloC_ROOT} ${VeloC_DIR}
          )

find_library(_veloc_client_lib
             NAMES libveloc.a veloc libveloc-client.so
             HINTS ${_veloc_root}/lib ${_veloc_root}/lib64)

find_library(_veloc_module_lib
             NAMES libveloc.a veloc libveloc-modules.so
             HINTS ${_veloc_root}/lib ${_veloc_root}/lib64)

find_path(_veloc_include_dir
          NAMES veloc.h
          HINTS ${_veloc_root}/include)

if ((NOT ${_veloc_root})
        OR (NOT ${_veloc_client_lib})
        OR (NOT ${_veloc_module_lib})
        OR (NOT ${_veloc_include_dir}))
  set(_fail_msg "Could NOT find VeloC (set VeloC_DIR or VeloC_ROOT to point to install)")
##elseif ((NOT ${MPI_FOUND}) OR (NOT ${MPI_CXX_FOUND}))
##  set(_fail_msg "Could NOT find Veloc (missing MPI)")
else()
  set(_fail_msg "Could NOT find VeloC")
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(VeloC ${_fail_msg}
                                  _veloc_root
                                  _veloc_client_lib
                                  _veloc_module_lib
                                  _veloc_include_dir
                                  )

add_library(veloc::veloc_modules UNKNOWN IMPORTED)
set_target_properties(veloc::veloc_modules PROPERTIES
                      IMPORTED_LOCATION ${_veloc_module_lib}
                      )

add_library(veloc::veloc UNKNOWN IMPORTED)
set_target_properties(veloc::veloc PROPERTIES
                      IMPORTED_LOCATION ${_veloc_client_lib}
                      INTERFACE_INCLUDE_DIRECTORIES ${_veloc_include_dir}
                      INTERFACE_LINK_LIBRARIES "veloc::veloc_modules;MPI::MPI_CXX;er;axl;rankstr;kvtree;redset;shuffile"
                      )

set(VeloC_DIR ${_veloc_root})
set(VeloC_LINK_DIRECTORIES ${_veloc_root}/lib64)


mark_as_advanced(
  _veloc_library
  _veloc_include_dir
)
