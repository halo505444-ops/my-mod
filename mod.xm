<?xml version="1.0" encoding="utf-8"?>
<ModMenu>
    <!-- Menu Header Configuration -->
    <Header>
        <Title>SHAZA ⚡️ VIP</Title>
        <Subtitle>Exclusive iOS Mod Menu</Subtitle>
        <Version>v3.0 Ultimate</Version>
        <Developer>SHAZA Team</Developer>
        <TextColor>#FFD700</TextColor>
        <BackgroundColor>#1A1A1A</BackgroundColor>
        <BorderColor>#FF4500</BorderColor>
    </Header>

    <!-- Welcome Toast / Notification -->
    <Notification>
        <Message>Welcome to SHAZA ⚡️ VIP Menu! Enjoy your game.</Message>
        <Duration>3</Duration>
    </Notification>

    <!-- Category: Visual & ESP Features -->
    <Category name="👁️ Visual &amp; ESP">
        <Toggle name="Player ESP Box" default="false">
            <Offset>0x00000000</Offset>
            <SelectedValue>1</SelectedValue>
            <UnselectedValue>0</UnselectedValue>
        </Toggle>
        
        <Toggle name="Player ESP Line" default="false">
            <Offset>0x00000004</Offset>
            <SelectedValue>1</SelectedValue>
            <UnselectedValue>0</UnselectedValue>
        </Toggle>

        <Toggle name="Player Distance &amp; Health" default="true">
            <Offset>0x00000008</Offset>
            <SelectedValue>1</SelectedValue>
            <UnselectedValue>0</UnselectedValue>
        </Toggle>
    </Category>

    <!-- Category: Aim & Combat -->
    <Category name="🎯 Combat &amp; Aim">
        <Toggle name="Aimbot Magic" default="false">
            <Offset>0x00000010</Offset>
            <SelectedValue>1</SelectedValue>
            <UnselectedValue>0</UnselectedValue>
        </Toggle>

        <Slider name="Aimbot FOV" min="10" max="360" step="10" default="90">
            <Offset>0x00000014</Offset>
        </Slider>

        <Toggle name="No Recoil (Ultra)" default="true">
            <Offset>0x00000018</Offset>
            <SelectedValue>1</SelectedValue>
            <UnselectedValue>0</UnselectedValue>
        </Toggle>
    </Category>

    <!-- Category: Misc & Fun -->
    <Category name="⚡️ Misc &amp; Bypass">
        <Toggle name="iPad View (Ultrawide)" default="false">
            <Offset>0x0000001C</Offset>
            <SelectedValue>1</SelectedValue>
            <UnselectedValue>0</UnselectedValue>
        </Toggle>

        <Toggle name="Anti-Ban Shield" default="true">
            <Offset>0x00000020</Offset>
            <SelectedValue>1</SelectedValue>
            <UnselectedValue>0</UnselectedValue>
        </Toggle>
    </Category>

    <!-- Footer Information -->
    <Footer>
        <Text>Powered by SHAZA ⚡️ VIP Engine</Text>
    </Footer>
</ModMenu>
