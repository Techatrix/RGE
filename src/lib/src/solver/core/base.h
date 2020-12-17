#pragma once

namespace rge::solver
{

	enum SolveMode
	{
		BFS,
		DFS,
		DIJKSTRA,
		A_STAR,
	};

	static constexpr int SolveModeLength = 4;

	struct SolveResult
	{
		bool found;
		std::vector<uID> path;
	};
} // namespace rge::solver