cmake_minimum_required(VERSION 3.21)
project(worldspawn LANGUAGES C CXX)

#
# external dependencies
#

cmake_policy(SET CMP0077 NEW)
cmake_policy(SET CMP0135 NEW)

include(FetchContent)

FetchContent_Declare(
	fteqw
	GIT_REPOSITORY https://github.com/erysdren/fteqw.git
	GIT_TAG origin/jolt
	EXCLUDE_FROM_ALL
)

set(DISABLE_TESTS ON CACHE INTERNAL "")
set(DISABLE_DOCS ON CACHE INTERNAL "")
set(ENABLE_LIGHTPREVIEW OFF CACHE INTERNAL "")
set(SKIP_TBB_INSTALL ON CACHE INTERNAL "")
set(SKIP_EMBREE_INSTALL ON CACHE INTERNAL "")

FetchContent_Declare(
	ericw-tools
	GIT_REPOSITORY https://github.com/ericwa/ericw-tools.git
	GIT_TAG origin/main
	EXCLUDE_FROM_ALL
)

FetchContent_Declare(
	librequake
	URL https://github.com/lavenderdotpet/LibreQuake/releases/download/v0.08-beta/mod.zip
	URL_HASH MD5=bf771328a559effba7542b8ba03cf59f
)

FetchContent_MakeAvailable(fteqw ericw-tools librequake)

# override name and suffix
set_target_properties(fteqw PROPERTIES OUTPUT_NAME worldspawn)
if(NOT DEFINED CMAKE_SYSTEM_PROCESSOR)
	set(SYSTEM_PROCESSOR "unknown")
else()
	string(TOLOWER ${CMAKE_SYSTEM_PROCESSOR} SYSTEM_PROCESSOR)
endif()
if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
	set_target_properties(fteqw iqmtool fteqcc qbsp vis light PROPERTIES SUFFIX "_${SYSTEM_PROCESSOR}.exe")
else()
	set_target_properties(fteqw iqmtool fteqcc qbsp vis light PROPERTIES SUFFIX ".${SYSTEM_PROCESSOR}")
endif()

# override where they end up
set_target_properties(iqmtool fteqcc qbsp vis light
	PROPERTIES
		LIBRARY_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/game/bin
		RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/game/bin
)
set_target_properties(fteqw plug_jolt plug_hl2
	PROPERTIES
		LIBRARY_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/game
		RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/game
)

# dummy targets
add_custom_target(engine)
add_dependencies(engine fteqw plug_jolt plug_hl2)

add_custom_target(tools)
add_dependencies(tools iqmtool fteqcc qbsp vis light)

# copy librequake assets
add_custom_command(
	OUTPUT ${PROJECT_SOURCE_DIR}/game/lq1
	COMMAND ${CMAKE_COMMAND} -E copy_directory ${PROJECT_BINARY_DIR}/_deps/librequake-src/lq1 ${PROJECT_SOURCE_DIR}/game/lq1
)
add_custom_target(librequake DEPENDS ${PROJECT_SOURCE_DIR}/game/lq1)

#
# options
#

set(MAP_COMPILER_THREADS "4" CACHE STRING "Threads to use for map compilers")

#
# qc code
#

define_property(TARGET PROPERTY QC_SOURCES INHERITED)

function(target_progs target name)
	cmake_parse_arguments(PARSE_ARGV 1 ARG "" "" "SOURCES;FLAGS")
	string(REPLACE "/" "-" output ${target}-${name})

	# note: this should mark fteextensions as a dependency, but we don't because
	# FTE's CMakeLists.txt is pretty messy and likes to regenerate for no reason.
	add_custom_command(
		OUTPUT ${PROJECT_SOURCE_DIR}/game/worldspawn/${name}.dat
		DEPENDS fteqcc ${PROJECT_SOURCE_DIR}/source/${name}.src
		IMPLICIT_DEPENDS C ${PROJECT_SOURCE_DIR}/source/${name}.src
		COMMAND ${CMAKE_CROSSCOMPILING_EMULATOR} "$<TARGET_FILE:fteqcc>" ${name}.src -v ${ARG_FLAGS} -o ${PROJECT_SOURCE_DIR}/game/worldspawn/${name}.dat
		WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}/source
		COMMAND_EXPAND_LISTS
		VERBATIM
	)
	add_custom_target(${output} DEPENDS ${PROJECT_SOURCE_DIR}/game/worldspawn/${name}.dat)
	add_dependencies(${target} ${output})

	foreach(srcfile IN LISTS ARG_SOURCES)
		set_property(TARGET ${output} APPEND PROPERTY QC_SOURCES ${srcfile})
	endforeach()

	file(GENERATE
		OUTPUT ${PROJECT_SOURCE_DIR}/source/${name}.src
		CONTENT
[[#include $<QUOTE>$<LIST:JOIN,$<GENEX_EVAL:$<TARGET_PROPERTY:QC_SOURCES>>,$<QUOTE>
#include $<QUOTE>>$<QUOTE>
]]
		TARGET ${output}
	)
endfunction()

# fteextensions.qc
add_custom_command(
	OUTPUT ${PROJECT_SOURCE_DIR}/source/shared/fteextensions.qc
	DEPENDS fteqw
	COMMAND ${CMAKE_CROSSCOMPILING_EMULATOR} "$<TARGET_FILE:fteqw>" +pr_dumpplatform +quit
	COMMAND ${CMAKE_COMMAND} -E copy worldspawn/src/fteextensions.qc ${PROJECT_SOURCE_DIR}/source/shared/fteextensions.qc
	COMMAND ${CMAKE_COMMAND} -E rm -r worldspawn/src
	WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}/game
)
add_custom_target(fteextensions DEPENDS ${PROJECT_SOURCE_DIR}/source/shared/fteextensions.qc)

