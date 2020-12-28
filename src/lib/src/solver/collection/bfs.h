#pragma once

#include <deque>

#include "base.h"
#include "src/util/search.h"
#include "src/solver/core/base.h"
#include "src/solver/core/disco.h"

namespace rge::solver
{

	template <searcher::SearcherMode SEARCHER_MODE>
	SolveResult graphSolve_BFS(Graph &graph, uID rootNodeID, uID goalNodeID)
	{
		std::vector<DiscoElement> disco(graph.size(), {-1, false});

		size_t rootNodeIndex = graph.searchEntry<SEARCHER_MODE>(rootNodeID);
		disco[rootNodeIndex] = DiscoElement{-1, true};

		std::deque<uID> Q = {rootNodeID};

		while (!Q.empty())
		{
			uID currentNodeID = Q.front();
			Q.pop_front();

			if (currentNodeID == goalNodeID)
				return SolveResult{SUCCESS, discoParse(graph, std::move(disco), rootNodeID, goalNodeID)};

			size_t nodeIndex = graph.searchEntry<SEARCHER_MODE>(currentNodeID);

			for (auto &connection : graph.connections[nodeIndex])
			{
				size_t connectionIndex = graph.searchEntry<SEARCHER_MODE>(connection.id);

				if (!disco[connectionIndex].found)
				{
					disco[connectionIndex] = DiscoElement{currentNodeID, true};
					Q.push_back(connection.id);
				}
			}
		}

		return SolveResult{NO_PATH};
	}
} // namespace rge::solver