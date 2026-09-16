#pragma once

#define IMGUI_VERSION "1.89.9"
#define IMGUI_HAS_VIEWPORTS 0

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <math.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef unsigned int ImGuiID;
typedef int ImGuiCol;
typedef int ImGuiStyleVar;
typedef int ImGuiWindowFlags;
typedef int ImGuiInputTextFlags;
typedef int ImGuiTreeNodeFlags;
typedef int ImGuiSelectableFlags;
typedef int ImGuiComboFlags;
typedef int ImGuiTabBarFlags;
typedef int ImGuiTabItemFlags;
typedef int ImGuiFocusedFlags;
typedef int ImGuiHoveredFlags;
typedef int ImGuiDataAuthority;
typedef int ImGuiLayoutType;
typedef int ImGuiSliderFlags;

struct ImVec2 {
    float x, y;
    ImVec2() : x(0.0f), y(0.0f) {}
    ImVec2(float _x, float _y) : x(_x), y(_y) {}
};

struct ImVec4 {
    float x, y, z, w;
    ImVec4() : x(0.0f), y(0.0f), z(0.0f), w(0.0f) {}
    ImVec4(float _x, float _y, float _z, float _w) : x(_x), y(_y), z(_z), w(_w) {}
};

namespace ImGui {
    bool Begin(const char* name, bool* p_open = NULL, ImGuiWindowFlags flags = 0);
    void End();
    
    bool BeginChild(const char* str_id, const ImVec2& size = ImVec2(0,0), bool border = false, ImGuiWindowFlags flags = 0);
    void EndChild();
    
    bool Button(const char* label, const ImVec2& size = ImVec2(0,0));
    bool Checkbox(const char* label, bool* v);
    bool SliderFloat(const char* label, float* v, float v_min, float v_max, const char* format = "%.3f", ImGuiSliderFlags flags = 0);
    
    void Text(const char* fmt, ...);
    void SameLine(float offset_from_start_x = 0.0f, float spacing = -1.0f);
}

#ifdef __cplusplus
}
#endif
