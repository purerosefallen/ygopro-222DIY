--开海 海水分开之日
function c21990011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c21990011.condition)
	e1:SetTarget(c21990011.target)
	e1:SetOperation(c21990011.activate)
	c:RegisterEffect(e1)
end
function c21990011.cfilter(c)
	return c:IsCode(21990001) and c:IsFaceup()
end
function c21990011.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c21990011.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c21990011.filter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c21990011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c21990011.filter,tp,0,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(c21990011.filter,tp,0,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c21990011.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c21990011.filter,tp,0,LOCATION_ONFIELD,e:GetHandler())
	if sg:GetCount()>0 then
		local ct=Duel.Destroy(sg,REASON_EFFECT)
	end
end