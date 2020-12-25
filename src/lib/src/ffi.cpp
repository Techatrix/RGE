#include "include/ffi.h"

#ifndef M_PI
#define M_PI (3.14159265358979323846)
#endif

#include <cmath>
#include <random>
#include <algorithm>

using namespace rge;

void generateStarNode(Graph &graph, size_t degree, size_t depth)
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

			generateStarNode(graph, degree, depth - 1);
		}
	}
}

std::unique_ptr<Graph> generateStarGraph(size_t degree, size_t depth)
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

	generateStarNode(graph, degree, depth);

	return graph_ptr;
}

std::unique_ptr<rge::Graph> generateGridGraph(size_t width, size_t height, float distance)
{
	std::unique_ptr<Graph> graph_ptr = std::make_unique<Graph>();
	Graph &graph = *graph_ptr;

	size_t nodeCount = width * height;

	graph.ids = std::vector<uID>(nodeCount);
	graph.positions = std::vector<Vector2>(nodeCount);
	graph.connections = std::vector<std::vector<Connection>>(nodeCount);

	for (size_t i = 0; i < nodeCount; i++)
		graph.ids[i] = i;

	for (size_t y = 0; y < height; y++)
		for (size_t x = 0; x < width; x++)
		{
			auto index = y * width + x;
			graph.positions[index] = {x * distance, y * distance};

			auto c = graph.connections[index];
			if (x != 0) // Left
				c.push_back({(uID)(y * width + (x - 1)), distance});
			if (x != (width - 1)) // Right
				c.push_back({(uID)(y * width + (x + 1)), distance});
			if (y != 0) // Up
				c.push_back({(uID)((y - 1) * width + x), distance});
			if (y != (height - 1)) // Down
				c.push_back({(uID)((y + 1) * width + x), distance});
		}

	return graph_ptr;
}
std::unique_ptr<rge::Graph> generateGridGraphFromGrid(std::vector<std::vector<bool>>& grid, float distance)
{
	std::unique_ptr<Graph> graph_ptr = std::make_unique<Graph>();
	Graph &graph = *graph_ptr;

	size_t width = grid[0].size();
	size_t height = grid.size();

	{
		size_t maxNodeCount = width * height;
		graph.ids.reserve(maxNodeCount);
		graph.positions.reserve(maxNodeCount);
		graph.connections.reserve(maxNodeCount);
	}

	size_t i = 0;
	for (size_t y = 0; y < height; y++)
		for (size_t x = 0; x < width; x++)
		{
			if(grid[y][x])
			{
				graph.ids.push_back(i++);
				graph.positions.push_back({x * distance, y * distance});
				
				std::vector<Connection> c;
				if (x != 0 && grid[y][x-1]) // Left
					c.push_back({(uID)(y * width + (x - 1)), distance});
				if (x != (width - 1) && grid[y][x+1]) // Right
					c.push_back({(uID)(y * width + (x + 1)), distance});
				if (y != 0 && grid[y-1][x]) // Up
					c.push_back({(uID)((y - 1) * width + x), distance});
				if (y != (height - 1) && grid[y+1][x]) // Down
					c.push_back({(uID)((y + 1) * width + x), distance});
				graph.connections.push_back(std::move(c));
			}
		}

	return graph_ptr;
}

std::unique_ptr<rge::Graph> generateHierarchicalGraph(size_t depth)
{
	std::unique_ptr<Graph> graph_ptr = std::make_unique<Graph>();
	return graph_ptr;
}

std::unique_ptr<Graph> generateRandomGraph(size_t nodeCount)
{
	std::random_device rd;
	std::mt19937 gen(rd());

	std::unique_ptr<Graph> graph_ptr = std::make_unique<Graph>();
	Graph &graph = *graph_ptr;

	graph.ids = std::vector<uID>(nodeCount);
	graph.positions = std::vector<Vector2>(nodeCount);

	std::uniform_real_distribution<float> unFloatDist;

	float radius = sqrt(1000.0f * nodeCount / M_PI);

	for (size_t i = 0; i < nodeCount; i++)
	{
		float a = unFloatDist(gen) * 2 * M_PI;
		float r = radius * std::sqrt(unFloatDist(gen));
		float x = r * std::cos(a);
		float y = r * std::sin(a);

		graph.ids[i] = i;
		graph.positions[i] = {x, y};
	}

	float mean = nodeCount / 2.0;
	float dev = mean / 3.0f;

	std::normal_distribution<float> noIntDist(mean, dev);
	std::uniform_int_distribution<size_t> unIntDist(0, nodeCount - 1);

	graph.connections = std::vector<std::vector<Connection>>(nodeCount);
	std::vector<bool> isUsed(nodeCount);

	for (size_t i = 0; i < nodeCount; i++)
	{
		auto &origin = graph.positions[i];

		size_t connectionCount = std::clamp(noIntDist(gen), 0.0f, (float)nodeCount) * 40.0f / nodeCount;
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
				auto &target = graph.positions[targetid];

				float dx = (target.x - origin.x);
				float dy = (target.y - origin.y);
				float distance1 = std::sqrt(dx * dx + dy * dy);
				float distance2 = distance1 / (radius / 2);
				float max = 0.5f * exp(-0.5f * distance2 * distance2);

				if (unFloatDist(gen) < max)
				{
					isUsed[targetid] = true;
					graph.connections[i][j++] = {targetid, distance1};
				}
			}
		}
	}

	return graph_ptr;
}
