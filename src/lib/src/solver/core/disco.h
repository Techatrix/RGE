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

		while (rootNodeID != currentNodeID)
		{
			path.push_back(currentNodeID);

			size_t index = rge::search<BINARY>(graph.ids.begin(), graph.ids.end(), currentNodeID) - graph.ids.begin();

			currentNodeID = disco[index].get();

			if (currentNodeID < 0)
				return std::vector<uID>();
		}

		path.push_back(rootNodeID);

		std::reverse(path.begin(), path.end());

		return std::move(path);
	}
} // namespace rge::solver