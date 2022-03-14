#include <cpp11.hpp>
#include <cstring>
#include <bitset>
#include "hilbert.hpp"

using std::vector;
using cpp11::integers;
using cpp11::strings;
using cpp11::data_frame;
using cpp11::literals::operator""_nm;

[[cpp11::register]]
strings HILBERT_index64_(size_t n, strings x, strings y) 
{
    const int64_t nn = static_cast<int64_t>(n);
    const size_t len = x.size();
    vector<int64_t> h(len);

    for (size_t i = 0; i < len; ++i) {
        if (i % 8130 == 0) {
            cpp11::check_user_interrupt();
        }
        
        hilbert::curve::positionToIndex(
            int64_t(1) << nn,
            static_cast<int64_t>(std::stoll(x[i], nullptr, 2)),
            static_cast<int64_t>(std::stoll(y[i], nullptr, 2)),
            &h[i]
        );
    }

    const cpp11::writable::strings indices(len);
    for (size_t i = 0; i < len; ++i) {
        indices[i] = std::bitset<64>(h[i]).to_string();
    }
    
    indices.attr("class") = "bitstring";
    return indices;
}

[[cpp11::register]]
data_frame HILBERT_position64_(size_t n, strings h)
{
    const int64_t nn = static_cast<int64_t>(n);
    const size_t len = h.size();
    vector<int64_t> x(len), y(len);
    for (size_t i = 0; i < len; ++i) {
        hilbert::curve::indexToPosition(
            int64_t(1) << nn,
            static_cast<int64_t>(std::stoll(h[i], nullptr, 2)),
            &x[i],
            &y[i]
        );
    }

    const cpp11::writable::strings xx(len), yy(len);
    for (size_t i = 0; i < len; ++i) {
        xx[i] = std::bitset<64>(x[i]).to_string();
        yy[i] = std::bitset<64>(y[i]).to_string();
    }

    xx.attr("class") = "bitstring";
    yy.attr("class") = "bitstring";

    return cpp11::writable::data_frame{
        "x"_nm = x,
        "y"_nm = y
    };
}