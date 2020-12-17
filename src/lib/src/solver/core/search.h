#pragma once

#include <vector>
#include <cmath>

namespace rge
{
	namespace searcher
	{
		template <class InputIt, typename T, class Compare>
		struct constant_searcher
		{
			InputIt operator()(InputIt first, InputIt last, const T &value, Compare c)
			{
				auto iter = first + (size_t)value;
				if (iter > last)
				{
					return last;
				}
				return iter;
			}
		};

		template <class InputIt, typename T, class Compare>
		struct linear_searcher
		{
			InputIt operator()(InputIt first, InputIt last, const T &value, Compare c)
			{
				for (; first != last; ++first)
					if (*first == value)
						return first;
				return first;
			}
		};

		template <class InputIt, typename T, class Compare>
		struct binary_searcher
		{
			InputIt operator()(InputIt first, InputIt last, const T &value, Compare c)
			{
				InputIt end = last;

				while (first <= last)
				{
					InputIt iter = first;
					std::advance(iter, std::distance(first, last) / 2);
					if ((*iter) < value)
						first = iter + 1;
					else if ((*iter) > value)
						last = iter - 1;
					else
						return iter;
				}
				return end;
			}
		};

		template <class InputIt, typename T, class Compare>
		struct linear_simd_searcher
		{
			InputIt operator()(InputIt first, InputIt last, const T &value)
			{
				for (auto i = first; i != last; ++i)
					if (c(*i, value))
						return i;
				return last;
			}
		};
	} // namespace searcher

	enum SearcherMode
	{
		CONSTANT,
		LINEAR,
		LINEAR_SIMD,
		BINARY,
		BINARY_FLINEAR,
		BINARY_SIMD,
		BINARY_SIMD_FLINEAR
	};

	static constexpr int SearcherModeLength = 7;

	template <
		SearcherMode SEARCHER_MODE,
		class InputIt,
		typename T,
		class Compare = std::equal_to<T>>
	InputIt search(InputIt first, InputIt last, const T &value, Compare c = Compare())
	{
		constexpr auto M = SEARCHER_MODE;
		static_assert(0 <= M && M < SearcherModeLength);

		using constant = searcher::constant_searcher<InputIt, T, Compare>;
		using linear = searcher::linear_searcher<InputIt, T, Compare>;
		using binary = searcher::binary_searcher<InputIt, T, Compare>;

		if constexpr (M == CONSTANT)
			return constant()(first, last, value, c);
		else if constexpr (M == LINEAR)
			return linear()(first, last, value, c);
		else if constexpr (M == BINARY)
			return binary()(first, last, value, c);

		throw std::runtime_error("Invalid SearcherMode");
	}

} // namespace rge