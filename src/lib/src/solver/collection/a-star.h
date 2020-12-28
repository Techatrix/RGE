#pragma once

#include <cmath>

#include "src/util/search.h"
#include "src/solver/core/base.h"
#include "src/solver/core/min_heap_priority_queue.h"

namespace rge::solver
{
	template <searcher::SearcherMode SEARCHER_MODE>
	SolveResult graphSolve_A_STAR(Graph &graph, uID rootNodeID, uID goalNodeID)
	{
		MinHeapPriorityQueue<uID> Q;

		auto goalNodeIndex = graph.searchEntry<SEARCHER_MODE>(goalNodeID);
		Vector2 &goalNodePosition = graph.positions[goalNodeIndex];

		auto h = [&graph, &goalNodePosition](size_t index) -> float {
			Vector2 &pos1 = graph.positions[index];
			Vector2 &pos2 = goalNodePosition;
			float dx = (pos2.x - pos1.x);
			float dy = (pos2.y - pos1.y);
			return std::sqrt(dx * dx + dy * dy);
		};

		std::vector<AStarElement> set(graph.size(), {INFINITY, INFINITY, -1});

		auto roalNodeIndex = graph.searchEntry<SEARCHER_MODE>(rootNodeID);
		float fscore = h(roalNodeIndex);
		set[roalNodeIndex] = AStarElement{0.0f, fscore, -1};

		Q.insert(rootNodeID, fscore);

		while (!Q.empty())
		{
			uID u = Q.extractMin();

			if (u == goalNodeID)
				return SolveResult{SUCCESS, discoParse(graph, std::move(set), rootNodeID, goalNodeID)};

			size_t uIndex = graph.searchEntry<SEARCHER_MODE>(u);

			for (auto &v : graph.connections[uIndex])
			{
				float tentative_gScore = set[uIndex].gscore + v.weight;

				size_t vIndex = graph.searchEntry<SEARCHER_MODE>(v.id);

				if (tentative_gScore < set[vIndex].gscore)
				{
					set[vIndex].gscore = tentative_gScore;
					set[vIndex].fscore = tentative_gScore + h(vIndex);
					set[vIndex].previous = u;

					Q.insert(v.id, set[vIndex].fscore);
				}
			}
		}

		return SolveResult{NO_PATH};
	}
} // namespace rge::solver