#pragma once

#include <stdexcept>

#include "core/base.h"
#include "src/util/search.h"
#include "collection/collection.h"

namespace rge::solver
{
	template <SolveMode SOLVE_MODE, SearcherMode SEARCHER_MODE>
	SolveResult solve(Graph *graph, uID rootNodeID, uID goalNodeID);

	template <typename T, int N>
	struct GSW
	{
		T operator()(Graph *graph, uID rootNodeID, uID goalNodeID) const
		{
			constexpr SolveMode solveMode = (SolveMode)(N / SolveModeLength);
			constexpr SearcherMode searcherMode = (SearcherMode)(N % SolveModeLength);
			return solve<solveMode, searcherMode>(graph, rootNodeID, goalNodeID);
		}
	};

	template <SolveMode SOLVE_MODE, SearcherMode SEARCHER_MODE>
	SolveResult solve(Graph *graph, uID rootNodeID, uID goalNodeID)
	{
		if(!(0 <= SEARCHER_MODE && SEARCHER_MODE < SearcherModeLength))
			return SolveResult{INVALID_SEARCHER_MODE};
		if( SEARCHER_MODE == CONSTANT && !graph->hasLinearIDs())
			return SolveResult{INVALID_SEARCHER_MODE};
		if(!(graph->searchEntry<SEARCHER_MODE>(rootNodeID) < graph->size()))
			return SolveResult{INVALID_ROOT};
		if(!(graph->searchEntry<SEARCHER_MODE>(rootNodeID) < graph->size()))
			return SolveResult{INVALID_GOAL};

		switch (SOLVE_MODE)
		{
		case BFS:
			return graphSolve_BFS<SEARCHER_MODE>(*graph, rootNodeID, goalNodeID);
		case DFS:
			return graphSolve_DFS<SEARCHER_MODE>(*graph, rootNodeID, goalNodeID);
		case DFS_SP:
			return graphSolve_DFS_SP<SEARCHER_MODE>(*graph, rootNodeID, goalNodeID);
		case DIJKSTRA:
			return graphSolve_DIJKSTRA<SEARCHER_MODE>(*graph, rootNodeID, goalNodeID);
		case A_STAR:
			return graphSolve_A_STAR<SEARCHER_MODE>(*graph, rootNodeID, goalNodeID);
		default:
			return SolveResult{INVALID_SOLVE_MODE};
		}
	}
} // namespace rge::solver