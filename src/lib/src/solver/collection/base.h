#pragma once

#include "src/solver/core/base.h"

namespace rge::solver
{
	struct DiscoElement
	{
		uID id;
		bool found;

		inline bool operator==(const uID &id) { return this->id == id; }
		inline bool operator!=(const uID &id) { return !(*this == id); }
		inline bool operator<(const uID &id) { return this->id < id; }
		inline bool operator>(const uID &id) { return this->id > id; }
		inline bool operator<=(const uID &id) { return !(*this > id); }
		inline bool operator>=(const uID &id) { return !(*this < id); }

		inline uID &get() { return id; }
	};

	struct DijkstraElement
	{
		float distance;
		uID previous;

		inline bool operator==(const uID &prev) { return previous == prev; }
		inline bool operator!=(const uID &prev) { return !(*this == prev); }
		inline bool operator<(const uID &prev) { return previous < prev; }
		inline bool operator>(const uID &prev) { return previous > prev; }
		inline bool operator<=(const uID &prev) { return !(*this > prev); }
		inline bool operator>=(const uID &prev) { return !(*this < prev); }

		inline uID &get() { return previous; }
	};

	struct AStarElement
	{
		float gscore;
		float fscore;
		uID previous;

		inline bool operator==(const uID &prev) { return previous == prev; }
		inline bool operator!=(const uID &prev) { return !(*this == prev); }
		inline bool operator<(const uID &prev) { return previous < prev; }
		inline bool operator>(const uID &prev) { return previous > prev; }
		inline bool operator<=(const uID &prev) { return !(*this > prev); }
		inline bool operator>=(const uID &prev) { return !(*this < prev); }

		inline uID &get() { return previous; }
	};

} // namespace rge::solver