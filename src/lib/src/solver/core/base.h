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

	struct SolveResult
	{
		bool found;
		std::vector<uID> path;
	};
} // namespace rge::solver