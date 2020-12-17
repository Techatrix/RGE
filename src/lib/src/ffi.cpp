#include "include/ffi.h"

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

Graph *generateGraph(size_t degree, size_t depth)
{
	Graph *graph = new Graph();

	size_t nodeCount = pow(degree, depth);

	graph->ids.reserve(nodeCount);
	graph->positions.reserve(nodeCount);
	graph->connections.reserve(nodeCount);

	graph->ids.push_back(0);
	graph->positions.push_back(Vector2{0.0, 0.0});
	graph->connections.push_back(std::vector<Connection>());

	generateNode(*graph, degree, depth);

	return graph;
}