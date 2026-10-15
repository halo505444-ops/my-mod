<?xml version="1.0" encoding="utf-8"?>
<mod id="ShazaVIP_Welcome_Banner" version="1.0">
    <info>
        <name>ShazaVIP Animated Welcome UI</name>
        <author>MAMAHALA</author>
        <description>Shows dynamic glowing text after 20 seconds in-game.</description>
    </info>

    <!-- Configuration for UI & Timer -->
    <config>
        <!-- Delay in seconds (20 seconds) -->
        <property name="delay_seconds" value="20" />
        <property name="display_duration" value="10" /> <!-- ماوەی نیشاندانی دەقەکە -->
    </config>

    <!-- Visual Layer & Styles -->
    <ui_elements>
        <overlay_screen id="vip_banner_layer" align="center" vertical_align="center">
            
            <!-- Main VIP Title with Glow Animation -->
            <text_box id="txt_vip_main" 
                      text="⚡️SHAZAVIP⚡️" 
                      font_size="64" 
                      font_style="bold"
                      color="#FFD700" 
                      glow_color="#00FFFF" 
                      glow_radius="15" 
                      animation="pulse_and_bounce" 
                      animation_speed="1.2s">
            </text_box>

            <!-- Subtitle Text -->
            <text_box id="txt_server_welcome" 
                      text="💥WELCOME TO SERVER MAMAHALA💥" 
                      font_size="28" 
                      font_style="bold"
                      color="#FF4500" 
                      glow_color="#FF007F" 
                      glow_radius="8" 
                      margin_top="25"
                      animation="fade_in_up" 
                      animation_delay="0.5s">
            </text_box>

        </overlay_screen>
    </ui_elements>

    <!-- Logic / Timer Execution -->
    <script>
        <![CDATA[
        function onPlayerJoinGame() {
            -- Wait for 20 seconds
            Timer.start(20, function() {
                showAnimatedBanner();
            });
        }

        function showAnimatedBanner() {
            UI.setVisibility("vip_banner_layer", true);
            UI.playAnimation("txt_vip_main");
            UI.playAnimation("txt_server_welcome");
            
            -- Automatically hide after 10 seconds
            Timer.start(10, function() {
                UI.fadeOut("vip_banner_layer", 2.0);
            });
        }
        ]]>
    </script>
</mod>
