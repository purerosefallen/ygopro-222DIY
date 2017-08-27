--1998 - 十六夜 被抛弃的木头 -
function c80006036.initial_effect(c)
	c:EnableReviveLimit()   
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2) 
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e1)
	--handes
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(80006036,0))
	e6:SetCategory(CATEGORY_HANDES)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_BATTLE_DAMAGE)
	e6:SetCondition(c80006036.condition)
	e6:SetTarget(c80006036.target)
	e6:SetOperation(c80006036.operation)
	c:RegisterEffect(e6)
end
function c80006036.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end
function c80006036.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c80006036.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c80006036.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(ep,LOCATION_HAND,0)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
end