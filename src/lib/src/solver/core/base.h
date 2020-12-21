#pragma once

namespace rge::solver
{

	enum SolveMode
	{
		BFS,
		DFS,
		DFS_SP,
		DIJKSTRA,
		A_STAR,
	};

	static constexpr int SolveModeLength = 5;

	enum SolveResponse
	{
		SUCCESS,
		ERROR,
		NO_PATH,
		INVALID_ROOT,
		INVALID_GOAL,
		INVALID_SOLVE_MODE,
		INVALID_SEARCHER_MODE,
	};

	struct SolveResult
	{
		SolveResponse response;
		std::vector<uID> path;
	};
} // namespace rge::solver