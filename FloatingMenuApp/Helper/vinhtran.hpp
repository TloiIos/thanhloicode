#ifndef VINHTRAN_HPP_INCLUDED
#define VINHTRAN_HPP_INCLUDED

#include <string>
#include <cmath>
#include <vector>
#include <algorithm>
#include <chrono>

// ==================== IMGUI STUB ====================
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
    void AddCircle(ImVec2 center, float radius, ImColor col, int segments, float thickness) {}
    void AddLine(ImVec2 p1, ImVec2 p2, ImColor col, float thickness) {}
    void AddRect(ImVec2 p1, ImVec2 p2, ImColor col, float rounding, int flags, float thickness) {}
    void AddRectFilled(ImVec2 p1, ImVec2 p2, ImColor col, float rounding) {}
    void AddText(ImFont* font, float size, ImVec2 pos, ImColor col, const char* text) {}
    void AddTriangleFilled(ImVec2 p1, ImVec2 p2, ImVec2 p3, ImColor col) {}
    void AddTriangle(ImVec2 p1, ImVec2 p2, ImVec2 p3, ImColor col, float thickness) {}
    void AddQuad(ImVec2 p1, ImVec2 p2, ImVec2 p3, ImVec2 p4, ImColor col, float thickness) {}
};

struct ImFont {
    ImVec2 CalcTextSizeA(float size, float maxWidth, float unknown, const char* text) { return ImVec2(0,0); }
};

struct ImRect {
    ImVec2 Min, Max;
    ImRect(ImVec2 min, ImVec2 max) : Min(min), Max(max) {}
    ImVec2 GetCenter() { return ImVec2((Min.x + Max.x)/2, (Min.y + Max.y)/2); }
};

// ==================== IMGUI NAMESPACE STUB ====================
namespace ImGui {
    struct IO {
        ImVec2 DisplaySize;
        double DeltaTime;
        ImFont* Fonts[10];
    };
    static IO GetIO() { 
        IO io; 
        io.DisplaySize = ImVec2(0,0); 
        io.DeltaTime = 0.016f;
        return io; 
    }
    static ImDrawList* GetBackgroundDrawList() { return new ImDrawList(); }
    static ImDrawList* GetForegroundDrawList() { return new ImDrawList(); }
}

// ==================== MACROS ====================
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

// ==================== IMVEC2 OPERATORS ====================
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

inline ImVec2 delvec(ImVec2 a, float b) { return ImVec2(a.x - b, a.y - b); }
inline ImVec2 addvec(ImVec2 a, float b) { return ImVec2(a.x + b, a.y + b); }

// ==================== STUB FUNCTIONS ====================
inline void AddText(ImFont *font, float size, bool shadow, bool outline, const ImVec2 &textpos, ImColor col, std::string value, ImDrawList *drawlist = nullptr) {}
inline void drawcircleglow(ImDrawList *draw, ImVec2 pos, float rad, ImColor col, int segm, int thickness, int size) {}
inline void drawlineglow(ImDrawList* draw, ImVec2 start, ImVec2 end, ImColor col, int thickness, int size) {}
inline void Draw3DCircle(Vector3 pos, float radius, float stroke, ImColor color, float segments, bool filled, float fillopacity) {}
inline void OtFovV1(float x, float y, float radius, float min_angle, float max_angle, ImColor col, float thickness) {}

// ==================== CLAMP ====================
template<typename T>
inline T clamp(T value, T min, T max) {
    return std::max(min, std::min(max, value));
}

// ==================== RAD/DEG ====================
#define PI 3.14159265358979323846f
#define Deg2Rad (PI / 180.0f)
#define Rad2Deg (180.0f / PI)

// ==================== VECTOR3 ====================
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
        if (len < 0.0001f) return Vector3(0,0,0);
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
        if (lenA < 0.0001f || lenB < 0.0001f) return 0;
        float cosAngle = dot / (lenA * lenB);
        if (cosAngle > 1.0f) cosAngle = 1.0f;
        if (cosAngle < -1.0f) cosAngle = -1.0f;
        return acos(cosAngle);
    }
    
    static Vector3 Lerp(Vector3 a, Vector3 b, float t) {
        return Vector3(
            a.x + (b.x - a.x) * t,
            a.y + (b.y - a.y) * t,
            a.z + (b.z - a.z) * t
        );
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
        if (scalar < 0.0001f) return Vector3(0,0,0);
        return Vector3(x / scalar, y / scalar, z / scalar);
    }
    
    bool operator==(const Vector3& other) const {
        return x == other.x && y == other.y && z == other.z;
    }
};

// ==================== QUATERNION STUB ====================
struct Quaternion {
    float x, y, z, w;
    Quaternion() : x(0), y(0), z(0), w(1) {}
    Quaternion(float _x, float _y, float _z, float _w) : x(_x), y(_y), z(_z), w(_w) {}
    
    static Quaternion LookRotation(Vector3 forward, Vector3 up) {
        // Đơn giản hóa - chỉ trả về identity
        return Quaternion(0, 0, 0, 1);
    }
};

// ==================== VVECTOR3 ====================
struct Vvector3 {
    float X, Y, Z;
    Vvector3() : X(0), Y(0), Z(0) {}
    Vvector3(float X1, float Y1, float Z1) : X(X1), Y(Y1), Z(Z1) {}
    Vvector3(const Vvector3 &v) : X(v.X), Y(v.Y), Z(v.Z) {}
    ~Vvector3() {}
};

// ==================== DISPLAY ====================
struct display {
    ImVec2 wh;
    float width;
    float height;
} disp;

// ==================== MONO STRING ====================
struct monoString {
    void* klass;
    void* monitor;
    int length;
    char chars[1];
    
    std::string toCPPString() {
        return std::string(chars, length);
    }
};

// ==================== FMT ====================
namespace fmt {
    template<typename T>
    std::string format(const char* fmt, T arg) {
        return std::to_string(arg);
    }
}

#endif // VINHTRAN_HPP_INCLUDED
