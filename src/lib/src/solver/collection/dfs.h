#pragma once

#include "base.h"
#include "src/util/search.h"
#include "src/solver/core/base.h"

namespace rge::solver
{
	template <searcher::SearcherMode SEARCHER_MODE>
	bool graphSolve_DFS_Disco(Graph &graph, uID currentNodeID, uID goalNodeID, std::vector<DiscoElement> &disco)
	{
		if (currentNodeID == goalNodeID)
			return true;

		size_t nodeIndex = graph.searchEntry<SEARCHER_MODE>(currentNodeID);

		for (auto &connection : graph.connections[nodeIndex])
		{
			size_t connectionIndex = graph.searchEntry<SEARCHER_MODE>(connection.id);

			if (!disco[connectionIndex].found)
			{
				disco[connectionIndex] = DiscoElement{currentNodeID, true};
				if (graphSolve_DFS_Disco<SEARCHER_MODE>(graph, connection.id, goalNodeID, disco))
					return true;
			}
		}

		return false;
	}

	template <searcher::SearcherMode SEARCHER_MODE>
	SolveResult graphSolve_DFS(Graph &graph, uID rootNodeID, uID goalNodeID)
	{
		std::vector<DiscoElement> disco(graph.size());
		std::fill(disco.begin(), disco.end(), DiscoElement{-1, false});

		size_t rootNodeIndex = graph.searchEntry<SEARCHER_MODE>(rootNodeID);
		disco[rootNodeIndex] = DiscoElement{-1, true};

		bool found = graphSolve_DFS_Disco<SEARCHER_MODE>(graph, rootNodeID, goalNodeID, disco);

		if(found)
			return SolveResult{SUCCESS, discoParse(graph, std::move(disco), rootNodeID, goalNodeID)};
		else
			return SolveResult{NO_PATH};
	}

} // namespace rge::solver
