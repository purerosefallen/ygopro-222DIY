--炎剑斩
function c10173010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,10173010)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCost(c10173010.cost)
	e1:SetTarget(c10173010.target)
	e1:SetOperation(c10173010.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10173010,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,10173110)
	e2:SetCost(c10173010.cost)
	e2:SetTarget(c10173010.sptg)
	e2:SetOperation(c10173010.spop)
	c:RegisterEffect(e2)	
end
function c10173010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c10173010.rfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c10173010.rfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c10173010.rfilter3,tp,LOCATION_GRAVE,0,1,1,g1:GetFirst(),e,tp,g1:GetFirst())
	g1:Merge(g2)
	g1:AddCard(e:GetHandler())
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
end
function c10173010.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10173010.spfilter,tp,0x13,0,1,1,nil,e,tp,nil)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c10173010.rfilter2(c,e,tp)
	return c:IsRace(RACE_DRAGON) and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c10173010.rfilter3,tp,LOCATION_GRAVE,0,1,c,e,tp,c)
end
function c10173010.rfilter3(c,e,tp,rc)
	return c:IsRace(RACE_DRAGON) and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c10173010.spfilter,tp,0x13,0,1,c,e,tp,rc)
end
function c10173010.spfilter(c,e,tp,rc)
	return c:IsCode(10173011)and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c~=rc
end
function c10173010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c10173010.rfilter(c,e,tp)
	return bit.band(c:GetType(),0x40002)==0x40002 and c:IsFaceup() and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c10173010.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,e)
end
function c10173010.rmfilter(c,e)
	return c:IsAbleToRemove() and c:IsCanBeEffectTarget(e) and c~=e:GetHandler()
end
function c10173010.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return Duel.IsExistingMatchingCard(c10173010.rfilter,tp,LOCATION_SZONE,0,1,nil,e,tp)
		else
			return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
		end
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=Duel.SelectMatchingCard(tp,c10173010.rfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
		Duel.Remove(rg,POS_FACEUP,REASON_COST)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10173010.eqfilter(c)
	return bit.band(c:GetType(),0x40002)==0x40002 and c:IsAbleToHand()
end
function c10173010.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(c10173010.eqfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10173010,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)  
	end
end
