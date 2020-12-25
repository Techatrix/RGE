#pragma once

#include <vector>
#include <algorithm>
#include <cassert>
#include <deque>

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

		template <searcher::SearcherMode SEARCHER_MODE>
		auto searchEntryIterator(uID id)
		{
			return searcher::search<SEARCHER_MODE>(ids.begin(), ids.end(), id);
		}

		template <searcher::SearcherMode SEARCHER_MODE>
		size_t searchEntry(uID id)
		{
			auto index = searchEntryIterator<SEARCHER_MODE>(id) - ids.begin();
			assert(index < size());
			assert(ids[index] == id);
			return index;
		}

		void sort()
		{
			struct Node
			{
				uID id;
				Vector2 position;
				std::vector<Connection> connections;

				inline bool operator==(const Node &node) const { return id == node.id; }
				inline bool operator!=(const Node &node) const { return !(*this == node); }
				inline bool operator<(const Node &node) const { return id < node.id; }
				inline bool operator>(const Node &node) const { return node < *this; }
				inline bool operator<=(const Node &node) const { return !(*this > node); }
				inline bool operator>=(const Node &node) const { return !(*this < node); }
			};
			size_t nodeCount = size();
			std::vector<Node> nodes(nodeCount);

			for (size_t i = 0; i < nodeCount; i++)
			{
				nodes[i].id = std::move(ids[i]);
				nodes[i].position = std::move(positions[i]);
				nodes[i].connections = std::move(connections[i]);
			}

			std::sort(nodes.begin(), nodes.end());

			for (size_t i = 0; i < nodeCount; i++)
			{
				ids[i] = std::move(nodes[i].id);
				positions[i] = std::move(nodes[i].position);
				connections[i] = std::move(nodes[i].connections);
			}
		}

		void removeUnconnectedNodes(uID searchOriginID)
		{
			std::vector<bool> disco(size(), false);
			{
				disco[searchEntry<searcher::BINARY>(searchOriginID)] = true;

				std::deque<uID> Q;
				Q.push_front(searchOriginID);

				while (!Q.empty())
				{
					uID id = Q.front();
					Q.pop_front();

					for (auto &c : connections[searchEntry<searcher::BINARY>(id)])
					{
						size_t cIndex = searchEntry<searcher::BINARY>(c.id);
						if (!disco[cIndex])
						{
							disco[cIndex] = true;
							Q.push_back(c.id);
						}
					}
				}
			}

			size_t newNodeCount = 0;
			for (auto found : disco)
				newNodeCount += found;

			std::vector<uID> newIds(newNodeCount);
			std::vector<Vector2> newPositions(newNodeCount);
			std::vector<std::vector<Connection>> newConnections(newNodeCount);

			size_t newIndex = 0;
			size_t oldIndex = 0;
			for (auto found : disco)
			{
				if (found)
				{
					newIds[newIndex] = std::move(ids[oldIndex]);
					newPositions[newIndex] = std::move(positions[oldIndex]);
					newConnections[newIndex++] = std::move(connections[oldIndex]);
				}
				oldIndex++;
			}

			ids = std::move(newIds);
			positions = std::move(newPositions);
			connections = std::move(newConnections);
		}

		size_t getTotalConnectionCount() const
		{
			size_t count = 0;

			for (auto &cons : connections)
				count += cons.size();

			return count;
		}

		bool hasLinearIDs() const
		{
			for (size_t i = 0; i < size(); i++)
				if (ids[i] != i)
					return false;
			return true;
		}
	};
} // namespace rge