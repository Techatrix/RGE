#pragma once

#include <algorithm>
#include <iostream>

#include "src/core/graph.h"
#include "src/solver/core/base.h"

namespace rge::solver
{
	template <typename T>
	std::vector<uID> discoParse(Graph &graph, std::vector<T> disco, uID rootNodeID, uID goalNodeID)
	{
		std::vector<uID> path;

		uID currentNodeID = goalNodeID;

		while (currentNodeID != rootNodeID)
		{
			path.push_back(currentNodeID);

			size_t index = graph.searchEntry<searcher::BINARY>(currentNodeID);

			currentNodeID = disco[index].get();

			assert(currentNodeID >= 0);
		}

		path.push_back(rootNodeID);

		std::reverse(path.begin(), path.end());

		return std::move(path);
	}
} // namespace rge::solver