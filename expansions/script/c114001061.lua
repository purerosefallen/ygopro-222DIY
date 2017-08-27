--円環の導き
function c114001061.initial_effect(c)
	--Activate
	--local e1=Effect.CreateEffect(c)
	--e1:SetDescription(aux.Stringid(114001061,0))
	--e1:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE)
	--e1:SetType(EFFECT_TYPE_ACTIVATE)
	--e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCountLimit(1,114001061+EFFECT_COUNT_CODE_OATH)
	--e1:SetTarget(c114001061.target)
	--e1:SetOperation(c114001061.activate)
	--c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(114001061,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,114001061+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c114001061.target2)
	e2:SetOperation(c114001061.activate2)
	c:RegisterEffect(e2)
end
function c114001061.filter(c)
	return c:IsAbleToRemove()
		and ( c:IsSetCard(0x223) or c:IsSetCard(0x224) or c:IsSetCard(0xcabb)
			or c:IsCode(36405256) or c:IsCode(54360049) or c:IsCode(37160778) or c:IsCode(27491571) or c:IsCode(80741828) or c:IsCode(90330453) --0x223
			or c:IsCode(32751480) or c:IsCode(78010363) or c:IsCode(39432962) or c:IsCode(67511500) or c:IsCode(62379337) or c:IsCode(23087070) or c:IsCode(17720747) or c:IsCode(98358303) or c:IsCode(91584698) ) --0x224
end
function c114001061.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingMatchingCard(c114001061.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function c114001061.activate(e,tp,eg,ep,ev,re,r,rp)
	local g3=Duel.GetMatchingGroup(c114001061.filter,tp,LOCATION_HAND,0,nil)
	if g3:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c114001061.filter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	Duel.Draw(tp,2,REASON_EFFECT)
end
function c114001061.filter2(c)
	return c:IsAbleToRemove()
		and ( c:IsSetCard(0x223) or c:IsSetCard(0x224)
			or c:IsCode(36405256) or c:IsCode(54360049) or c:IsCode(37160778) or c:IsCode(27491571) or c:IsCode(80741828) or c:IsCode(90330453) --0x223
			or c:IsCode(32751480) or c:IsCode(78010363) or c:IsCode(39432962) or c:IsCode(67511500) or c:IsCode(62379337) or c:IsCode(23087070) or c:IsCode(17720747) or c:IsCode(98358303) or c:IsCode(91584698) ) --0x224
end
function c114001061.filter3(c)
	return c:IsAbleToRemove() and c:IsSetCard(0xcabb)
end
function c114001061.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(c114001061.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(c114001061.filter3,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
	local g3=Duel.GetMatchingGroup(c114001061.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
	local gct1=g1:GetCount()
	local gct2=g2:GetCount()
	local gct3=g3:GetCount()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and gct1>0 and gct2>0 and gct3>1 end
	--Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_GRAVE)
end
function c114001061.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c114001061.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(c114001061.filter3,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
	local g3=Duel.GetMatchingGroup(c114001061.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
	local gct1=g1:GetCount()
	local gct2=g2:GetCount()
	local gct3=g3:GetCount()
	if gct1==0 or gct2==0 or gct3<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg1=Duel.SelectMatchingCard(tp,c114001061.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	local rg1tg=rg1:GetFirst()
	if c114001061.filter2(rg1tg) and c114001061.filter3(rg1tg) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg2=Duel.SelectMatchingCard(tp,c114001061.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,rg1tg)
		rg1:Merge(rg2)
	else
		if c114001061.filter2(rg1tg) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local rg2=Duel.SelectMatchingCard(tp,c114001061.filter3,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,rg1tg)
			rg1:Merge(rg2)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local rg2=Duel.SelectMatchingCard(tp,c114001061.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,rg1tg)
			rg1:Merge(rg2)
		end
	end
	Duel.Remove(rg1,POS_FACEUP,REASON_EFFECT)
	Duel.Draw(tp,2,REASON_EFFECT)
end