cmake_minimum_required(VERSION 3.12)

project(spdlog)

#设置spdlog源码路径
set(SPD_DIR "../spdlog")
#若不存在，则使用git拉取
set(GIT_SPD_URL "https://github.com/gabime/spdlog.git")
# 配置拉取到哪个目录
set(SPD_GIT_SRC_DIR "../spdlog")

if(EXISTS ${SPD_DIR})
	message(STATUS "spd log library find")
else()
	message(STATUS "spd log library not find will exec git pull")
	execute_process(COMMAND ${GIT_EXECUTABLE} git clone ${GIT_SPD_URL} ${SPD_GIT_SRC_DIR} RESULT_VARIABLE GIT_CLONE_RESULT OUTPUT_VARIABLE GIT_CLONE_OUTPUT ERROR_VARIABLE GIT_CLONE_ERROR)
endif()
# 找到之后，将该库文件添加到编译目录,如要需要使用相对目录，根目录是以包含该.cmake文件的父级
add_subdirectory(spdlog)