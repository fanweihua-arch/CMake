# 当前工程构建需要的cmake最小版本号
cmake_minimum_required(VERSION 3.12)
# 声明当前工程的工程名，版本号，工程描述文件，以及语言
project(CMakeProject VERSION 1.0 DESCRIPTION "这是一个CMake的练习项目" LANGUAGES CXX)
# 生成一个可执行文件，使用main.cpp文件，当有多个文件时，也可以使用变量等的方式
# 其中目标名称CMakeTest也是cmake的target目标，
# 设置变量值
set(CMAKE_SRC_DIR ".")
set(CMAKE_PREFIX_PATH "${CMAKE_SRC_DIR}/cmake")
#设置目标文件的输出目录为bin目录
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_SRC_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_SRC_DIR}/lib)
add_executable(CMakeTest main.cpp)
# 生成一个库文件,其中STATIC/SGARED标识需要生成的库为静态库还是动态库
# 当未显示指定时，系统会使用BUILD_SHARED_LIBS的值来选择构建
# add_library(CMakeTestLib STATIC/SHARED function.cpp)
add_library(CMakeTestLib SHARED ${CMAKE_SRC_DIR}/CMakeTestLib/function.cpp ${CMAKE_SRC_DIR}/CMakeTestLib/function.h)
# 为目标文件添加一个头文件路径
# PUBLIC标识符对于一个二进制目标没有什么含义，但是对于库来说，它让CMake知道
# 任何链接到这个目标的目标也必须包含这个目录，可选还有PRIVATE,这个只影响当前
# 目标，不影响依赖，以及INTERFACE只影响依赖
target_include_directories(CMakeTest PUBLIC ${CMAKE_SRC_DIR}/CMakeTestLib)
target_include_directories(CMakeTest PUBLIC ${CMAKE_SRC_DIR}/spdlog/include)
# 指定目标需要链接的库，一般PUBLIC关键字可以省略，但是不能有的省略，有的不省略，这样CMake会报错
message(STATUS "cuttrnt path is ${.}")
# 指定编译器特性，当前指定使用c++11标准
target_compile_features(CMakeTest PUBLIC cxx_std_11)
# 在CMake中指定变量，变量名通常全部使用大写，变量值跟在其后，可以使用${}来解析变量
# set多个变量时，可以使用空格间隔开，也可以使用如下方式
# set(MY_LIST "one;two;three;fore")
# CMake中如果一个变量的值没有空格，那么加不加引号都行
set(CMAKE_VAR_TEST "Test")
# CMake中的缓存变量，CMake中允许在构建时传入缓存变量的值，并且CMake中的缓存变量是全局变量
set(OSG_DIR "/usr/local/lib" CACHE STRING "指定OSG库所在的目录")
# CMake中可以使用option函数来定义bool类型，下文中定义bool
# 类型变量BUILD_EXAMPLE，用于标识是否构建样例，默认为OFF关闭状态
option(BUILD_EXAMPLE "weather to build examples " OFF)
# CMake中使用如下方式来设置和获取环境变量，CMake的缓存本质就是一个缓存文件CMakeCatch.txt
set(ENV{variable_name} value)
# CMake也可以使用属性信息来存储信息，这与Qt的弱属性类似，如下
# 设置目标构建使用C++17 标准
set_property(TARGET CMakeTest PROPERTY CXX_STANDARD 17)
# 获取目标的已知属性,以下是为获取某个target的CXX标准属性，值存在result_variable中
get_property(result_variable TARGET CMakeTest PROPERTY CXX_STANDARD)
# CMake中使用if语句的简单示例，在现代CMake中if语句中变量的解析可以用${}来解析变量或者不使用${}
# 直接使用变量的方式,if语句中也支持一些其他关键字，例如
# 一元的: NOT TARGET EXISTS(文件) DEFINED等
# 二元的: STREQUAL,AND,OR,MATCHES(正则表达式),VERSION_LESS,VERSION_LESS_EQUAL(版本号)
if(TRUE)
	# TRUE is process
else()
	# FALSE is process
endif()
# CMake中可以定义自己的函数与宏定义，函数与宏的区别在于作用域上存在区别，宏没有作用域的限制
# 但如果要让函数中定义的变量对外都可见，需要使用PARENT_SCOPE来修改其作用域
function(SIMPLE REQUIRED_ARG)
	message(STATUS "Simple arguments: ${REQUIRED_ARG},followed by ${ARGN}")
	set(${REQUIRED_ARG} "From SIMPLE " PARENT_SCOPE)
endfunction()
# 上述函数定义中，函数名为sample,需要至少一个参数，其中REQUIRED_ARGD就代表第一个参数，
# ARGN代表除了第一个参数之外的所有的参数列表，message为CMake的打印函数，STATUS标识打印
# 的日志是STATUS级别的LOG。
# set(${REQUIRED_ARG} "FROM SIMPLE" PARENT_SCOPE)意思是将${XX}的变量导出到其父作用域，其
# 值为"FROM SAMPLE"
# CMake允许在代码中使用configure_file来访问CMake变量，该命令将一个文件(一般以.in结尾)的文件
# 复制到另一个文件中，并替换其中他找到的所有CMake变量
# CMake中通常包含一个cmake文件夹，文件夹下存放.cmake的辅助文件，一般是用来查找一些库文件或者
# 其他辅助文件，使用如下函数将这些模块加入到CMake中
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH})
# 查找spdlog库文件
find_package(spdlog CONFIG REQUIRED)

target_link_libraries(CMakeTest PUBLIC CMakeTestLib  /home/detc/CMake/build/spdlog/bin/spdlog)