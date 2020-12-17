#pragma once

#include "src/solver/core/base.h"
#include "src/solver/core/search.h"

namespace rge::solver
{
	namespace
	{
		struct DiscoElementDFS
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
	bool graphSolve_DFS_Disco(Graph &graph, uID currentNodeID, uID goalNodeID, std::vector<DiscoElementDFS> &disco)
	{
		if (currentNodeID == goalNodeID)
			return true;

		size_t nodeIndex = rge::search<SEARCHER_MODE>(graph.ids.begin(), graph.ids.end(), currentNodeID) - graph.ids.begin();

		for (auto &connection : graph.connections[nodeIndex])
			if (!disco[connection.id].found)
			{
				disco[connection.id] = DiscoElementDFS{currentNodeID, true};
				if (graphSolve_DFS_Disco<SEARCHER_MODE>(graph, connection.id, goalNodeID, disco))
					return true;
			}

		return false;
	}

	template <SearcherMode SEARCHER_MODE>
	SolveResult graphSolve_DFS(Graph &graph, uID rootNodeID, uID goalNodeID)
	{
		std::vector<DiscoElementDFS> disco(graph.size());
		std::fill(disco.begin(), disco.end(), DiscoElementDFS{-1, false});

		disco[rootNodeID] = DiscoElementDFS{-1, true};

		bool found = graphSolve_DFS_Disco<SEARCHER_MODE>(graph, rootNodeID, goalNodeID, disco);

		return SolveResult{found, discoParse(graph, std::move(disco), rootNodeID, goalNodeID)};
	}

} // namespace rge::solver
