--黑绳阎魔-乌莉丝
function c2117004.initial_effect(c)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2117004,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,2117004)
	e2:SetTarget(c2117004.distg)
	e2:SetOperation(c2117004.disop)
	c:RegisterEffect(e2)
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2117004,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,2117004)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetCondition(c2117004.atcon)
	e1:SetCost(c2117004.cost)
	e1:SetTarget(c2117004.destg)
	e1:SetOperation(c2117004.desop)
	c:RegisterEffect(e1)
end
function c2117004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c2117004.cyfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x21c)
end
function c2117004.atcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c2117004.cyfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c2117004.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function c2117004.cfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsFaceup()
end
function c2117004.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,2,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(c2117004.cfilter,nil)
	if ct~=0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c2117004.tgfilter1(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c2117004.tgfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_FIEND) and c:IsDestructable()
end
function c2117004.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c2117004.tgfilter2,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c2117004.tgfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,c2117004.tgfilter1,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c2117004.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end