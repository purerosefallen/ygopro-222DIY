--无道阎魔-乌莉丝
function c2117001.initial_effect(c)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2117001,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,2117001)
	e2:SetTarget(c2117001.distg)
	e2:SetOperation(c2117001.disop)
	c:RegisterEffect(e2)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2117001,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c2117001.cost)
	e2:SetCondition(c2117001.atcon)
	e2:SetOperation(c2117001.atop)
	c:RegisterEffect(e2)
end
function c2117001.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
end
function c2117001.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x21c) and c:IsAbleToGrave()
end
function c2117001.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,3,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(c2117001.cfilter,nil)
	if ct~=0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c2117001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c2117001.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x21c)
end
function c2117001.atcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c2117001.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c2117001.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end