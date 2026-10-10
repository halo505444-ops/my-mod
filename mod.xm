#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// لینکی ڕاستەوخۆی وێنەکەت لە گیتهەب
static const char* mamaHalaImageURL = "https://raw.githubusercontent.com/halo505444-ops/my-mod/main/MamaHala.jpg";

static float textStartTime = -1.0f;
static const char* targetText = "MAMAHALA";

void DrawMamaHalaOverlay(ImTextureID logo_texture) {
    
    if (textStartTime < 0) {
        textStartTime = ImGui::GetTime();
    }

    // کردنەوەی پەنجەرە بێ سەردێڕ بۆ ئەوەی ڕێک شوێنی پێشوو داپۆشێت
    ImGui::SetNextWindowBgAlpha(0.90f);
    ImGui::Begin("HEXA_IOS_OVERLAY", NULL, ImGuiWindowFlags_NoCollapse | ImGuiWindowFlags_AlwaysAutoResize | ImGuiWindowFlags_NoTitleBar);

    // --- ١. قەبارەی ڕەسمەکە بۆ ئەوەی گەورە بێت و HEXA IOS داپۆشێت ---
    ImVec2 imageSize = ImVec2(220.0f, 220.0f); 
    
    if (logo_texture) {
        ImGui::Image(logo_texture, imageSize);
    } else {
        ImGui::Text("Loading Image...");
    }

    // --- ٢. ئەنیمەیشنی پیت بە پیتی نوسینی MAMAHALA ---
    int totalChars = strlen(targetText);
    float elapsedTime = ImGui::GetTime() - textStartTime;
    
    float charDelay = 0.18f;    // خێرایی پیتەکان
    float holdDuration = 2.5f;   // ماوەی مانەوەی نوسینەکە پێش ونبوون

    int charsToShow = (int)(elapsedTime / charDelay);

    if (charsToShow <= totalChars) {
        // قۆناغی ۱: تایپکردنی پیتەکان یەک لەدوای یەک
        char tempBuffer[32] = {0};
        strncpy(tempBuffer, targetText, charsToShow);
        
        ImGui::SetCursorPosX((imageSize.x - ImGui::CalcTextSize(tempBuffer).x) * 0.5f);
        ImGui::TextColored(ImVec4(1.0f, 0.8f, 0.0f, 1.0f), "%s", tempBuffer);
    } 
    else if (elapsedTime < (totalChars * charDelay + holdDuration)) {
        // قۆناغی ۲: مانەوەی تەواوی وشەکە بۆ ماوەیەک
        ImGui::SetCursorPosX((imageSize.x - ImGui::CalcTextSize(targetText).x) * 0.5f);
        ImGui::TextColored(ImVec4(1.0f, 0.8f, 0.0f, 1.0f), "%s", targetText);
    }
    // قۆناغی ۳: دوای تەواوبوونی ئەم ماوەیە، نوسینی MAMAHALA لادەچێت و ون دەبێت،
    // بەڵام وێنە گەورەکەی MamaHala بە هیچ شێوەیەک لاناچێت و دەمێنێتەوە!

    ImGui::End();
}
