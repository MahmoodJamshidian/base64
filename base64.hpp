#include <iostream>
#include "boolarr.hpp"
#include <string>
#include <string.h>
#include <cstdlib>
#include <stdexcept>

const char *base64_chars =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    "abcdefghijklmnopqrstuvwxyz"
    "0123456789+/";

std::string b64encode(const char *__msg)
{
    size_t __size = strlen(__msg);
    boolarray arr(__size * 8);
    for (size_t __i = 0; __i < __size; __i++)
    {
        for (uint8_t __j = 0; __j < 8; __j++)
        {
            arr[(__i * 8) + __j] = (static_cast<char>(__msg[__i] << __j) >> 7);
        }
    }

    uint8_t __char = 0, __cont = 0;
    std::string res;

    for (size_t __i = 0; __i < __size * 8; __i++)
    {
        __cont++;
        __char <<= 1;
        __char += &arr[__i];
        if (__cont == 6)
        {
            res += base64_chars[__char];
            __char = 0;
            __cont = 0;
        }
    }

    if (__cont)
    {
        __char <<= (__cont = 6 - __cont);
        res += base64_chars[__char];
        uint8_t __padding_lenght = 0;
        while ((__cont + 6 * __padding_lenght) % 8 != 0)
        {
            __padding_lenght++;
            res += '=';
        }
    }
    return res;
}

std::string b64decode(const char *__msg)
{
    size_t __size = strlen(__msg);
    boolarray arr(__size * 6);
    char __l_char;
    size_t __p_msg = 0, __e_msg = 0;
    for (size_t __i = 0; __i < __size; __i++)
    {
        __l_char = -1;
        for (uint8_t __j = 0; __j < 64; __j++)
        {
            if (__msg[__i] == base64_chars[__j])
            {
                __l_char = __j;
                break;
            }
        }
        if (__e_msg && __msg[__i] != '=')
        {
            throw std::runtime_error("this is not base64 format");
        }
        if (__l_char == -1)
        {
            if (__msg[__i] == '=')
            {
                if (!__e_msg)
                {
                    __e_msg = __i * 6;
                }
                __p_msg++;
            }
            else
            {
                throw std::runtime_error("bytes can only contain ASCII literal characters");
            }
        }
        for (uint8_t __j = 0; __j < 6 && !__e_msg; __j++)
        {
            arr[(__i * 6) + __j] = (static_cast<char>(__l_char << (__j + 2)) >> 7);
        }
    }

    std::string res;
    __l_char = 0;
    uint8_t __cont = 0;
    __e_msg = __size * 6;
    if (__e_msg % 8 != 0)
    {
        throw std::runtime_error("incorrect padding");
    }
    for (size_t __i = 0; __i < __e_msg; __i++)
    {
        __cont++;
        __l_char <<= 1;
        __l_char += &arr[__i];
        if (__cont == 8)
        {
            res += __l_char;
            __l_char = 0;
            __cont = 0;
        }
    }
    if (__cont)
    {
        __l_char <<= (__cont = 8 - __cont);
        res += __l_char;
        if ((__cont + (__p_msg * 6)) % 8 != 0)
        {
            throw std::runtime_error("incorrect padding");
        }
    }
    return res;
}