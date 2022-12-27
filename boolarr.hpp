#include <string>
#include <iostream>
#include <math.h>
#include <stdexcept>

class boolarray;

class bitarray
{
    size_t __i;
    boolarray *__ref;

public:
    bitarray(boolarray *, size_t);
    
    friend std::ostream &operator<<(std::ostream &, bitarray&);

    bitarray &operator=(bool);

    bool operator==(bitarray&);

    unsigned long operator+(uint8_t&);

    bool operator&();
};

class boolarray
{
    size_t __dt_lenght, __f_size, __a_size;
    uint64_t *__dt;

public:
    boolarray(size_t __size) : __a_size(__size)
    {
        __dt_lenght = __size / 64;
        if (__size % 64 != 0)
        {
            __dt_lenght++;
        }
        __f_size = __dt_lenght * 64;
        __dt = new uint64_t[__dt_lenght];
        for (size_t i = 0; i < __dt_lenght; i++)
        {
            __dt[i] = 0;
        }
    }

    bitarray &operator[](size_t __index)
    {
        bitarray *__res;
        __res = new bitarray(this, __index);
        return *__res;
    }

    void set(size_t __index, bool __value)
    {
        if(this->get(__index) != __value){
            if(__value){
                __dt[__index / 64] += static_cast<uint64_t>(pow(2, (64 - (__index % 64))) / 2);
            }else{
                __dt[__index / 64] -= static_cast<uint64_t>(pow(2, (64 - (__index % 64))) / 2);
            }
        }
    }

    bool get(size_t __index)
    {
        if(__index >= __a_size){
            throw std::overflow_error("index out of range");
        }
        return (__dt[__index / 64] << (__index % 64)) >> 63;
    }

    void resize(size_t __size){
        if(__size > __a_size){
            throw std::overflow_error("new size is larger than the occupied limit");
        }else{
            __a_size = __size;
        }
    }

    ~boolarray()
    {
        free(__dt);
        __dt = NULL;
    }
};

bitarray::bitarray(boolarray *__refrence, size_t __index) : __i(__index), __ref(__refrence)
{
}

std::ostream &operator<<(std::ostream &out, bitarray& arr)
{
    out << arr.__ref->get(arr.__i);
    return out;
}

bitarray &bitarray::operator=(bool __value)
{
    this->__ref->set(this->__i, __value);
    return *this;
}

bool bitarray::operator==(bitarray& __value){
    return __ref->get(__i) == __value.__ref->get(__value.__i);
}

unsigned long bitarray::operator+(uint8_t& __value){
    return __value + __ref->get(__i);
}

bool bitarray::operator&(){
    return __ref->get(__i);
}