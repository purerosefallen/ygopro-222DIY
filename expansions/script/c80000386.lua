--Level Ball
function c80000386.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(80000386,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,80000386+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c80000386.cost1)
	e1:SetTarget(c80000386.target)
	e1:SetOperation(c80000386.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c80000386.cost)
	e2:SetTarget(c80000386.target1)
	e2:SetOperation(c80000386.activate1)
	c:RegisterEffect(e2)
end
function c80000386.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c80000386.filter11(c,e,tp)
	local lv=c:GetOriginalLevel()
	return lv>0 and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c80000386.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,lv)
end
function c80000386.spfilter(c,e,tp,lv)
	return c:IsSetCard(0x2d0) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c80000386.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.IsExistingMatchingCard(c80000386.filter11,tp,LOCATION_MZONE,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c80000386.filter11,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	e:SetLabel(g:GetFirst():GetOriginalLevel())
	Duel.SendtoGrave(g,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c80000386.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c80000386.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c80000386.cfilter1(c)
	return c:GetLevel()>0 and c:IsAbleToRemoveAsCost() and c:IsSetCard(0x2d0)
end
function c80000386.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.IsExistingMatchingCard(c80000386.cfilter1,tp,LOCATION_HAND,0,1,nil) then
			e:SetLabel(1)
			return true
		else
			return false
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c80000386.cfilter1,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabelObject(g:GetFirst())
	g:GetFirst():CreateEffectRelation(e)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c80000386.filter(c)
	return c:IsFaceup() and c:GetLevel()>0
end
function c80000386.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c80000386.filter(chkc) end
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.IsExistingTarget(c80000386.filter,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c80000386.filter,tp,LOCATION_MZONE,0,1,2,nil)
end
function c80000386.activate1(e,tp,eg,ep,ev,re,r,rp)
	local lc=e:GetLabelObject()
	if not lc:IsRelateToEffect(e) then return end
	local lv=lc:GetLevel()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	while tc do
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(lv)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
		end
		tc=g:GetNext()
	end
end