static bool should_show = false;

float fade_speed   = 0.03f;
float toasttimer   = 0.0f;
float toastmaxtime = 0.0f;
const char* toasttext = nullptr;

// Font global
ImFont* main_font = nullptr;

//==================================================
// TOAST
//==================================================
void RenderToast()
{
    if (toasttimer <= 0.0f || toasttext == nullptr)
        return;

    toasttimer -= ImGui::GetIO().DeltaTime;

    float alpha = 1.0f;

    if (toasttimer < 0.1f)
        alpha = toasttimer * 10.0f;

    if (toasttimer > toastmaxtime - 0.1f)
        alpha = (toastmaxtime - toasttimer) * 10.0f;

    alpha = ImClamp(alpha, 0.0f, 1.0f);

    ImDrawList* draw = ImGui::GetForegroundDrawList();
    ImVec2 screen = ImGui::GetIO().DisplaySize;

    ImVec2 text_size;

    if (main_font)
        text_size = main_font->CalcTextSizeA(22.0f, FLT_MAX, 0.0f, toasttext);
    else
        text_size = ImGui::CalcTextSize(toasttext);

    ImVec2 box_min(
        screen.x * 0.5f - text_size.x * 0.5f - 20.0f,
        screen.y * 0.8f - text_size.y * 0.5f - 16.0f - alpha * 5.0f
    );

    ImVec2 box_max(
        screen.x * 0.5f + text_size.x * 0.5f + 20.0f,
        screen.y * 0.8f + text_size.y * 0.5f + 16.0f - alpha * 5.0f
    );

    // nền
    draw->AddRectFilled(
        box_min,
        box_max,
        ImColor(0.08f, 0.08f, 0.08f, alpha),
        8.0f
    );

    // viền nhẹ
    draw->AddRect(
        box_min,
        box_max,
        ImColor(1.0f, 1.0f, 1.0f, alpha * 0.15f),
        8.0f,
        0,
        1.0f
    );

    ImVec2 text_pos(
        screen.x * 0.5f - text_size.x * 0.5f,
        screen.y * 0.8f - text_size.y * 0.5f - alpha * 5.0f
    );

    if (main_font)
    {
        draw->AddText(
            main_font,
            22.0f,
            text_pos,
            ImColor(1.0f, 1.0f, 1.0f, alpha),
            toasttext
        );
    }
    else
    {
        draw->AddText(
            text_pos,
            ImColor(1.0f, 1.0f, 1.0f, alpha),
            toasttext
        );
    }
}

void Toast(const char* text, int length = 1)
{
    toasttext    = text;
    toasttimer   = (float)length;
    toastmaxtime = (float)length;
}

//==================================================
// ALPHA
//==================================================
void update_alpha(bool condition, float& alpha)
{
    if (condition)
    {
        alpha += fade_speed;
        if (alpha > 1.0f)
            alpha = 1.0f;
    }
    else
    {
        alpha -= fade_speed;
        if (alpha < 0.0f)
            alpha = 0.0f;
    }
}

//==================================================
// PRESENT
//==================================================
float back_alpha = 0.0f;
float text_y     = 0.0f;

void draw_present()
{
    if (!main_font)
        return;

    const char* text = "BRUTALTRIP";

    ImDrawList* draw = ImGui::GetBackgroundDrawList();
    ImVec2 screen = ImGui::GetIO().DisplaySize;

    float fontSize = 70.0f;

    ImVec2 text_size =
        main_font->CalcTextSizeA(fontSize, FLT_MAX, 0.0f, text);

    ImVec2 text_pos(
        screen.x * 0.5f - text_size.x * 0.5f,
        screen.y * 0.5f - text_size.y * 0.5f + text_y
    );

    if (back_alpha > 0.0f)
    {
        draw->AddRectFilled(
            ImVec2(0.0f, 0.0f),
            screen,
            IM_COL32(60, 60, 60, (int)(100 * back_alpha))
        );

        draw->AddText(
            main_font,
            fontSize,
            text_pos,
            IM_COL32(255, 255, 255, (int)(255 * back_alpha)),
            text
        );
    }
}