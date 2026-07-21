#ifndef VINHTRAN_HPP_INCLUDED
#define VINHTRAN_HPP_INCLUDED

#include <string>
#include <cmath>
#include <vector>

// Định nghĩa các struct cơ bản thay cho ImGui
struct ImVec2 {
    float x, y;
    ImVec2() : x(0), y(0) {}
    ImVec2(float _x, float _y) : x(_x), y(_y) {}
};

struct ImVec4 {
    float x, y, z, w;
    ImVec4() : x(0), y(0), z(0), w(0) {}
    ImVec4(float _x, float _y, float _z, float _w) : x(_x), y(_y), z(_z), w(_w) {}
};

struct ImColor {
    ImVec4 Value;
    ImColor() : Value(0,0,0,1) {}
    ImColor(float r, float g, float b, float a = 1.0f) : Value(r,g,b,a) {}
    ImColor(int r, int g, int b, int a = 255) : Value(r/255.0f, g/255.0f, b/255.0f, a/255.0f) {}
};

struct ImDrawList {
    // Stub
};

struct ImFont {
    // Stub
};

// Các macro cơ bản
#define ImCalcTextSize(str) ImVec2(0,0)
#define calc_size(size, str) ImVec2(0,0)

#define HOOKAF(ret, func, ...)      \
    ret (*old_##func)(__VA_ARGS__); \
    ret hook_##func(__VA_ARGS__)

#define const_ptr(object, offset) *reinterpret_cast<uintptr_t *>(object + offset)
#define Str(ret) std::to_string(ret).c_str()
#define const_ptr_set(type, object, offset) *reinterpret_cast<type *>(object + offset)
#define const_field(type, object, offset) *reinterpret_cast<type *>(reinterpret_cast<uintptr_t>(object) + offset)
#define const_field_set(ret, first, second, val) *reinterpret_cast<ret *>(reinterpret_cast<uintptr_t>(first) + second) = val
#define const_dict(retf, rets, first, second) *reinterpret_cast<monoDictionary<retf, rets> **>(reinterpret_cast<uintptr_t>(first) + second)
#define const_array(retf, first, second) *reinterpret_cast<monoArray<retf> **>(reinterpret_cast<uintptr_t>(first) + second)

// ImVec2 operators
static inline ImVec2 operator*(const ImVec2 &lhs, const float rhs) { return ImVec2(lhs.x * rhs, lhs.y * rhs); }
static inline ImVec2 operator/(const ImVec2 &lhs, const float rhs) { return ImVec2(lhs.x / rhs, lhs.y / rhs); }
static inline ImVec2 operator+(const ImVec2 &lhs, const float rhs) { return ImVec2(lhs.x + rhs, lhs.y + rhs); }
static inline ImVec2 operator+(const ImVec2 &lhs, const ImVec2 &rhs) { return ImVec2(lhs.x + rhs.x, lhs.y + rhs.y); }
static inline ImVec2 operator-(const ImVec2 &lhs, const ImVec2 &rhs) { return ImVec2(lhs.x - rhs.x, lhs.y - rhs.y); }
static inline ImVec2 operator-(const ImVec2 &lhs, const float rhs) { return ImVec2(lhs.x - rhs, lhs.y - rhs); }
static inline ImVec2 operator*(const ImVec2 &lhs, const ImVec2 &rhs) { return ImVec2(lhs.x * rhs.x, lhs.y * rhs.y); }
static inline ImVec2 operator/(const ImVec2 &lhs, const ImVec2 &rhs) { return ImVec2(lhs.x / rhs.x, lhs.y / rhs.y); }
static inline ImVec2 &operator*=(ImVec2 &lhs, const float rhs) { lhs.x *= rhs; lhs.y *= rhs; return lhs; }
static inline ImVec2 &operator/=(ImVec2 &lhs, const float rhs) { lhs.x /= rhs; lhs.y /= rhs; return lhs; }
static inline ImVec2 &operator+=(ImVec2 &lhs, const ImVec2 &rhs) { lhs.x += rhs.x; lhs.y += rhs.y; return lhs; }
static inline ImVec2 &operator-=(ImVec2 &lhs, const ImVec2 &rhs) { lhs.x -= rhs.x; lhs.y -= rhs.y; return lhs; }
static inline ImVec2 &operator*=(ImVec2 &lhs, const ImVec2 &rhs) { lhs.x *= rhs.x; lhs.y *= rhs.y; return lhs; }
static inline ImVec2 &operator/=(ImVec2 &lhs, const ImVec2 &rhs) { lhs.x /= rhs.x; lhs.y /= rhs.y; return lhs; }

inline ImVec2 flooring(ImVec2 vec) { return ImVec2((float)(int)vec.x, (float)(int)vec.y); }
inline ImVec2 flooring(float x, float y) { return ImVec2((float)(int)x, (float)(int)y); }
inline ImVec2 flooring(int x, int y) { return ImVec2((float)x, (float)y); }

// Stub functions
inline void AddText(ImFont *font, float size, bool shadow, bool outline, const ImVec2 &textpos, ImColor col, std::string value, ImDrawList *drawlist = nullptr) {}
inline void drawcircleglow(ImDrawList *draw, ImVec2 pos, float rad, ImColor col, int segm, int thickness, int size) {}
inline ImVec2 delvec(ImVec2 a, float b) { return ImVec2(a.x - b, a.y - b); }
inline ImVec2 addvec(ImVec2 a, float b) { return ImVec2(a.x + b, a.y + b); }
inline void OtFovV1(float x, float y, float radius, float min_angle, float max_angle, ImColor col, float thickness) {}

// Vector3 struct
struct Vector3 {
    float x, y, z;
    Vector3() : x(0), y(0), z(0) {}
    Vector3(float _x, float _y, float _z) : x(_x), y(_y), z(_z) {}
    static Vector3 zero() { return Vector3(0,0,0); }
    static float Distance(Vector3 a, Vector3 b) {
        float dx = a.x - b.x;
        float dy = a.y - b.y;
        float dz = a.z - b.z;
        return sqrt(dx*dx + dy*dy + dz*dz);
    }
    static Vector3 Normalized(Vector3 v) {
        float len = sqrt(v.x*v.x + v.y*v.y + v.z*v.z);
        if (len == 0) return Vector3(0,0,0);
        return Vector3(v.x/len, v.y/len, v.z/len);
    }
    static float Dot(Vector3 a, Vector3 b) {
        return a.x*b.x + a.y*b.y + a.z*b.z;
    }
    static Vector3 Cross(Vector3 a, Vector3 b) {
        return Vector3(
            a.y*b.z - a.z*b.y,
            a.z*b.x - a.x*b.z,
            a.x*b.y - a.y*b.x
        );
    }
    static float Angle(Vector3 a, Vector3 b) {
        float dot = Dot(a, b);
        float lenA = sqrt(a.x*a.x + a.y*a.y + a.z*a.z);
        float lenB = sqrt(b.x*b.x + b.y*b.y + b.z*b.z);
        if (lenA == 0 || lenB == 0) return 0;
        return acos(dot / (lenA * lenB));
    }
    Vector3 operator-(const Vector3& other) const {
        return Vector3(x - other.x, y - other.y, z - other.z);
    }
    Vector3 operator+(const Vector3& other) const {
        return Vector3(x + other.x, y + other.y, z + other.z);
    }
    Vector3 operator*(float scalar) const {
        return Vector3(x * scalar, y * scalar, z * scalar);
    }
    Vector3 operator/(float scalar) const {
        return Vector3(x / scalar, y / scalar, z / scalar);
    }
};

struct Vvector3 {
    float X, Y, Z;
    Vvector3() : X(0), Y(0), Z(0) {}
    Vvector3(float X1, float Y1, float Z1) : X(X1), Y(Y1), Z(Z1) {}
    Vvector3(const Vvector3 &v) : X(v.X), Y(v.Y), Z(v.Z) {}
    ~Vvector3() {}
};

struct display {
    ImVec2 wh;
    float width;
    float height;
} disp;

#endif // VINHTRAN_HPP_INCLUDED
