#pragma once
#ifndef __HILBERT_GRID_H__
#define __HILBERT_GRID_H__

#include <cmath>
#include <algorithm>
#include "types.hpp"

using std::vector;
using std::trunc;
using std::minmax_element;

namespace hilbert
{

namespace grid
{

template <typename T, typename S>
inline hilbert::types::integral_vector<S> coordinateToDimension(S n, vector<T> v, T max, T min) {
    S size = v.size();
    vector<S> s(size);
    T diff = (max - min) / static_cast<T>(n - 1);

    for (S i = 0; i < size; i++) {
        s[i] = static_cast<S>(trunc((max - v[i]) / diff));
    }

    return s;
}

template <typename T, typename S>
inline hilbert::types::integral_vector<S> xToCol(S n, vector<T>& x) {
    const auto minmax = minmax_element(std::begin(x), std::end(x));
    return coordinateToDimension(n, x, *minmax.first, *minmax.second);
}

template <typename T, typename S>
inline hilbert::types::integral_vector<S> yToRow(S n, vector<T>& y) {
    const auto minmax = minmax_element(std::begin(y), std::end(y));
    return coordinateToDimension(n, y, *minmax.first, *minmax.second);
}

template <typename T, typename S>
inline hilbert::types::numeric_vector<T> dimensionToCoordinate(S n, vector<S>& v, T max, T min) {
    S size = v.size();
    vector<T> s(size);
    T diff = (max - min) / static_cast<T>(n - 1);

    for (S i = 0; i < size; i++) {
        s[i] = static_cast<T>(max - (v[i] * diff));
    }

    return s;
}

template <typename T, typename S>
inline hilbert::types::numeric_vector<T> colsToX(S n, vector<S>& cols, T xmax, T xmin) {
    return dimensionToCoordinate(n, cols, xmax, xmin);
}

template <typename T, typename S>
inline hilbert::types::numeric_vector<T> rowsToY(S n, vector<S>& rows, T ymax, T ymin) {
    return dimensionToCoordinate(n, rows, ymax, ymin);
}

} // namespace grid

} // namespace hilbert

#endif