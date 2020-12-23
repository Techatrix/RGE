#pragma once

#include <optional>

#include "base.h"
#include "src/util/search.h"
#include "src/solver/core/base.h"


namespace rge::solver
{
	struct DFSState
	{
		float distance;
		std::vector<DiscoElement> disco;
	};

	template <searcher::SearcherMode SEARCHER_MODE>
    std::optional<DFSState> graphSolve_DFS_SP_Disco(Graph& graph, uID previousNodeID, uID currentNodeID, uID goalNodeID, std::vector<DiscoElement>& pathState, float distanceFromRootNode)
    {
		size_t nodeIndex = graph.searchEntry<SEARCHER_MODE>(currentNodeID);
		if(currentNodeID == goalNodeID) {
			auto disco = pathState;
			disco[nodeIndex] = DiscoElement{previousNodeID, true};
			return std::make_optional(DFSState{distanceFromRootNode, std::move(disco)});
		}
		
		DiscoElement oldDiscoState = pathState[nodeIndex];
		pathState[nodeIndex] = DiscoElement{previousNodeID, true};

		bool foundState = false;
		DFSState currentBestState;

		for (auto &connection : graph.connections[nodeIndex])
		{
			size_t connectionIndex = graph.searchEntry<SEARCHER_MODE>(connection.id);

			if (!pathState[connectionIndex].found)
			{
				auto result = graphSolve_DFS_SP_Disco<SEARCHER_MODE>(graph, currentNodeID, connection.id, goalNodeID, pathState, distanceFromRootNode + connection.weight );
				if(result && (!foundState || (result.value().distance < currentBestState.distance)))
				{
					foundState = true;
					currentBestState = std::move(result.value());
				}
			}
		}
        
		pathState[nodeIndex] = oldDiscoState;
		
		if(foundState)
        	return std::make_optional(std::move(currentBestState));
		else
			return std::optional<DFSState>();
		
    }

	template <searcher::SearcherMode SEARCHER_MODE>
    SolveResult graphSolve_DFS_SP(Graph& graph, uID rootNodeID, uID goalNodeID)
    {
		std::vector<DiscoElement> disco(graph.size());
		std::fill(disco.begin(), disco.end(), DiscoElement{-1, false});

		auto result = graphSolve_DFS_SP_Disco<SEARCHER_MODE>(graph, -1, rootNodeID, goalNodeID, disco, 0.0f);

		if(result)
			return SolveResult{SUCCESS, discoParse(graph, std::move(result.value().disco), rootNodeID, goalNodeID)};
		else
			return SolveResult{NO_PATH};
    }

} // namespace rge::solver
