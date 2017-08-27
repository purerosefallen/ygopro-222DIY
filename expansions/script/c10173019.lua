--坏炎火球
function c10173019.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCost(c10173019.cost)
	e1:SetTarget(c10173019.target)
	e1:SetOperation(c10173019.activate)
	c:RegisterEffect(e1)
end
function c10173019.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c10173019.desfilter1(c,e,tp)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL and aux.disfilter1(c) and Duel.IsExistingMatchingCard(c10173019.desfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,e)
end
function c10173019.desfilter2(c,e)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsCanBeEffectTarget(e) and aux.disfilter1(c)
end
function c10173019.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c10173019.desfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg1=Duel.SelectTarget(tp,c10173019.desfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg2=Duel.SelectTarget(tp,c10173019.desfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,sg1:GetFirst(),e)
	sg1:Merge(sg2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg1,sg1:GetCount(),0,0)
end
function c1005587.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()<=0 then return end
	local tc=sg:GetFirst()
	while tc do
	  if not tc:IsDisabled() then
		 local e1=Effect.CreateEffect(e:GetHandler())
		 e1:SetType(EFFECT_TYPE_SINGLE)
		 e1:SetCode(EFFECT_DISABLE)
		 e1:SetReset(RESET_EVENT+0x1fe0000)
		 tc:RegisterEffect(e1)
		 Duel.AdjustInstantly()
		 Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		 Duel.Destroy(tc,REASON_EFFECT)
	  end
	tc=sg:GetNext()
	end
end