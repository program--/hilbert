#pragma once
#ifndef __HILBERT_GRID_H__
#define __HILBERT_GRID_H__

#include <cmath>
#include <algorithm>
#include "types.hpp"

using std::vector;
using std::trunc;

namespace hilbert
{

namespace grid
{

template <typename T, typename S>
inline hilbert::types::integral_vector<S> xToCol(S n, vector<T>& x, T xmax, T xmin) {
    S size = x.size();
    vector<S> s(size, -1);
    T diff = (xmax - xmin) / static_cast<T>(n - 1);

    for (S i = 0; i < size; i++) {
        if (x[i] >= xmin && x[i] < xmax) {
            s[i] = static_cast<S>(trunc((x[i] - xmin) / diff));
        } else if (x[i] == xmax) {
            s[i] = n - 1;
        } else {
            s[i] = static_cast<S>(-1);
        }
    }

    return s;
}

template <typename T, typename S>
inline hilbert::types::integral_vector<S> yToRow(S n, vector<T>& y, T ymax, T ymin) {
    S size = y.size();
    vector<S> s(size, -1);
    T diff = (ymax - ymin) / static_cast<T>(n - 1);

    for (S i = 0; i < size; i++) {
        if (y[i] > ymin && y[i] <= ymax) {
            s[i] = static_cast<S>(trunc((ymax - y[i]) / diff));
        } else if (y[i] == ymin) {
            s[i] = n - 1;
        } else {
            s[i] = static_cast<S>(-1);
        }
    }

    return s;
}

template <typename T, typename S>
inline hilbert::types::numeric_vector<T> colsToX(S n, vector<S>& cols, T xmax, T xmin) {
    S size = cols.size();
    vector<T> s(size);
    T diff = (xmax - xmin) / static_cast<T>(n - 1);

    for (S i = 0; i < size; i++) {
        s[i] = static_cast<T>(xmin + ((cols[i]+0.5) * diff));
    }

    return s;
}

template <typename T, typename S>
inline hilbert::types::numeric_vector<T> rowsToY(S n, vector<S>& rows, T ymax, T ymin) {
    S size = rows.size();
    vector<T> s(size);
    T diff = (ymax - ymin) / static_cast<T>(n - 1);

    for (S i = 0; i < size; i++) {
        s[i] = static_cast<T>(ymax - ((rows[i]+0.5) * diff));
    }

    return s;
}

} // namespace grid

} // namespace hilbert

#endif
