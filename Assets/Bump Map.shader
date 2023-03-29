Shader "Custom/Bump Map"
{
    Properties
    {
        // Setting property values and ranges to change in the unity editor
       _myDiffuse("Diffuse Texture", 2D) = "white" {}
        _myBump("Bump Texture", 2D) = "bump" {}
        _mySlider("Bump Amount", Range(0,10)) = 1

        _Color("Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        CGPROGRAM
        // Specify to unity that a surface shader called "surf" is being created with the built-in "Lambert" lighting model
        #pragma surface surf Lambert

        // Define the variables that were created in "Properties"
        sampler2D _myDiffuse;
        sampler2D _myBump;
        half _mySlider;

        float4 _Color;

        struct Input
        {
            // UV coordinates for the diffuse texture.
            float2 uv_myDiffuse;
            // UV coordinates for the bump texture.
            float2 uv_myBump;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            // Sample the diffuse texture and assign it to the Albedo property.
            o.Albedo = tex2D(_myDiffuse, IN.uv_myDiffuse).rgb * _Color.rgb;

            // Sample the bump texture, unpack its normal vector, and scale it by the bump amount.
            o.Normal = UnpackNormal(tex2D(_myBump, IN.uv_myBump));

            // Multiple the effect on the x and y axis (since it's a 2D texture) by the "_mySlider" amount
            o.Normal *= float3(_mySlider,_mySlider,1);
        }
        ENDCG
    }
    Fallback "Diffuse"
}