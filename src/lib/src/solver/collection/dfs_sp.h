#pragma once

#include <optional>

#include "base.h"
#include "src/solver/core/base.h"
#include "src/solver/core/search.h"


namespace rge::solver
{
	struct DFSState
	{
		float distance;
		std::vector<DiscoElement> disco;
	};

	template <SearcherMode SEARCHER_MODE>
    std::optional<DFSState> graphSolve_DFS_SP_Disco(Graph& graph, uID previousNodeID, uID currentNodeID, uID goalNodeID, std::vector<DiscoElement>& pathState, float distanceFromRootNode)
    {
		size_t nodeIndex = rge::search<SEARCHER_MODE>(graph.ids.begin(), graph.ids.end(), currentNodeID) - graph.ids.begin();
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
			if (!pathState[connection.id].found)
			{
				auto result = graphSolve_DFS_SP_Disco<SEARCHER_MODE>(graph, currentNodeID, connection.id, goalNodeID, pathState, distanceFromRootNode + connection.weight );
				if(result && (!foundState || (result.value().distance < currentBestState.distance)))
				{
					foundState = true;
					currentBestState = std::move(result.value());
				}
			}
        
		pathState[nodeIndex] = oldDiscoState;
		
		if(foundState)
        	return std::make_optional(std::move(currentBestState));
		else
			return std::optional<DFSState>();
		
    }

	template <SearcherMode SEARCHER_MODE>
    SolveResult graphSolve_DFS_SP(Graph& graph, uID rootNodeID, uID goalNodeID)
    {
		std::vector<DiscoElement> disco(graph.size());
		std::fill(disco.begin(), disco.end(), DiscoElement{-1, false});

		auto result = graphSolve_DFS_SP_Disco<SEARCHER_MODE>(graph, -1, rootNodeID, goalNodeID, disco, 0.0f);

		if(result)
			return SolveResult{true, discoParse(graph, std::move(result.value().disco), rootNodeID, goalNodeID)};
		else
			return SolveResult{false, std::vector<uID>()};
    }

} // namespace rge::solver
