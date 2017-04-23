/*!
 *@brief	�ȒP�ȃf�B�t���[�Y���C�e�B���O+�X�y�L�����̃V�F�[�_�[�B
 */


float4x4 g_worldMatrix;			//���[���h�s��B
float4x4 g_viewMatrix;			//�r���[�s��B
float4x4 g_projectionMatrix;	//�v���W�F�N�V�����s��B
float4x4 g_rotationMatrix;		//��]�s��B�@������]�����邽�߂ɕK�v�ɂȂ�B���C�e�B���O����Ȃ�K�{�B

#define DIFFUSE_LIGHT_NUM	4		//�f�B�t���[�Y���C�g�̐��B
float4	g_diffuseLightDirection[DIFFUSE_LIGHT_NUM];	//�f�B�t���[�Y���C�g�̕����B
float4	g_diffuseLightColor[DIFFUSE_LIGHT_NUM];		//�f�B�t���[�Y���C�g�̃J���[�B
float4	g_ambientLight;								//�����B

texture g_diffuseTexture;		//�f�B�t���[�Y�e�N�X�`���B
sampler g_diffuseTextureSampler = 
sampler_state
{
	Texture = <g_diffuseTexture>;
    MipFilter = NONE;
    MinFilter = NONE;
    MagFilter = NONE;
    AddressU = Wrap;
	AddressV = Wrap;
};

struct VS_INPUT{
	float4	pos			: POSITION;
	float4	color		: COLOR0;
	float3	normal		: NORMAL0;
	float2	uv			: TEXCOORD0;
};

struct VS_OUTPUT{
	float4	pos			: POSITION;
	float4	color		: COLOR0;
	float2	uv			: TEXCOORD0;
	float3	normal		: TEXCOORD1;
	float4	worldPos 	: TEXCOORD2;		//���[���h��Ԃł̒��_���W�B
};

/*!
 *@brief	���_�V�F�[�_�[�B
 */
VS_OUTPUT VSMain( VS_INPUT In )
{
	VS_OUTPUT Out;
	float4 pos; 
	pos = mul( In.pos, g_worldMatrix );		//���f���̃��[�J����Ԃ��烏�[���h��Ԃɕϊ��B
	Out.worldPos = pos;
	pos = mul( pos, g_viewMatrix );			//���[���h��Ԃ���r���[��Ԃɕϊ��B
	pos = mul( pos, g_projectionMatrix );	//�r���[��Ԃ���ˉe��Ԃɕϊ��B
	Out.pos = pos;
	Out.color = In.color;
	Out.uv = In.uv;
	Out.normal = mul( In.normal, g_rotationMatrix );	//�@�����񂷁B
	return Out;
}
/*!
 *@brief	�f�B�t���[�Y���C�g���v�Z�B
 *@param[in]	normal	�@���B
 */
float3 CalcDiffuse( float3 normal )
{
	float3 diff = 0.0f;
	for( int i = 0; i < DIFFUSE_LIGHT_NUM; i++ ){
		diff += max( 0.0f, dot(normal.xyz, -g_diffuseLightDirection[i].xyz) ) 
				* g_diffuseLightColor[i].xyz;
	}
	return diff;
}

/*!
 *@brief	�s�N�Z���V�F�[�_�[�B
 */
float4 PSMain( VS_OUTPUT In ) : COLOR
{
	//���C�g���v�Z�B
	float4 lig = 0.0f;
	//�f�B�t���[�Y���C�g���v�Z�B
	lig.xyz = CalcDiffuse( In.normal );					
	//�����ɃX�y�L�������C�g�̎������L�q���Ȃ����B
	//���_�̃V�F�[�_�[�萔�͑��݂��Ȃ��̂ŁA�����Œǉ����s���悤�ɁB
	//���f���̃��[���h���_���W��In.worldPos�A���[���h�@����In.normal�B
	//���C�g�̕�����g_diffuseLightDirection[0]�Ƃ���B
	
	
	//�A���r�G���g���C�g�����Z�B
	lig += g_ambientLight;
	float4 color = tex2D( g_diffuseTextureSampler, In.uv );
	color.xyz *= lig;
	return color;
}

technique SkinModel
{
	pass p0
	{
		VertexShader 	= compile vs_2_0 VSMain();
		PixelShader 	= compile ps_2_0 PSMain();
	}
}