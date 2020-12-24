#pragma once

#include <chrono>
#include <string>

namespace
{
    using namespace std::chrono;
    template<typename T>
    class DurationLiteral
    {
        public: static const char* get() {return "";}
    };

    template<> class DurationLiteral <nanoseconds> { public: static const char* get() {return "ns";}};
    template<> class DurationLiteral <microseconds> { public: static const char* get() {return "μs";}};
    template<> class DurationLiteral <milliseconds> { public: static const char* get() {return "ms";}};
    template<> class DurationLiteral <seconds> { public: static const char* get() {return "s";}};
    template<> class DurationLiteral <minutes> { public: static const char* get() {return "m";}};
    template<> class DurationLiteral <hours> { public: static const char* get() {return "h";}};
}

template <typename T = std::chrono::milliseconds>
class Timer
{
public:
    Timer(std::string name = std::string())
        : name(name)
    {
        start = std::chrono::system_clock::now();
    }

    ~Timer()
    {
        if(!name.empty())
            std::cout << name << ":\t" << getDuration().count() << DurationLiteral<T>::get() << '\n';
    }

    T getDuration()
    {
        auto end = std::chrono::system_clock::now();
        return std::chrono::duration_cast<T>(end - start);
    }

private:
    std::chrono::system_clock::time_point start;
    std::string name;



};