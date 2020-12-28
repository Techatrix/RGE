#pragma once

#include <deque>

#include "src/util/search.h"
#include "src/solver/core/base.h"

namespace rge::solver
{
	template <searcher::SearcherMode SEARCHER_MODE>
	SolveResult graphSolve_BFS_SP(Graph &graph, uID rootNodeID, uID goalNodeID)
	{
		std::deque<uID> Q = {rootNodeID};

		std::vector<DijkstraElement> set(graph.size(), {INFINITY, -1});

		set[graph.searchEntry<SEARCHER_MODE>(rootNodeID)].distance = 0.0;

		while (!Q.empty())
		{
			uID u = Q.front();
			Q.pop_front();

			size_t uIndex = graph.searchEntry<SEARCHER_MODE>(u);

			for (auto &v : graph.connections[uIndex])
			{
				float alt = set[uIndex].distance + v.weight;

				size_t vIndex = graph.searchEntry<SEARCHER_MODE>(v.id);

				if (alt < set[vIndex].distance)
				{
					set[vIndex].distance = alt;
					set[vIndex].previous = u;

					Q.push_back(v.id);
				}
			}
		}

		auto path = discoParse(graph, std::move(set), rootNodeID, goalNodeID);
		return SolveResult{path.has_value() ? SUCCESS : NO_PATH, std::move(path)};
	}
} // namespace rge::solver