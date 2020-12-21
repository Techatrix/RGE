#pragma once

#include <vector>
#include <algorithm>
#include <cassert>

#include "src/util/search.h"

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
			return ids.size();
		}

		template<SearcherMode SEARCHER_MODE>
		size_t searchEntry(uID id)
		{
			return rge::search<SEARCHER_MODE>(ids.begin(), ids.end(), id) - ids.begin();
		}

		void sort()
		{
			struct Node
			{
				uID id;
				Vector2 position;
				std::vector<Connection> connections;

				inline bool operator==(const Node &node) const { return this->id == node.id; }
				inline bool operator!=(const Node &node) const { return !(*this == node); }
				inline bool operator<(const Node &node) const { return this->id < node.id; }
				inline bool operator>(const Node &node) const { return node < *this; }
				inline bool operator<=(const Node &node) const { return !(*this > node); }
				inline bool operator>=(const Node &node) const { return !(*this < node); }
			};
			std::vector<Node> nodes(size());

			for (size_t i = 0; i < size(); i++)
			{
				nodes[i].id = std::move(ids[i]);
				nodes[i].position = std::move(positions[i]);
				nodes[i].connections = std::move(connections[i]);
			}

			std::sort(nodes.begin(), nodes.end());

			for (size_t i = 0; i < size(); i++)
			{
				ids[i] = std::move(nodes[i].id);
				positions[i] = std::move(nodes[i].position);
				connections[i] = std::move(nodes[i].connections);
			}
		}

		size_t getTotalConnectionCount() const
		{
			size_t count = 0;

			for (auto& cons : connections)
				count += cons.size();

			return count;
		}

		bool hasLinearIDs() const
		{
			for (size_t i = 0; i < size(); i++)
				if(ids[i] != i)
					return false;
			return true;
		}
	};
}