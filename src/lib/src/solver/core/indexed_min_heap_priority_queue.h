#pragma once

#include <vector>
#include <algorithm>
#include <functional>
#include <utility>
#include <map>

namespace rge
{
	template <typename _Key>
	struct IndexedMinHeapPriorityQueue
	{
		using index_type = size_t;
		using key_type = _Key;
		using priority_type = float;

		struct _Element
		{
			key_type key;
			priority_type priority;
		};

		std::vector<_Element> c;
		std::unordered_map<key_type, index_type> map;

		bool empty() const
		{
			return c.empty();
		}

		void insert(key_type key, priority_type priority)
		{
			c.push_back(_Element{key, priority});
			map.insert({key, c.size() - 1});
			bubbleUp(c.size() - 1);
		}

		void popMin()
		{
			swap(0, c.size() - 1);
			map.erase(c.back().key);
			c.pop_back();
			bubbleDown(0);
		}

		key_type peekMin() const
		{
			return c[0].key;
		}

		key_type extractMin()
		{
			key_type result = peekMin();
			popMin();
			return result;
		}
		
		void decreaseKey(key_type key, priority_type priority)
		{
			index_type index = map[key];
			priority_type oldp = c[index].priority;
			c[index].priority = priority;

			if (priority < oldp)
				bubbleUp(index);
			else
				bubbleDown(index);
		}

		bool hasKey(key_type key)
		{
			return map.count(key);
		}
		
	private:
		index_type parentIndex(index_type i) const
		{
			return (i - 1) / 2;
		}

		index_type leftChildindex(index_type i) const
		{
			return ((2 * i) + 1);
		}

		index_type rightChildIndex(index_type i) const
		{
			return ((2 * i) + 2);
		}

		void swap(index_type i, index_type j)
		{
			std::swap(map[c[i].key], map[c[j].key]);
			std::swap(c[i], c[j]);
		}

		void bubbleUp(index_type i)
		{
			while (i > 0 && c[parentIndex(i)].priority > c[i].priority)
			{
				swap(parentIndex(i), i);
				i = parentIndex(i);
			}
		}

		void bubbleDown(index_type i)
		{
			index_type swapIndex = i;

			index_type lindex = leftChildindex(i);
			if (lindex < c.size() && c[lindex].priority < c[swapIndex].priority)
				swapIndex = lindex;

			index_type rIndex = rightChildIndex(i);
			if (rIndex < c.size() && c[rIndex].priority < c[swapIndex].priority)
				swapIndex = rIndex;

			if (i != swapIndex)
			{
				swap(i, swapIndex);
				bubbleDown(swapIndex);
			}
		}
	};
} // namespace rge