#include "include/ffi.h"

#define _USE_MATH_DEFINES
#include <cmath>
#include <random>

using namespace rge;

void generateNode(Graph &graph, size_t degree, size_t depth)
{
	if (depth > 0)
	{
		uID nodeID = graph.ids.size() - 1;
		graph.connections[nodeID].reserve(degree);

		for (size_t i = 0; i < degree; i++)
		{
			uID newNodeID = graph.ids.size();

			graph.ids.push_back(newNodeID);
			graph.positions.push_back(Vector2{0.0, 0.0});
			graph.connections.push_back(std::vector<Connection>());

			graph.connections[nodeID].push_back(Connection{newNodeID, 1.0});

			generateNode(graph, degree, depth - 1);
		}
	}
}

std::unique_ptr<Graph> generateGraph(size_t degree, size_t depth)
{
	std::unique_ptr<Graph> graph_ptr = std::make_unique<Graph>();
	Graph &graph = *graph_ptr;
	
	size_t nodeCount = pow(degree, depth);

	graph.ids.reserve(nodeCount);
	graph.positions.reserve(nodeCount);
	graph.connections.reserve(nodeCount);

	graph.ids.push_back(0);
	graph.positions.push_back(Vector2{0.0, 0.0});
	graph.connections.push_back(std::vector<Connection>());

	generateNode(graph, degree, depth);

	return graph_ptr;
}

std::unique_ptr<Graph> generateRandomGraph(size_t nodeCount, float radius, size_t connectionsPerNode)
{
	std::random_device rd;
	std::mt19937 gen(1);

	std::unique_ptr<Graph> graph_ptr = std::make_unique<Graph>();
	Graph &graph = *graph_ptr;

	graph.ids = std::vector<uID>(nodeCount);
	graph.positions = std::vector<Vector2>(nodeCount);

	std::uniform_real_distribution<float> unFloatDist;

	for (size_t i = 0; i < nodeCount; i++)
	{
		float a = unFloatDist(gen) * 2 * M_PI;
		float r = radius * std::sqrt(unFloatDist(gen));
		float x = r * std::cos(a);
		float y = r * std::sin(a);

		graph.ids[i] = i;
		graph.positions[i] = {x, y};
	}
	

	float mean = nodeCount/2.0;
	float dev = mean/3.0f;

	std::normal_distribution<float> noIntDist(mean, dev);
	std::uniform_int_distribution<size_t> unIntDist(0, nodeCount-1);

	graph.connections = std::vector<std::vector<Connection>>(nodeCount);
	std::vector<bool> isUsed(nodeCount);

	for (size_t i = 0; i < nodeCount; i++)
	{
		auto &origin = graph.positions[i];

		size_t connectionCount = std::clamp(noIntDist(gen), 0.0f, (float)nodeCount) * 2 * (float)connectionsPerNode/nodeCount;
		connectionCount = std::min(connectionCount, nodeCount - 1);

		graph.connections[i] = std::vector<Connection>(connectionCount);
		std::fill(isUsed.begin(), isUsed.end(), false);
		isUsed[i] = true;

		size_t j = 0;
		while (j < connectionCount)
		{
			uID targetid = unIntDist(gen);
			if (!isUsed[targetid])
			{
				isUsed[targetid] = true;
				auto &target = graph.positions[targetid];

				float dx = (target.x - origin.x);
				float dy = (target.y - origin.y);
				float distance = std::sqrt(dx*dx + dy*dy);

				graph.connections[i][j++] = {targetid, distance};
			}
		}
	}

	return graph_ptr;
}
