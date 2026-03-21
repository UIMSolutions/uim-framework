module uim.core.datatypes.geometry;

import std.math : PI, sqrt;
import std.traits : isFloatingPoint, isIntegral;

@safe:

private enum bool isGeometryNumber(T) = isIntegral!T || isFloatingPoint!T;

struct Point2(T) if (isGeometryNumber!T) {
	T x;
	T y;

	static Point2!T zero() pure nothrow {
		return Point2!T(0, 0);
	}

	T squaredDistanceTo(const Point2!T other) const pure nothrow {
		const dx = x - other.x;
		const dy = y - other.y;
		return dx * dx + dy * dy;
	}

	double distanceTo(const Point2!T other) const pure {
		return sqrt(cast(double) squaredDistanceTo(other));
	}

	Point2!T translated(T dx, T dy) const pure nothrow {
		return Point2!T(x + dx, y + dy);
	}
}

alias Point2d = Point2!double;
alias Point2f = Point2!float;
alias Point2i = Point2!int;

struct Size2(T) if (isGeometryNumber!T) {
	T width;
	T height;

	bool isEmpty() const pure nothrow {
		return width <= 0 || height <= 0;
	}

	T area() const pure nothrow {
		return width * height;
	}
}

alias Size2d = Size2!double;
alias Size2f = Size2!float;
alias Size2i = Size2!int;

struct Rect2(T) if (isGeometryNumber!T) {
	T x;
	T y;
	T width;
	T height;

	T left() const pure nothrow {
		return x;
	}

	T top() const pure nothrow {
		return y;
	}

	T right() const pure nothrow {
		return x + width;
	}

	T bottom() const pure nothrow {
		return y + height;
	}

	bool isEmpty() const pure nothrow {
		return width <= 0 || height <= 0;
	}

	T area() const pure nothrow {
		return width * height;
	}

	bool contains(const Point2!T point) const pure nothrow {
		return point.x >= left() && point.x <= right() && point.y >= top() && point.y <= bottom();
	}

	bool contains(const Rect2!T other) const pure nothrow {
		return other.left() >= left() && other.right() <= right() && other.top() >= top() && other.bottom() <= bottom();
	}

	bool intersects(const Rect2!T other) const pure nothrow {
		if (isEmpty() || other.isEmpty()) {
			return false;
		}

		return !(right() < other.left()
			|| other.right() < left()
			|| bottom() < other.top()
			|| other.bottom() < top());
	}

	Rect2!T intersection(const Rect2!T other) const pure nothrow {
		const nx = left() > other.left() ? left() : other.left();
		const ny = top() > other.top() ? top() : other.top();
		const nr = right() < other.right() ? right() : other.right();
		const nb = bottom() < other.bottom() ? bottom() : other.bottom();

		if (nr <= nx || nb <= ny) {
			return Rect2!T(nx, ny, 0, 0);
		}

		return Rect2!T(nx, ny, nr - nx, nb - ny);
	}

	Rect2!T translated(T dx, T dy) const pure nothrow {
		return Rect2!T(x + dx, y + dy, width, height);
	}

	Rect2!T expanded(T by) const pure nothrow {
		return Rect2!T(x - by, y - by, width + by + by, height + by + by);
	}
}

alias Rect2d = Rect2!double;
alias Rect2f = Rect2!float;
alias Rect2i = Rect2!int;

struct Circle2(T) if (isGeometryNumber!T) {
	Point2!T center;
	T radius;

	bool isEmpty() const pure nothrow {
		return radius <= 0;
	}

	double area() const pure {
		return PI * cast(double) radius * cast(double) radius;
	}

	double circumference() const pure {
		return 2.0 * PI * cast(double) radius;
	}

	bool contains(const Point2!T point) const pure nothrow {
		const dx = point.x - center.x;
		const dy = point.y - center.y;
		return dx * dx + dy * dy <= radius * radius;
	}

	bool intersects(const Circle2!T other) const pure nothrow {
		const dx = center.x - other.center.x;
		const dy = center.y - other.center.y;
		const distanceSquared = dx * dx + dy * dy;
		const radii = radius + other.radius;
		return distanceSquared <= radii * radii;
	}
}

alias Circle2d = Circle2!double;
alias Circle2f = Circle2!float;
alias Circle2i = Circle2!int;

struct Line2(T) if (isGeometryNumber!T) {
	Point2!T start;
	Point2!T end;

	T squaredLength() const pure nothrow {
		const dx = end.x - start.x;
		const dy = end.y - start.y;
		return dx * dx + dy * dy;
	}

	double length() const pure {
		return sqrt(cast(double) squaredLength());
	}

	Point2!double midpoint() const pure {
		return Point2!double((cast(double) start.x + cast(double) end.x) / 2.0,
			(cast(double) start.y + cast(double) end.y) / 2.0);
	}

	Line2!T translated(T dx, T dy) const pure nothrow {
		return Line2!T(start.translated(dx, dy), end.translated(dx, dy));
	}
}

alias Line2d = Line2!double;
alias Line2f = Line2!float;
alias Line2i = Line2!int;

