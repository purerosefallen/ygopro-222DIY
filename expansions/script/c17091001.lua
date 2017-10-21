--ユニコーンガンダム
local m=17091001
local cm=_G["c"..m]
cm.dfc_front_side=m
cm.dfc_back_side=m+1
function c17091001.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17091001,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c17091001.atkval)
	c:RegisterEffect(e1)
	--negate attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17091001,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCountLimit(1)
	e2:SetCondition(c17091001.negcon)
	e2:SetOperation(c17091001.negop)
	c:RegisterEffect(e2)
	--spsummon bgm
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(c17091001.sumsuc)
	c:RegisterEffect(e3)
end
function c17091001.atkval(e,c)
	return c:GetLinkedGroupCount()*600
end
function c17091001.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c17091001.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack() then
		local c=e:GetHandler()
		local tcode=c.dfc_back_side
		c:SetEntityCode(tcode,true)
		c:ReplaceEffect(tcode,0,0)
		Duel.Hint(11,0,aux.Stringid(17091001,3))
	end
end
function c17091001.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(11,0,aux.Stringid(17091001,2))
end	