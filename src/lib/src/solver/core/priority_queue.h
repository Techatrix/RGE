#pragma once

#include <vector>
#include <algorithm>
#include <functional>

namespace rge
{
	template <typename _T, typename _P, class _Compare = std::less<_P>>
	struct PriorityQueue
	{
		typedef _T value_type;
		typedef _P priority_type;
		typedef size_t size_type;

		struct _Element
		{
			value_type value;
			priority_type priority;

			explicit operator size_type() const { return value; }

			inline bool operator==(const _Element &e) { return this->value == e.value; }
			inline bool operator<(const _Element &e) { return this->value < e.value; }
			inline bool operator>(const _Element &e) { return this->value < e.value; }
			inline bool operator<=(const _Element &e) { return !(this->value > e.value); }
			inline bool operator>=(const _Element &e) { return !(this->value < e.value); }
		};

		struct _Element_value_equality_compare
		{
			bool operator()(const _Element &__a, const _Element &__b) const { return __a.value == __b.value; }
		};

		struct _Element_priority_compare
		{
			bool operator()(const _Element &__a, const _Element &__b) const
			{
				return _Compare()(__a.priority, __b.priority);
			}
		};

		std::vector<_Element> c;
		static _Element_priority_compare comp;

		bool empty() const
		{
			return c.empty();
		}

		size_type size() const
		{
			return c.size();
		}

		bool contains(value_type value) const
		{
			return rge::search(c.begin(), c.end(), _Element{value, 0.0}, _Element_value_equality_compare()) != std::end(c);
		}

		template <SearcherMode SEARCHER_MODE>
		auto search(value_type value)
		{
			return rge::search<SEARCHER_MODE>(c.begin(), c.end(), _Element{value, 0.0}, _Element_value_equality_compare());
		}

		void push(value_type value, priority_type priority)
		{
			push_unqueued(value, priority);
			std::push_heap(c.begin(), c.end(), comp);
		}

		template <typename... _Args>
		void emplace(_Args &&... __args)
		{
			emplace_unqueued(std::forward<_Args>(__args)...);
			std::push_heap(c.begin(), c.end(), comp);
		}

		void push_unqueued(value_type value, priority_type priority)
		{
			c.push_back(_Element{value, priority});
		}

		template <typename... _Args>
		void emplace_unqueued(_Args &&... __args)
		{
			c.emplace_back(std::forward<_Args>(__args)...);
		}

		void make()
		{
			std::make_heap(c.begin(), c.end(), comp);
		}

		void pop()
		{
			std::pop_heap(c.begin(), c.end(), comp);
			c.pop_back();
		}

		value_type top() const
		{
			return c.front().value;
		}

		value_type extract_top()
		{
			value_type __r = top();
			pop();
			return __r;
		}

		void clear()
		{
			c.clear();
		}

		void setPriority(size_type index, priority_type priority)
		{
			assert(index < c.size());
			value_type __v = c[index].value;
			c.erase(c.begin() + index);
			push(__v, priority);
		}
	};
} // namespace rge
