--幻想曲的初章
function c60150519.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xab20),10,2)
	c:EnableReviveLimit()
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c60150519.atktarget)
	c:RegisterEffect(e2)
	--negate
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(88177324,0))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetHintTiming(0,0x1e0)
	e5:SetCost(c60150519.negcost)
	e5:SetTarget(c60150519.negtg)
	e5:SetOperation(c60150519.negop)
	c:RegisterEffect(e5)
end
function c60150519.atktarget(e,c)
	return c:IsPosition(POS_FACEUP) and (c:GetAttack()~=c:GetBaseAttack() or c:GetDefense()~=c:GetBaseDefense())
end
function c60150519.filter2(c)
	return c:IsFaceup() and (c:GetAttack()~=c:GetBaseAttack() or c:GetDefense()~=c:GetBaseDefense())
end
function c60150519.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c60150519.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
		Duel.IsExistingMatchingCard(c60150519.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler())
	end
end
function c60150519.negop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c60150519.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:GetAttack()~=tc:GetBaseAttack() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(tc:GetBaseAttack())
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
		end
		if tc:GetDefense()~=tc:GetBaseDefense() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e1:SetValue(tc:GetBaseDefense())
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
		end
		tc=g:GetNext()
	end
end