--1998 - 十六夜 浸水的木头 -
function c80006048.initial_effect(c)
	c:EnableReviveLimit()   
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2) 
	--no battle damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	c:RegisterEffect(e4)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetValue(1)
	c:RegisterEffect(e3)  
	--pos
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(80006048,0))
	e5:SetCategory(CATEGORY_POSITION)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_DAMAGE_STEP_END)
	e5:SetTarget(c80006048.target)
	e5:SetOperation(c80006048.operation)
	c:RegisterEffect(e5) 
end
function c80006048.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=e:GetHandler():GetBattleTarget()
	if chk==0 then return tg and tg:IsRelateToBattle() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,tg,1,0,0)
end
function c80006048.operation(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle() and bc:IsFaceup() then
		Duel.ChangePosition(bc,POS_FACEDOWN_DEFENSE)
	end
end