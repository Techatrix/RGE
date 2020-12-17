#pragma once

#include <vector>
#include <cassert>

namespace rge
{
	typedef long int uID;

	struct Vector2
	{
		float x;
		float y;
	};

	struct Connection
	{
		uID id;
		float weight;
	};
	

	struct Graph
	{
		std::vector<uID> ids;
		std::vector<Vector2> positions;
		std::vector<std::vector<Connection>> connections;

		size_t size() const
		{
			assert(ids.size() == positions.size() && positions.size() == connections.size());
			return ids.size();
		}
	};
}