#pragma once
class Player
{
public:
	Player();
	~Player();
	void Init();
	void Update();
	void Render();
private:
	SkinModel model;
	SkinModelData modelData;
	Animation animation;
	//ハンズオン 1-1
};

