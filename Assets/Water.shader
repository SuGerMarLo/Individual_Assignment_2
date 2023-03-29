Shader "Unlit/Water"
{
	Properties
	{
		_MainTex("Diffuse", 2D) = "white" {}
		_Tint("Colour Tint", Color) = (1,1,1,1)
		_Freq("Frequency", Range(0,5)) = 3
		_Speed("Speed", Range(0, 100)) = 10
		_Amp("Amplitude", Range(0,1)) = 0.5

		_RampTex("Ramp Texture", 2D) = "white" {}
	}
	SubShader
	{
		CGPROGRAM
		#pragma surface surf Lambert vertex:vert

		struct Input
		{
			float2 uv_MainTex;
			float3 vertColor;
		};

		float4 _Tint;
		float _Freq;
		float _Speed;
		float _Amp;

		sampler2D _RampTex;

		struct appdata
		{
			float4 vertex: POSITION;
			float3 normal: NORMAL;
			float4 texcoord: TEXCOORD0;
			float4 texcoord1: TEXCOORD1;
			float4 texcoord2: TEXCOORD2;
		};

		float4 LightingToonRamp(SurfaceOutput s, fixed3 lightDir, fixed atten)
		{
			half diff = dot(s.Normal, lightDir);
			half h = diff * 0.5 + 0.5;
			float2 rh = h;
			half3 ramp = tex2D(_RampTex, rh).rgb;
			half4 c;
			c.rgb = s.Albedo * _LightColor0.rgb * (ramp);
			c.a = s.Alpha;
			return c;
		}

		void vert(inout appdata v, out Input o)
		{
			UNITY_INITIALIZE_OUTPUT(Input, o);
			float t = _Time * _Speed;
			float waveHeight = sin(t + v.vertex.x * _Freq) * _Amp + sin(t * 2 + v.vertex.x * _Freq * 2) * _Amp;

			if (waveHeight > 0)
			{
				waveHeight = 1;
			}
			if (waveHeight < 0)
			{
				waveHeight = -1;
			}
			else
			{
				waveHeight = 0;
			}

			v.vertex.y = v.vertex.y + waveHeight;
			v.normal = normalize(float3 (v.normal.x + waveHeight, v.normal.y, v.normal.z));
			o.vertColor = waveHeight + 2;
		}

		sampler2D _MainTex;
		void surf(Input IN, inout SurfaceOutput o)
		{
			float4 c = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = c * IN.vertColor.rgb * _Tint.rgb;
		}
		ENDCG
	}
}
