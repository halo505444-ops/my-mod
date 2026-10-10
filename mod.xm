#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#include "ImGui/imgui.h"

// لینکی ڕاستەوخۆی وێنەکەت لە گیتهەب
static const char* mamaHalaImageURL = "https://raw.githubusercontent.com/halo505444-ops/my-mod/main/MamaHala.jpg";

static float textStartTime = -1.0f;
static const char* targetText = "MAMAHALA";

void DrawMamaHalaOverlay(ImTextureID logo_texture) {
    
    if (textStartTime < 0) {
        textStartTime = ImGui::GetTime();
    }

    // دروستکردنی پەنجەرە بە بێ نیشاندانی سەردێڕ بۆ ئەوەی بە تەواوی شوێنی مەبەست داپۆشێت
    ImGui::SetNextWindowBgAlpha(0.90f);
    ImGui::Begin("HEXA_IOS_OVERLAY", NULL, ImGuiWindowFlags_NoCollapse | ImGuiWindowFlags_AlwaysAutoResize | ImGuiWindowFlags_NoTitleBar);

    // --- ١. شوێن و قەبارەی ڕەسمەکە (بۆ داپۆشینی HEXA IOS و بە گەورەیی) ---
    // قەبارەی گەورە دەکەین تا بە تەواوی جێگەی HEXA IOS بگرێت و دیار بێت
    ImVec2 imageSize = ImVec2(220.0f, 220.0f); 
    
    if (logo_texture) {
        // نیشاندانی وێنەی MamaHala بە گەورەیی لە سەرەوە
        ImGui::Image(logo_texture, imageSize);
    } else {
        // ئەگەر تێکسچەرەکە هێشتا بارنەبووبە، شوێنەکە بە نوسینێک دەگرێت
        ImGui::Text("HEXA IOS (Loading Image...)");
    }

    // --- ٢. ئەنیمەیشنی پیت بە پیتی نوسینی MAMAHALA لەسەر/لەژێر وێنەکە ---
    int totalChars = strlen(targetText);
    float elapsedTime = ImGui::GetTime() - textStartTime;
    
    float charDelay = 0.18f;    // خێرایی دەرکەوتنی پیتەکان
    float holdDuration = 2.5f;   // ماوەی مانەوەی نوسینەکە پێش ونبوون

    int charsToShow = (int)(elapsedTime / charDelay);

    if (charsToShow <= totalChars) {
        // قۆناغی ۱: پیتەکان یەک لەدوای یەک دەردەکەون (تایپ دەبن)
        char tempBuffer[32] = {0};
        strncpy(tempBuffer, targetText, charsToShow);
        
        ImGui::SetCursorPosX((imageSize.x - ImGui::CalcTextSize(tempBuffer).x) * 0.5f);
        ImGui::TextColored(ImVec4(1.0f, 0.8f, 0.0f, 1.0f), "%s", tempBuffer); // ڕەنگی زەردی جوان
    } 
    else if (elapsedTime < (totalChars * charDelay + holdDuration)) {
        // قۆناغی ۲: وشەی MAMAHALA بە تەواوی دەمێنێتەوە
        ImGui::SetCursorPosX((imageSize.x - ImGui::CalcTextSize(targetText).x) * 0.5f);
        ImGui::TextColored(ImVec4(1.0f, 0.8f, 0.0f, 1.0f), "%s", targetText);
    }
    // قۆناغی ۳: دوای تەواوبوونی ئەم ماوەیە، نوسینی MAMAHALA لادەچێت و ون دەبێت،
    // بەڵام وێنە گەورەکەی MamaHala بە هیچ شێوەیەک لاناچێت و لە شوێنی خۆی دەمێنێتەوە!

    ImGui::End();
}
