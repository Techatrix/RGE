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
		std::vector<DiscoElement> disco(graph.size());
		std::fill(disco.begin(), disco.end(), DiscoElement{-1, false});

		disco[rootNodeID] = DiscoElement{-1, true};

		std::deque<uID> Q;
		Q.push_front(rootNodeID);

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
					Q.push_back(connectionIndex);
				}
			}
		}

		return SolveResult{NO_PATH};
	}
} // namespace rge::solver