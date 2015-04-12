// Copyright Bruno Dutra 2015
// Distributed under the Boost Software License, Version 1.0.
// (See accompanying file LICENSE.txt or copy at http://boost.org/LICENSE_1_0.txt)

#ifndef BOOST_MPL2_LAMBDA_FUNCTION_HPP
#define BOOST_MPL2_LAMBDA_FUNCTION_HPP

#include <boost/mpl2/lambda/identity.hpp>
#include <boost/mpl2/lambda/quote.hpp>
#include <boost/mpl2/lambda/call.hpp>

namespace boost
{
    namespace mpl2
    {
        template<template<typename...> class expr>
        struct function :
                identity<function<expr> >
        {
            template<typename... args>
            using call = typename call<quote<expr>, args...>::type;
        };
    }
}

#endif
