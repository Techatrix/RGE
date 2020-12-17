#pragma once

/**
 * @brief Calls a templated function whose template parameter is detemined by the supplied runtime integer value.
 * 
 * @note All possible templated functions from 0 to N will be instantiated.
 * 
 * @param i         Value for N template parameter
 * @param args      Arguments supplied to the function
 * 
 * @tparam N        MAX_VALUE for i.
 * @tparam Wrapper  Wrapper<typename T, int I> struct with a call operator. I will be equal to i in the called function
 * @tparam T        Return type of the Wrapper function
 * @tparam Args...  Arguments types supplied to the function
 */
template <int N, template <typename T, int I> class Wrapper, typename T, typename... Args>
struct TemplateGeneratorSwitch
{
	static_assert(N >= 0);

	static T impl(int i, const Args &... args)
	{
		if (N == i)
			return Wrapper<T, N>()(args...);
		else
			return TemplateGeneratorSwitch<N - 1, Wrapper, T, Args...>::impl(i, args...);
	}
};

template <template <typename T, int I> class Wrapper, typename T, typename... Args>
struct TemplateGeneratorSwitch<0, Wrapper, T, Args...>
{
	static T impl(int i, const Args &... args)
	{
		return Wrapper<T, 0>()(args...);
	}
};
