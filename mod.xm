#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

static float textStartTime = -1.0f;
static const char* targetText = "MAMAHALA";

void DrawMamaHalaOverlay(void* logo_texture) {
    
    if (textStartTime < 0) {
        textStartTime = ImGui::GetTime();
    }

    ImGui::SetNextWindowBgAlpha(0.90f);
    ImGui::Begin("HEXA_IOS_OVERLAY", NULL, ImGuiWindowFlags_NoCollapse | ImGuiWindowFlags_AlwaysAutoResize | ImGuiWindowFlags_NoTitleBar);

    // --- قەبارەی وێنە بۆ داپۆشینی شوێنی پێشوو ---
    ImVec2 imageSize = ImVec2(220.0f, 220.0f); 
    
    if (logo_texture) {
        ImGui::Image(logo_texture, imageSize);
    }

    // --- ئەنیمەیشنی پیت بە پیتی MAMAHALA ---
    int totalChars = strlen(targetText);
    float elapsedTime = ImGui::GetTime() - textStartTime;
    
    float charDelay = 0.18f;    
    float holdDuration = 2.5f;   

    int charsToShow = (int)(elapsedTime / charDelay);

    if (charsToShow <= totalChars) {
        char tempBuffer[32] = {0};
        strncpy(tempBuffer, targetText, charsToShow);
        
        ImGui::SetCursorPosX((imageSize.x - ImGui::CalcTextSize(tempBuffer).x) * 0.5f);
        ImGui::TextColored(ImVec4(1.0f, 0.8f, 0.0f, 1.0f), "%s", tempBuffer);
    } 
    else if (elapsedTime < (totalChars * charDelay + holdDuration)) {
        ImGui::SetCursorPosX((imageSize.x - ImGui::CalcTextSize(targetText).x) * 0.5f);
        ImGui::TextColored(ImVec4(1.0f, 0.8f, 0.0f, 1.0f), "%s", targetText);
    }

    ImGui::End();
}
