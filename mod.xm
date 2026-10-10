#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#include "ImGui/imgui.h"

// گۆڕاوەکان بۆ ئەنیمەیشنی تایپکردن
static float textStartTime = -1.0f;
static const char* targetText = "MAMAHALA";

void DrawMamaHalaOverlay(ImTextureID logo_texture) {
    
    if (textStartTime < 0) {
        textStartTime = ImGui::GetTime();
    }

    // کردنەوەی پەنجەرەی ImGui بێ سەردێڕ و قەبارەی خۆکار
    ImGui::Begin("SHAZA VIP Overlay", NULL, ImGuiWindowFlags_NoCollapse | ImGuiWindowFlags_AlwaysAutoResize | ImGuiWindowFlags_NoTitleBar);

    // --- ١. نیشاندانی ڕەسمی MamaHala.jpg (قەبارەی گەورە: ١٨٠x١٨٠) ---
    // ئەم ڕەسمە هەمیشە دەمێنێتەوە و بە هیچ شێوەیەک لاناچێت
    ImVec2 logoSize = ImVec2(180.0f, 180.0f);
    if (logo_texture) {
        ImGui::Image(logo_texture, logoSize);
    }

    // --- ٢. ئەنیمەیشنی پیت بە پیتی نوسینی MAMAHALA ---
    int totalChars = strlen(targetText);
    float elapsedTime = ImGui::GetTime() - textStartTime;
    
    float charDelay = 0.20f;    // خێرایی دەرکەوتنی پیتەکان
    float holdDuration = 2.0f;   // ماوەی مانەوەی پیتەکان دوای تەواوبوون

    int charsToShow = (int)(elapsedTime / charDelay);

    if (charsToShow <= totalChars) {
        // قۆناغی ۱: پیتەکان یەک لەدوای یەک دەردەکەون (تایپ دەبن)
        char tempBuffer[32] = {0};
        strncpy(tempBuffer, targetText, charsToShow);
        
        // ناوەڕاستکردنی نوسینەکە لەژێر وێنەکەدا
        ImGui::SetCursorPosX((logoSize.x - ImGui::CalcTextSize(tempBuffer).x) * 0.5f);
        ImGui::Text("%s", tempBuffer);
    } 
    else if (elapsedTime < (totalChars * charDelay + holdDuration)) {
        // قۆناغی ۲: وشەکە بە تەواوی دەمێنێتەوە بۆ ماوەی ٢ چرکە
        ImGui::SetCursorPosX((logoSize.x - ImGui::CalcTextSize(targetText).x) * 0.5f);
        ImGui::Text("%s", targetText);
    }
    // قۆناغی ۳: دوای تەواوبوونی ئەم کاتە، نوسینەکە بە تەواوی لادەچێت و ون دەبێت، 
    // بەڵام وێنەی MamaHala.jpg لە جێگەی خۆی بە گەورەیی دەمێنێتەوە!

    ImGui::End();
}
