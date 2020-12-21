#pragma once

#include "src/util/search.h"
#include "src/solver/core/base.h"
#include "src/solver/core/indexed_min_heap_priority_queue.h"

namespace rge::solver
{
	namespace
	{
		struct VertexSetElement
		{
			float distance;
			uID previous;

			inline bool operator==(const uID &previous) { return this->previous == previous; }
			inline bool operator!=(const uID &previous) { return !(*this == previous); }
			inline bool operator<(const uID &previous) { return this->previous < previous; }
			inline bool operator>(const uID &previous) { return this->previous > previous; }
			inline bool operator<=(const uID &previous) { return !(*this > previous); }
			inline bool operator>=(const uID &previous) { return !(*this < previous); }

			inline uID &get() { return previous; }
		};
	} // namespace

	template <SearcherMode SEARCHER_MODE>
	SolveResult graphSolve_DIJKSTRA(Graph &graph, uID rootNodeID, uID goalNodeID)
	{
		IndexedMinHeapPriorityQueue<uID> Q;

		std::vector<VertexSetElement> set(graph.size());
		std::fill(set.begin(), set.end(), VertexSetElement{INFINITY, -1});

		for (auto &id : graph.ids)
			Q.insert(id, (id == rootNodeID) ? 0.0f : INFINITY);

		set[graph.searchEntry<SEARCHER_MODE>(rootNodeID)].distance = 0;

		while (!Q.empty())
		{
			uID u = Q.extractMin();

			if (u == goalNodeID)
				return SolveResult{SUCCESS, discoParse(graph, std::move(set), rootNodeID, goalNodeID)};

			size_t uIndex = graph.searchEntry<SEARCHER_MODE>(u);

			for (auto &v : graph.connections[uIndex])
			{
				if(Q.hasKey(v.id))
				{
					float alt = set[uIndex].distance + v.weight;

					size_t vIndex = graph.searchEntry<SEARCHER_MODE>(v.id);

					if (alt < set[vIndex].distance)
					{
						set[vIndex].distance = alt;
						set[vIndex].previous = uIndex;

						Q.decreaseKey(v.id, alt);
					}
				}
			}
		}

		return SolveResult{NO_PATH};
	}
} // namespace rge::solver