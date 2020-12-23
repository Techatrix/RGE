set DIR=%0\..\

if not exist %DIR%build\ mkdir %DIR%build\

clang -c -O3 -D BUILDING_DLL -std=c++17 -I%DIR% %DIR%src\ffi.cpp -o %DIR%\build\ffi.o
clang -c -O3 -D BUILDING_DLL -std=c++17 -I%DIR% %DIR%src\ffi_c.cpp -o %DIR%\build\ffi_c.o

clang -shared -o %DIR%build\ffi_c.dll %DIR%build\ffi.o %DIR%build\ffi_c.o
clang -shared -o %DIR%build\ffi.dll %DIR%build\ffi.o