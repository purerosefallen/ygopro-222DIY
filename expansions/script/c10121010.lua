--凯恩之书
function c10121010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10121010+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c10121010.target)
	e1:SetOperation(c10121010.activate)
	c:RegisterEffect(e1)	
end

function c10121010.filter(c)
	return c:IsRace(RACE_FAIRY+RACE_FIEND) and c:IsDestructable()
end

function c10121010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10121010.filter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,2,0,0)
end

function c10121010.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg1=Duel.GetMatchingGroup(c10121010.filter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	local dg2=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
		if dg1:GetCount()<=0 or dg2:GetCount()<=0 then return end
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		 local sg1=dg1:Select(tp,1,1,nil)
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		 local sg2=dg2:Select(tp,1,1,nil)
		 sg1:Merge(sg2)
		 Duel.HintSelection(sg1)
		 Duel.Destroy(sg1,REASON_EFFECT)
end
