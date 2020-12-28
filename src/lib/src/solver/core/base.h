#pragma once

#include <optional>

namespace rge::solver
{

	enum SolveMode
	{
		BFS,
		BFS_SP,
		DFS,
		DFS_SP,
		DIJKSTRA,
		A_STAR,
	};

	static constexpr int SolveModeLength = 6;

	enum SolveResponse
	{
		SUCCESS,
		NO_PATH,
		INVALID_ROOT,
		INVALID_GOAL,
		INVALID_SOLVE_MODE,
		INVALID_SEARCHER_MODE,
	};

	static constexpr int SolveResponseLength = 6;

	struct SolveResult
	{
		SolveResponse response;
		std::optional<std::vector<uID>> path;
	};
} // namespace rge::solver