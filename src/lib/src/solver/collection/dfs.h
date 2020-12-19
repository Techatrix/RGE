#pragma once

#include "base.h"
#include "src/solver/core/base.h"
#include "src/solver/core/search.h"

namespace rge::solver
{
	template <SearcherMode SEARCHER_MODE>
	bool graphSolve_DFS_Disco(Graph &graph, uID currentNodeID, uID goalNodeID, std::vector<DiscoElement> &disco)
	{
		if (currentNodeID == goalNodeID)
			return true;

		size_t nodeIndex = rge::search<SEARCHER_MODE>(graph.ids.begin(), graph.ids.end(), currentNodeID) - graph.ids.begin();

		for (auto &connection : graph.connections[nodeIndex])
			if (!disco[connection.id].found)
			{
				disco[connection.id] = DiscoElement{currentNodeID, true};
				if (graphSolve_DFS_Disco<SEARCHER_MODE>(graph, connection.id, goalNodeID, disco))
					return true;
			}

		return false;
	}

	template <SearcherMode SEARCHER_MODE>
	SolveResult graphSolve_DFS(Graph &graph, uID rootNodeID, uID goalNodeID)
	{
		std::vector<DiscoElement> disco(graph.size());
		std::fill(disco.begin(), disco.end(), DiscoElement{-1, false});

		disco[rootNodeID] = DiscoElement{-1, true};

		bool found = graphSolve_DFS_Disco<SEARCHER_MODE>(graph, rootNodeID, goalNodeID, disco);

		return SolveResult{found, discoParse(graph, std::move(disco), rootNodeID, goalNodeID)};
	}

} // namespace rge::solver
