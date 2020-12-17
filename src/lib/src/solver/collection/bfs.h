#pragma once

#include <deque>

#include "src/solver/core/base.h"
#include "src/solver/core/search.h"
#include "src/solver/core/disco.h"

namespace rge::solver
{
	namespace
	{
		struct DiscoElementBFS
		{
			uID id;
			bool found;

			inline bool operator==(const uID &id) { return this->id == id; }
			inline bool operator<(const uID &id) { return this->id < id; }
			inline bool operator>(const uID &id) { return this->id < id; }
			inline bool operator<=(const uID &id) { return !(this->id > id); }
			inline bool operator>=(const uID &id) { return !(this->id < id); }

			inline uID &get() { return id; }
		};
	} // namespace

	template <SearcherMode SEARCHER_MODE>
	SolveResult graphSolve_BFS(Graph &graph, uID rootNodeID, uID goalNodeID)
	{
		std::vector<DiscoElementBFS> disco(graph.size());
		std::fill(disco.begin(), disco.end(), DiscoElementBFS{-1, false});

		disco[rootNodeID] = DiscoElementBFS{-1, true};

		std::deque<uID> Q;
		Q.push_front(rootNodeID);

		bool found = false;

		while (!Q.empty())
		{
			uID currentNodeID = Q.front();
			Q.pop_front();

			if (currentNodeID == goalNodeID)
			{
				found = true;
				break;
			}

			size_t nodeIndex = rge::search<SEARCHER_MODE>(graph.ids.begin(), graph.ids.end(), currentNodeID) - graph.ids.begin();

			for (auto &connection : graph.connections[nodeIndex])
				if (!disco[connection.id].found)
				{
					disco[connection.id] = DiscoElementBFS{currentNodeID, true};
					Q.push_back(connection.id);
				}
		}

		return SolveResult{found, discoParse(graph, std::move(disco), rootNodeID, goalNodeID)};
	}
} // namespace rge::solver