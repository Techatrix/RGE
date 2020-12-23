#pragma once

#include <vector>
#include <algorithm>
#include <functional>
#include <utility>

namespace rge
{
	template <typename _Key>
	struct MinHeapPriorityQueue
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

		bool empty() const
		{
			return c.empty();
		}

		void insert(key_type key, priority_type priority)
		{
			c.push_back(_Element{key, priority});
			bubbleUp(c.size() - 1);
		}

		void popMin()
		{
			std::swap(c[0], c[c.size() - 1]);
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

		void bubbleUp(index_type i)
		{
			while (i > 0 && c[parentIndex(i)].priority > c[i].priority)
			{
				std::swap(c[parentIndex(i)], c[i]);
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
				std::swap(c[i], c[swapIndex]);
				bubbleDown(swapIndex);
			}
		}
	};
} // namespace rge