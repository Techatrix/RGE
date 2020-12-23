#pragma once

#include <chrono>
#include <string>

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
            std::cout << name << ":\t" << getDuration().count() << '\n';
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