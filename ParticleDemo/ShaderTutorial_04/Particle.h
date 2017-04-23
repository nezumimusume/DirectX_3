/*!
 * @brief	�p�[�e�B�N���B
 */
#ifndef _TKPARTICLE_H_
#define _TKPARTICLE_H_

#include "lib/tkPrimitive.h"
#include <d3dx9effect.h>

struct SParicleEmitParameter;
/*!
 * @brief	�p�[�e�B�N���B
 */
class CParticle{
	CPrimitive			primitive;			//!<�v���~�e�B�u�B
	LPDIRECT3DTEXTURE9	texture;			//!<�e�N�X�`���B
	ID3DXEffect*		shaderEffect;		//!<�V�F�[�_�[�G�t�F�N�g�B
	D3DXVECTOR3			moveSpeed;			//!<���x�B
	D3DXVECTOR3			position;			//!<���W�B
public:
	CParticle();
	~CParticle();
	void Init(const SParicleEmitParameter& param);
	void Update();
	void Render(const D3DXMATRIX& viewMatrix, const D3DXMATRIX& projMatrix) ;
};

#endif //_TKPARTICLE_H_