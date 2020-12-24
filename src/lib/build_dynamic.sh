DIR="$( cd "$( dirname "$0" )" && pwd )"

mkdir -p -- "${DIR}/build/"

g++ -c -fpic -O3 -std=c++17 -D BUILDING_DLL -D NDEBUG -I${DIR}/ ${DIR}/src/ffi.cpp -o ${DIR}/build/ffi.o
g++ -c -fpic -O3 -std=c++17 -D BUILDING_DLL -D NDEBUG -I${DIR}/ ${DIR}/src/ffi_c.cpp -o ${DIR}/build/ffi_c.o

g++ -shared -o ${DIR}/build/ffi_c.so ${DIR}/build/ffi.o ${DIR}/build/ffi_c.o
g++ -shared -o ${DIR}/build/ffi.so ${DIR}/build/ffi.o