static bool should_show = false;

float fade_speed   = 0.03f;
float toasttimer   = 0.0f;
float toastmaxtime = 0.0f;
const char* toasttext = nullptr;

// Font global
ImFont* main_font = nullptr;

// Helper function
template<typename T>
inline T ImClamp(T value, T min, T max) {
    return std::max(min, std::min(max, value));
}

//==================================================
// TOAST
//==================================================
void RenderToast()
{
    if (toasttimer <= 0.0f || toasttext == nullptr)
        return;

    toasttimer -= 0.016f; // Delta time giả định

    float alpha = 1.0f;

    if (toasttimer < 0.1f)
        alpha = toasttimer * 10.0f;

    if (toasttimer > toastmaxtime - 0.1f)
        alpha = (toastmaxtime - toasttimer) * 10.0f;

    alpha = ImClamp(alpha, 0.0f, 1.0f);

    // Stub - không vẽ gì cả
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

    // Stub - không vẽ gì cả
}