add_custom_target(quakec)

# progs.dat (disabled for now)
if(0)
target_progs(quakec progs
	SOURCES
		shared/fteextensions.qc
		shared/defs.qc
		shared/spline.qc
		server/defs.qc
		server/physicsentity.qc
		server/physgun.qc
		server/main.qc
		server/entities/func_brush.qc
		server/entities/func_physbox.qc
		server/entities/info_player_start.qc
		server/entities/phys_box.qc
		server/entities/phys_constraint.qc
		server/entities/phys_sphere.qc
		server/entities/phys_springbox.qc
		server/entities/prop_physics.qc
		server/entities/prop_static.qc
		server/entities/worldspawn.qc
	FLAGS
		-DQWSSQC
		-DSERVER
		-Tfte_6614
		-Fassumeint
		-Fsubscope
		-Ffastarrays
		-Flo
)
endif()

# csprogs.dat
target_progs(quakec csprogs
	SOURCES
		shared/fteextensions.qc
		shared/defs.qc
		shared/spline.qc
		client/defs.qc
		client/chat.qc
		client/main.qc
	FLAGS
		-DCSQC
		-DCLIENT
		-Tfte_6614
		-Fassumeint
		-Fsubscope
		-Ffastarrays
		-Flo
)

# worldspawn.dat
target_progs(quakec worldspawn
	SOURCES
		shared/fteextensions.qc
		shared/defs.qc
		server/lqdefs.qc
		server/defs.qc
		server/physicsentity.qc
		server/entities/env_physexplosion.qc
		server/entities/func_breakable.qc
		server/entities/func_brush.qc
		server/entities/func_physbox.qc
		server/entities/phys_box.qc
		server/entities/phys_constraint.qc
		server/entities/phys_sphere.qc
		server/entities/phys_springbox.qc
		server/entities/prop_physics.qc
		server/entities/prop_static.qc
	FLAGS
		-DNQSSQC
		-DSERVER
		-Tfte_6614
		-Fassumeint
		-Fsubscope
		-Ffastarrays
		-Flo
)

#
# maps
#

function(target_q2bsp target name)
	file(MAKE_DIRECTORY "${PROJECT_SOURCE_DIR}/game/worldspawn/maps/")
	cmake_parse_arguments(PARSE_ARGV 1 ARG "" "" "BSPFLAGS;VISFLAGS;LIGHTFLAGS")
	add_custom_command(
		OUTPUT ${PROJECT_SOURCE_DIR}/game/worldspawn/maps/${name}.bsp
		DEPENDS qbsp vis light
		COMMAND ${CMAKE_CROSSCOMPILING_EMULATOR} "$<TARGET_FILE:qbsp>" ${ARG_BSPFLAGS} -path "${PROJECT_SOURCE_DIR}/game/worldspawn" ${name}.map ${name}.bsp
		COMMAND ${CMAKE_CROSSCOMPILING_EMULATOR} "$<TARGET_FILE:vis>" ${ARG_VISFLAGS} ${name}.bsp
		COMMAND ${CMAKE_CROSSCOMPILING_EMULATOR} "$<TARGET_FILE:light>" ${ARG_LIGHTFLAGS} -path "${PROJECT_SOURCE_DIR}/game/worldspawn" ${name}.bsp
		COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_SOURCE_DIR}/content/mapsrc/${name}.bsp ${PROJECT_SOURCE_DIR}/game/worldspawn/maps/${name}.bsp
		WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}/content/mapsrc
		COMMAND_EXPAND_LISTS
		VERBATIM
	)
	string(REPLACE "/" "-" output ${target}-${name})
	add_custom_target(${output} DEPENDS ${PROJECT_SOURCE_DIR}/game/worldspawn/maps/${name}.bsp)
	add_dependencies(${target} ${output})
endfunction()

add_custom_target(maps)
target_q2bsp(maps testroom
	BSPFLAGS
		-threads ${MAP_COMPILER_THREADS}
		-q2bsp
	VISFLAGS
		-threads ${MAP_COMPILER_THREADS}
	LIGHTFLAGS
		-threads ${MAP_COMPILER_THREADS}
		-world_units_per_luxel $<IF:$<CONFIG:Release>,8,16>
		-wrnormals
		-novanilla
)

#
# models
#

function(target_iqm target name)
	file(MAKE_DIRECTORY "${PROJECT_SOURCE_DIR}/game/worldspawn/models/")
	cmake_path(REMOVE_FILENAME name OUTPUT_VARIABLE path)
	cmake_path(GET name FILENAME filename)
	add_custom_command(
		OUTPUT ${PROJECT_SOURCE_DIR}/game/worldspawn/models/${name}.iqm
		DEPENDS iqmtool
		COMMAND ${CMAKE_CROSSCOMPILING_EMULATOR} "$<TARGET_FILE:iqmtool>" ${filename}.qc
		WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}/content/modelsrc/${path}
		COMMAND_EXPAND_LISTS
		VERBATIM
	)
	string(REPLACE "/" "-" output ${target}-${name})
	add_custom_target(${output} DEPENDS ${PROJECT_SOURCE_DIR}/game/worldspawn/models/${name}.iqm)
	add_dependencies(${target} ${output})
endfunction()

add_custom_target(models)
target_iqm(models box)
target_iqm(models flatbox)
target_iqm(models sphere)
target_iqm(models tallbox)
target_iqm(models rowen/barrel01)
target_iqm(models rowen/metalsheet01)
target_iqm(models rowen/metalsheet02)
target_iqm(models classic64/box_01)
target_iqm(models classic64/pvc_pipe)
target_iqm(models classic64/pvc_pipe_pallet)
