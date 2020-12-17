#pragma once

#include <stdexcept>

#include "core/base.h"
#include "src/solver/core/search.h"
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
			constexpr SolveMode solveMode = (SolveMode)(N / 4);
			constexpr SearcherMode searcherMode = (SearcherMode)(N % 4);
			return solve<solveMode, searcherMode>(graph, rootNodeID, goalNodeID);
		}
	};

	template <SolveMode SOLVE_MODE, SearcherMode SEARCHER_MODE>
	SolveResult solve(Graph *graph, uID rootNodeID, uID goalNodeID)
	{
		// TODO: assert if rootNodeID or goalNodeID dont exist
		// TODO: verify SearchMode e.g: check if CONSTANT is possible
		switch (SOLVE_MODE)
		{
		case BFS:
			return graphSolve_BFS<SEARCHER_MODE>(*graph, rootNodeID, goalNodeID);
		case DFS:
			return graphSolve_DFS<SEARCHER_MODE>(*graph, rootNodeID, goalNodeID);
		case DIJKSTRA:
			return graphSolve_DIJKSTRA<SEARCHER_MODE>(*graph, rootNodeID, goalNodeID);
		case A_STAR:
			//graphSolve_A_STAR<SEARCHER_MODE>(graph, rootNodeID, goalNodeID);
		default:
			throw std::runtime_error("Invalid Solver Mode");
		}
		throw std::runtime_error("Invalid Solver Mode");
	}
} // namespace rge::solver