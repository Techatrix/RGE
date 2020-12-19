#pragma once

#include "src/solver/core/base.h"
#include "src/solver/core/search.h"
#include "src/solver/core/priority_queue.h"

namespace rge::solver
{
	namespace
	{
		struct VertexSetElement
		{
			float distance;
			uID previous;

			inline bool operator==(const uID &previous) { return this->previous == previous; }
			inline bool operator<(const uID &previous) { return this->previous < previous; }
			inline bool operator>(const uID &previous) { return this->previous < previous; }
			inline bool operator<=(const uID &previous) { return !(this->previous > previous); }
			inline bool operator>=(const uID &previous) { return !(this->previous < previous); }

			inline uID &get() { return previous; }
		};
	} // namespace

	template <SearcherMode SEARCHER_MODE>
	SolveResult graphSolve_DIJKSTRA(Graph &graph, uID rootNodeID, uID goalNodeID)
	{
		PriorityQueue<uID, float, std::greater<float>> Q;

		std::vector<VertexSetElement> set(graph.size());
		std::fill(set.begin(), set.end(), VertexSetElement{INFINITY, -1});

		Q.push(rootNodeID, 0);
		{
			size_t i = rge::search<SEARCHER_MODE>(graph.ids.begin(), graph.ids.end(), rootNodeID) - graph.ids.begin();
			set[i].distance = 0;
		}

		bool found = false;
		while (!Q.empty())
		{
			uID u = Q.extract_top();

			if (u == goalNodeID)
			{
				found = true;
				break;
			}

			size_t uIndex = rge::search<SEARCHER_MODE>(graph.ids.begin(), graph.ids.end(), u) - graph.ids.begin();


			for (auto &v : graph.connections[uIndex])
			{
				float alt = set[uIndex].distance + v.weight;

				size_t vIndex = rge::search<SEARCHER_MODE>(graph.ids.begin(), graph.ids.end(), v.id) - graph.ids.begin();

				if (alt < set[vIndex].distance)
				{
					set[vIndex].distance = alt;
					set[vIndex].previous = uIndex;

					Q.push(v.id, alt);
				}
			}
		}

		return SolveResult{found, discoParse(graph, std::move(set), rootNodeID, goalNodeID)};
	}
} // namespace rge::solver